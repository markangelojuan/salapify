enum ActivityType {
  message,
  billAdded,
  paymentMarked,
  paymentConfirmed,
  paymentDisputed,
  memberAdded,
  poke,
  photo
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
    this.isUploading = false,
    this.uploadFailed = false,
  });

  final String id;
  final String groupId;
  final String senderId;
  final ActivityType type;
  final DateTime createdAt;

  final String? text; // for ActivityType.message
  final Map<String, dynamic>? metadata; // for system events: {billTitle, amount, targetUserId}

  // Optimistic-send-only flags (photo). Never persisted to Firestore —
  // only ever set locally by ActivityFeed while an upload is in flight.
  final bool isUploading;
  final bool uploadFailed;

  ActivityEntry copyWith({
    String? id,
    String? groupId,
    String? senderId,
    ActivityType? type,
    DateTime? createdAt,
    String? text,
    Map<String, dynamic>? metadata,
    bool? isUploading,
    bool? uploadFailed,
  }) {
    return ActivityEntry(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      text: text ?? this.text,
      metadata: metadata ?? this.metadata,
      isUploading: isUploading ?? this.isUploading,
      uploadFailed: uploadFailed ?? this.uploadFailed,
    );
  }
}