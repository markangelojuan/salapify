const { onDocumentCreated } = require("firebase-functions/v2/firestore");
// const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

// ── Activity notifications: messages, bills, payment events ──
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

    const recipientIds = (group.memberIds || []).filter(
      (id) => id !== activity.senderId
    );
    if (recipientIds.length === 0) return;

    const senderDoc = await db.collection("users").doc(activity.senderId).get();
    const senderName = senderDoc.data()?.username || "Someone";

    const { title, body } = buildNotification(activity, senderName, group.name);
    if (!title) return; // unrecognized type, skip silently

    const tokens = [];
    await Promise.all(
      recipientIds.map(async (uid) => {
        const userDoc = await db.collection("users").doc(uid).get();
        const userTokens = userDoc.data()?.fcmTokens || [];
        tokens.push(...userTokens);
      })
    );
    if (tokens.length === 0) return;

    await messaging.sendEachForMulticast({
      tokens,
      notification: { title, body },
      data: { groupId, type: activity.type || "" },
    });
  }
);

function buildNotification(activity, senderName, groupName) {
  switch (activity.type) {
    case "message":
      return { title: groupName, body: `${senderName}: ${activity.text || ""}` };
    case "billAdded": {
      const billTitle = activity.metadata?.billTitle || "a bill";
      return { title: groupName, body: `${senderName} added "${billTitle}"` };
    }
    case "paymentMarked":
      return { title: groupName, body: `${senderName} marked their share as paid` };
    case "paymentConfirmed":
      return { title: groupName, body: `${senderName} confirmed a payment` };
    case "paymentDisputed":
      return { title: groupName, body: `${senderName} disputed a payment` };
    default:
      return { title: null, body: null };
  }
}

// ── Budget reminder: simple daily nudge, not tied to split-bill data ──
// Commented out for now — re-enable when ready.
// exports.budgetReminder = onSchedule("every day 20:00", async () => {
//   const usersSnap = await db.collection("users").get();
//   const tokens = [];
//   usersSnap.forEach((doc) => {
//     const t = doc.data().fcmTokens;
//     if (Array.isArray(t)) tokens.push(...t);
//   });
//   if (tokens.length === 0) return;
//
//   for (let i = 0; i < tokens.length; i += 500) {
//     const chunk = tokens.slice(i, i + 500);
//     await messaging.sendEachForMulticast({
//       tokens: chunk,
//       notification: {
//         title: "Budget Reminder",
//         body: "Don't forget to log today's expenses!",
//       },
//     });
//   }
// });