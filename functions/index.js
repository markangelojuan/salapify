const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const functionsV1 = require("firebase-functions/v1");
const { google } = require("googleapis");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

const PLAY_SERVICE_ACCOUNT_KEY = defineSecret("PLAY_SERVICE_ACCOUNT_KEY");
const GMAIL_APP_PASS = defineSecret("GMAIL_APP_PASS");

const SENDER_EMAIL = "mark1.notifier@gmail.com";
const ADMIN_EMAIL = "support@salapify.co.uk";

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

// ---------------------------------------------------------------------------
// Push text, per language
// ---------------------------------------------------------------------------

// Keys must match the base `languageCode` the app stores on users/{uid}
// (en, es, th, zh, tr). Anything else falls back to English.
const MESSAGES = {
  en: {
    someone: "Someone",
    aBill: "a bill",
    mentionedEveryone: (s, p) => `${s} mentioned everyone: ${p}`,
    mentionedYou: (s, p) => `${s} mentioned you: ${p}`,
    billAdded: (s, t) => `${s} added "${t}"`,
    addedToGroup: (s) => `${s} added you to the group`,
    paymentMarked: (s) => `${s} marked their share as paid`,
    paymentConfirmed: (s) => `${s} confirmed your payment`,
    paymentDisputed: (s) => `${s} disputed your payment`,
  },
  es: {
    someone: "Alguien",
    aBill: "una cuenta",
    mentionedEveryone: (s, p) => `${s} mencionó a todos: ${p}`,
    mentionedYou: (s, p) => `${s} te mencionó: ${p}`,
    billAdded: (s, t) => `${s} añadió "${t}"`,
    addedToGroup: (s) => `${s} te añadió al grupo`,
    paymentMarked: (s) => `${s} marcó su parte como pagada`,
    paymentConfirmed: (s) => `${s} confirmó tu pago`,
    paymentDisputed: (s) => `${s} disputó tu pago`,
  },
  th: {
    someone: "ใครบางคน",
    aBill: "บิล",
    mentionedEveryone: (s, p) => `${s} กล่าวถึงทุกคน: ${p}`,
    mentionedYou: (s, p) => `${s} กล่าวถึงคุณ: ${p}`,
    billAdded: (s, t) => `${s} เพิ่ม "${t}"`,
    addedToGroup: (s) => `${s} เพิ่มคุณเข้ากลุ่ม`,
    paymentMarked: (s) => `${s} ทำเครื่องหมายว่าจ่ายส่วนของตนแล้ว`,
    paymentConfirmed: (s) => `${s} ยืนยันการชำระเงินของคุณ`,
    paymentDisputed: (s) => `${s} โต้แย้งการชำระเงินของคุณ`,
  },
  zh: {
    someone: "某人",
    aBill: "一筆帳單",
    mentionedEveryone: (s, p) => `${s} 提到了所有人：${p}`,
    mentionedYou: (s, p) => `${s} 提到了你：${p}`,
    billAdded: (s, t) => `${s} 新增了「${t}」`,
    addedToGroup: (s) => `${s} 將你加入群組`,
    paymentMarked: (s) => `${s} 已將自己的份額標記為已付款`,
    paymentConfirmed: (s) => `${s} 確認了你的付款`,
    paymentDisputed: (s) => `${s} 對你的付款提出異議`,
  },
  tr: {
    someone: "Biri",
    aBill: "bir hesap",
    mentionedEveryone: (s, p) => `${s} herkesi etiketledi: ${p}`,
    mentionedYou: (s, p) => `${s} seni etiketledi: ${p}`,
    billAdded: (s, t) => `${s} "${t}" ekledi`,
    addedToGroup: (s) => `${s} seni gruba ekledi`,
    paymentMarked: (s) => `${s} payını ödenmiş olarak işaretledi`,
    paymentConfirmed: (s) => `${s} ödemeni onayladı`,
    paymentDisputed: (s) => `${s} ödemene itiraz etti`,
  },
};

