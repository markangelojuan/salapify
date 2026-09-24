const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const { google } = require("googleapis");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

const PLAY_SERVICE_ACCOUNT_KEY = defineSecret("PLAY_SERVICE_ACCOUNT_KEY");

const ANDROID_PACKAGE_NAME = "com.mrkj.salapify";


exports.onActivityCreated = onDocumentCreated(
  "splitGroups/{groupId}/activity/{activityId}",
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const activity = snap.data();
    const { groupId } = event.params;

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
    case "message":
      return []; // push-only, handled separately if you re-add message pushes; no notification-list entry
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
    console.log("DEBUG purchaseToken:", purchaseToken);
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
          throw new HttpsError(
            "already-exists",
            "This purchase has already been redeemed by another account."
          );
        }
        // Same uid re-submitting (e.g. retry after a dropped response) — fine, fall through.
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