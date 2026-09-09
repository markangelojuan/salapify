// lib/features/split_bill/domain/entities/activity_entry.dart
enum ActivityType {
  message,
  billAdded,
  paymentMarked,
  paymentConfirmed,
  paymentDisputed,
}

class ActivityEntry {
  const ActivityEntry({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.type,
    required this.createdAt,
    this.text,
    this.metadata,
  });

  final String id;
  final String groupId;
  final String senderId;
  final ActivityType type;
  final DateTime createdAt;

  final String? text; // for ActivityType.message
  final Map<String, dynamic>? metadata; // for system events: {billTitle, amount, targetUserId}

  ActivityEntry copyWith({
    String? id,
    String? groupId,
    String? senderId,
    ActivityType? type,
    DateTime? createdAt,
    String? text,
    Map<String, dynamic>? metadata,
  }) {
    return ActivityEntry(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      text: text ?? this.text,
      metadata: metadata ?? this.metadata,
    );
  }
}