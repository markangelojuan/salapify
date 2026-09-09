// lib/features/split_bill/data/mappers/activity_entry_mapper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salapify/features/split_bill/domain/entities/activity_entry.dart';

extension ActivityEntryMapper on ActivityEntry {
  Map<String, dynamic> toFirestore() {
    return {
      'groupId': groupId,
      'senderId': senderId,
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'text': text,
      'metadata': metadata,
    };
  }

  static ActivityEntry fromFirestore(String id, Map<String, dynamic> data) {
    return ActivityEntry(
      id: id,
      groupId: data['groupId'] as String,
      senderId: data['senderId'] as String,
      type: ActivityType.values.byName(data['type'] as String),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      text: data['text'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }
}