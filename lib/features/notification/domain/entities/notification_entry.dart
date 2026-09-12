enum NotificationType {
  addedToGroup,
  billAdded,
  paymentMarked,
  paymentConfirmed,
  paymentDisputed,
}

class NotificationEntry {
  const NotificationEntry({
    required this.id,
    required this.type,
    required this.groupId,
    required this.groupName,
    required this.senderId,
    required this.senderName,
    required this.read,
    required this.createdAt,
    this.metadata,
  });

  final String id;
  final NotificationType type;
  final String groupId;
  final String groupName;
  final String senderId;
  final String senderName;
  final bool read;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  NotificationEntry copyWith({
    String? id,
    NotificationType? type,
    String? groupId,
    String? groupName,
    String? senderId,
    String? senderName,
    bool? read,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}