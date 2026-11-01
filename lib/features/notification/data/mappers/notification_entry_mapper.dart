import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salapify/features/notification/domain/entities/notification_entry.dart';

extension NotificationEntryMapper on NotificationEntry {
  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'groupId': groupId,
      'groupName': groupName,
      'senderId': senderId,
      'senderName': senderName,
      'read': read,
      'createdAt': Timestamp.fromDate(createdAt),
      'metadata': metadata,
    };
  }

  static NotificationEntry fromFirestore(String id, Map<String, dynamic> data) {
    return NotificationEntry(
      id: id,
      type: NotificationType.values.byName(data['type'] as String),
      groupId: data['groupId'] as String,
      groupName: data['groupName'] as String,
      senderId: data['senderId'] as String,
      senderName: data['senderName'] as String,
      read: data['read'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }
}