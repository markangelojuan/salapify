const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

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
    if (!notif.notificationType) return; // unrecognized/unsupported type, skip silently

    const createdAt = activity.createdAt || admin.firestore.Timestamp.now();

    // Write a persisted notification doc per recipient + collect their tokens
    const tokens = [];
    await Promise.all(
      recipientIds.map(async (uid) => {
        const userDoc = await db.collection("users").doc(uid).get();
        const userData = userDoc.data();
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