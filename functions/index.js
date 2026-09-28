const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const functionsV1 = require("firebase-functions/v1");
const { google } = require("googleapis");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

const PLAY_SERVICE_ACCOUNT_KEY = defineSecret("PLAY_SERVICE_ACCOUNT_KEY");

const ANDROID_PACKAGE_NAME = "com.mrkj.salapify";

const NOTIFY_TYPES = new Set([
  "billAdded",
  "memberAdded",
  "paymentMarked",
  "paymentConfirmed",
  "paymentDisputed",
]);

const MAX_MENTIONS_PER_MESSAGE = 5;
const EVERYONE_ID = "__everyone__";

function mentionedIds(activity) {
  const list = Array.isArray(activity.metadata?.mentions)
    ? activity.metadata.mentions
    : [];
  return list
    .map((m) => m && m.userId)
    .filter((id) => typeof id === "string");
}

function mentionsEveryone(activity) {
  return mentionedIds(activity).includes(EVERYONE_ID);
}

exports.onActivityCreated = onDocumentCreated(
  "splitGroups/{groupId}/activity/{activityId}",
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const activity = snap.data();
    const { groupId } = event.params;


    const hasMentions =
      activity.type === "message" &&
      Array.isArray(activity.metadata?.mentions) &&
      activity.metadata.mentions.length > 0;
    if (!NOTIFY_TYPES.has(activity.type) && !hasMentions) return;

    const groupDoc = await db.collection("splitGroups").doc(groupId).get();
    if (!groupDoc.exists) return;
    const group = groupDoc.data();

    const recipientIds = resolveRecipients(activity, group);
    if (recipientIds.length === 0) return;

    const senderDoc = await db.collection("users").doc(activity.senderId).get();
    const senderName = senderDoc.data()?.username || "Someone";

    const notif = buildNotification(activity, senderName, group.name);
    if (!notif.notificationType) return;

    const createdAt = activity.createdAt || admin.firestore.Timestamp.now();

    const tokens = [];
    await Promise.all(
      recipientIds.map(async (uid) => {
        const userDoc = await db.collection("users").doc(uid).get();
        const userData = userDoc.data();

        // Either direction blocks notifications both ways.
        const blockedUserIds = userData?.blockedUserIds || [];
        const blockedByUserIds = userData?.blockedByUserIds || [];
        const isBlockedPair =
          blockedUserIds.includes(activity.senderId) ||
          blockedByUserIds.includes(activity.senderId);
        if (isBlockedPair) return; // skip: no notification doc, no push

        const userTokens = userData?.fcmTokens || [];
        tokens.push(...userTokens);

        // Mentions are push-only
        if (notif.notificationType === "mention") return;

        await db
          .collection("notifications")
          .doc(uid)
          .collection("items")
          .add({
            type: notif.notificationType,
            groupId,
            groupName: group.name,
            senderId: activity.senderId,
            senderName,
            read: false,
            createdAt,
            metadata: activity.metadata || null,
          });
      })
    );

    if (tokens.length === 0) return;

    await messaging.sendEachForMulticast({
      tokens,
      notification: { title: notif.title, body: notif.body },
      
      android: { notification: { channelId: "default_channel" } },
      data: { groupId, type: activity.type || "" },
    });
  }
);

/** Who should be notified for this activity type — deliberately narrow
 * per event, not "everyone in the group except the sender". */
function resolveRecipients(activity, group) {
  const memberIds = group.memberIds || [];
  const others = memberIds.filter((id) => id !== activity.senderId);

  switch (activity.type) {
    case "message": {
      // Only people explicitly @mentioned. Intersecting with memberIds
      // ignores forged/non-member ids; capped to limit fan-out.
      // Sender must be a current member, so outsiders can't trigger pushes.
      if (!memberIds.includes(activity.senderId)) return [];
      // "@everyone" notifies every other member.
      if (mentionsEveryone(activity)) return others.slice(0, 50);
      const mentioned = new Set(mentionedIds(activity));
      return memberIds
        .filter((id) => mentioned.has(id) && id !== activity.senderId)
        .slice(0, MAX_MENTIONS_PER_MESSAGE);
    }
    case "billAdded":
    case "memberAdded":
      return others;
    case "paymentMarked": {
      const payerId = activity.metadata?.payerId;
      return payerId && payerId !== activity.senderId ? [payerId] : [];
    }
    case "paymentConfirmed":
    case "paymentDisputed": {
      const targetId = activity.metadata?.targetUserId;
      return targetId && targetId !== activity.senderId ? [targetId] : [];
    }
    default:
      return [];
  }
}

