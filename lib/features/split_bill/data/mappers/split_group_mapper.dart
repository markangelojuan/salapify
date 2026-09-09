// lib/features/split_bill/data/mappers/split_group_mapper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';

extension SplitGroupMapper on SplitGroup {
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'memberIds': memberIds,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActivityAt': Timestamp.fromDate(lastActivityAt),
      'unreadCounts': unreadCounts,
    };
  }

  static SplitGroup fromFirestore(String id, Map<String, dynamic> data) {
    final createdAt = (data['createdAt'] as Timestamp).toDate();
   
    final lastActivityAt =
        (data['lastActivityAt'] as Timestamp?)?.toDate() ?? createdAt;
    final rawUnread = data['unreadCounts'] as Map<String, dynamic>?;

    return SplitGroup(
      id: id,
      name: data['name'] as String,
      memberIds: List<String>.from(data['memberIds'] as List),
      createdBy: data['createdBy'] as String,
      createdAt: createdAt,
      lastActivityAt: lastActivityAt,
      unreadCounts: rawUnread == null
          ? const {}
          : rawUnread.map((k, v) => MapEntry(k, (v as num).toInt())),
    );
  }
}