/** "es", "es-MX", "zh_Hant_TW" -> "es" / "zh". Unknown or missing -> "en". */
function resolveLang(code) {
  const base = String(code || "").toLowerCase().split(/[-_]/)[0];
  return MESSAGES[base] ? base : "en";
}

/** Language-independent type stored on the in-app notification doc. */
function notificationType(activity) {
  switch (activity.type) {
    case "message":
      return "mention";
    case "billAdded":
      return "billAdded";
    case "memberAdded":
      return "addedToGroup";
    case "paymentMarked":
      return "paymentMarked";
    case "paymentConfirmed":
      return "paymentConfirmed";
    case "paymentDisputed":
      return "paymentDisputed";
    default:
      return null;
  }
}

function buildBody(activity, senderName, lang) {
  const t = MESSAGES[lang] || MESSAGES.en;
  switch (activity.type) {
    case "message": {
      const preview = (activity.text || "").slice(0, 80);
      return mentionsEveryone(activity)
        ? t.mentionedEveryone(senderName, preview)
        : t.mentionedYou(senderName, preview);
    }
    case "billAdded":
      return t.billAdded(senderName, activity.metadata?.billTitle || t.aBill);
    case "memberAdded":
      return t.addedToGroup(senderName);
    case "paymentMarked":
      return t.paymentMarked(senderName);
    case "paymentConfirmed":
      return t.paymentConfirmed(senderName);
    case "paymentDisputed":
      return t.paymentDisputed(senderName);
    default:
      return "";
  }
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

    const type = notificationType(activity);
    if (!type) return;

    const senderDoc = await db.collection("users").doc(activity.senderId).get();
    const username = senderDoc.data()?.username;

    const createdAt = activity.createdAt || admin.firestore.Timestamp.now();

    // Tokens grouped by the recipient's language, so each group gets the
    // push text in its own language.
    const tokensByLang = {};
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
        const lang = resolveLang(userData?.languageCode);
        (tokensByLang[lang] = tokensByLang[lang] || []).push(...userTokens);

        // Mentions are push-only
        if (type === "mention") return;

        await db
          .collection("notifications")
          .doc(uid)
          .collection("items")
          .add({
            type,
            groupId,
            groupName: group.name,
            senderId: activity.senderId,
            // Empty when the sender no longer exists: the app then shows its
            // own translated "Deleted user" label instead of English text.
            senderName: username || "Someone",
            read: false,
            createdAt,
            metadata: activity.metadata || null,
          });
      })
    );

    await Promise.all(
      Object.entries(tokensByLang).map(([lang, tokens]) => {
        if (tokens.length === 0) return Promise.resolve();
        const t = MESSAGES[lang];
        return messaging.sendEachForMulticast({
          tokens,
          notification: {
            title: group.name,
            body: buildBody(activity, username || t.someone, lang),
          },

          android: { notification: { channelId: "default_channel" } },
          data: { groupId, type: activity.type || "" },
        });
      })
    );
  }
);

//emails the support whenever a new report is created in /reports.
exports.onReportCreated = onDocumentCreated(
  { document: "reports/{reportId}", secrets: [GMAIL_APP_PASS] },
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const report = snap.data();
    const { reportId } = event.params;

    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: { user: SENDER_EMAIL, pass: GMAIL_APP_PASS.value() },
    });

    // Plain text only, so user-submitted content can't inject HTML.
    const lines = Object.entries(report).map(([key, value]) => {
      const text =
        value && typeof value.toDate === "function"
          ? value.toDate().toISOString() // Firestore Timestamp
          : typeof value === "object"
          ? JSON.stringify(value)
          : String(value);
      return `${key}: ${text.slice(0, 1000)}`;
    });

    // Change these fields to whatever best summarizes your reports.
    const subjectHint = String(
      report.reason || report.type || reportId
    ).slice(0, 80);

    try {
      await transporter.sendMail({
        from: `"Salapify Reports" <${SENDER_EMAIL}>`,
        to: ADMIN_EMAIL,
        subject: `New report: ${subjectHint}`,
        text: `Report ID: ${reportId}\n\n${lines.join("\n")}`,
      });
    } catch (err) {
      console.error("Failed to send report email", err?.message || err);
    }
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