function buildNotification(activity, senderName, groupName) {
  switch (activity.type) {
    case "message": {
      const preview = (activity.text || "").slice(0, 80);
      return {
        notificationType: "mention",
        title: groupName,
        body: mentionsEveryone(activity)
          ? `${senderName} mentioned everyone: ${preview}`
          : `${senderName} mentioned you: ${preview}`,
      };
    }
    case "billAdded": {
      const billTitle = activity.metadata?.billTitle || "a bill";
      return {
        notificationType: "billAdded",
        title: groupName,
        body: `${senderName} added "${billTitle}"`,
      };
    }
    case "memberAdded":
      return {
        notificationType: "addedToGroup",
        title: groupName,
        body: `${senderName} added you to the group`,
      };
    case "paymentMarked":
      return {
        notificationType: "paymentMarked",
        title: groupName,
        body: `${senderName} marked their share as paid`,
      };
    case "paymentConfirmed":
      return {
        notificationType: "paymentConfirmed",
        title: groupName,
        body: `${senderName} confirmed your payment`,
      };
    case "paymentDisputed":
      return {
        notificationType: "paymentDisputed",
        title: groupName,
        body: `${senderName} disputed your payment`,
      };
    default:
      return { notificationType: null, title: null, body: null };
  }
}

// verifies a Play Billing purchase and grants entitlement

exports.verifyPurchase = onCall(
  { secrets: [PLAY_SERVICE_ACCOUNT_KEY] },
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
      throw new HttpsError("unauthenticated", "Must be signed in.");
    }

    const { productId, purchaseToken } = request.data || {};
    if (!productId || !purchaseToken) {
      throw new HttpsError(
        "invalid-argument",
        "productId and purchaseToken are required."
      );
    }
    
    // Only the product(s) you actually sell — prevents a forged call from
    // claiming premium via an arbitrary productId string.
    const ALLOWED_PRODUCT_IDS = new Set(["premium_upgrade"]);
    if (!ALLOWED_PRODUCT_IDS.has(productId)) {
      throw new HttpsError("invalid-argument", "Unknown productId.");
    }

    // ── 1. Authenticate to the Android Publisher API ──────────────────────
    const credentials = JSON.parse(PLAY_SERVICE_ACCOUNT_KEY.value());
    const auth = new google.auth.GoogleAuth({
      credentials,
      scopes: ["https://www.googleapis.com/auth/androidpublisher"],
    });
    const androidpublisher = google.androidpublisher({ version: "v3", auth });

    // ── 2. Verify the purchase token with Google Play ──────────────────────
    let purchase;
    try {
      const res = await androidpublisher.purchases.products.get({
        packageName: ANDROID_PACKAGE_NAME,
        productId,
        token: purchaseToken,
      });
      purchase = res.data;
    } catch (err) {
      console.error("Play verification failed", err?.message || err);
      throw new HttpsError("permission-denied", "Could not verify purchase.");
    }

    // purchaseState: 0 = purchased, 1 = canceled, 2 = pending
    if (purchase.purchaseState !== 0) {
      throw new HttpsError(
        "failed-precondition",
        `Purchase not in a valid state (state=${purchase.purchaseState}).`
      );
    }

    // ── 3. Claim the token atomically — blocks replay & double-redemption ──
    const tokenRef = db.collection("processedPurchaseTokens").doc(purchaseToken);
    const userRef = db.collection("users").doc(uid);

    await db.runTransaction(async (tx) => {
      const tokenDoc = await tx.get(tokenRef);
      if (tokenDoc.exists) {
        const existingUid = tokenDoc.data().uid;
        if (existingUid !== uid) {
          // The token is claimed by a different uid. That's only a real
          // conflict if that account still exists — if it was deleted
          // (e.g. user deleted their account and signed up again), the
          // token is orphaned and safe to reclaim for the new uid.
          const oldUserDoc = await tx.get(db.collection("users").doc(existingUid));
          if (oldUserDoc.exists) {
            throw new HttpsError(
              "already-exists",
              "This purchase has already been redeemed by another account."
            );
          }
          // else: fall through and reclaim below.
        }
        // Same uid re-submitting (e.g. retry after a dropped response), or
        // reclaimed from a deleted account — fine, fall through.
      }

      tx.set(tokenRef, {
        uid,
        productId,
        claimedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      tx.set(
        userRef,
        {
          isPremium: true,
          premiumSince: admin.firestore.FieldValue.serverTimestamp(),
          premiumProductId: productId,
        },
        { merge: true }
      );
    });

    // ── 4. Acknowledge with Google Play (must happen within 3 days or it auto-refunds) ──
    if (purchase.acknowledgementState === 0) {
      try {
        await androidpublisher.purchases.products.acknowledge({
          packageName: ANDROID_PACKAGE_NAME,
          productId,
          token: purchaseToken,
          requestBody: {},
        });
      } catch (err) {
        // Entitlement is already granted in Firestore at this point — an ack
        // failure shouldn't undo that. Log loudly so you can investigate/retry.
        console.error("Acknowledge failed after granting entitlement", err?.message || err);
      }
    }

    return { success: true, productId };
  }
);

// Frees up any purchase tokens this uid claimed, so a resignup with the
// same Play account can reclaim entitlement instead of permanently hitting
// "already redeemed by another account" in verifyPurchase. Runs on Auth
// user deletion rather than client-side so it can't be skipped by a
// crashed/killed app mid-deletion.
exports.cleanupPurchaseTokensOnUserDelete = functionsV1.auth
  .user()
  .onDelete(async (user) => {
    const tokensSnap = await db
      .collection("processedPurchaseTokens")
      .where("uid", "==", user.uid)
      .get();

    if (tokensSnap.empty) return;

    const batch = db.batch();
    tokensSnap.docs.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();
  });