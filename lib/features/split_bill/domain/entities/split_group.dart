class SplitGroup {
  const SplitGroup({
    required this.id,
    required this.name,
    required this.memberIds,
    required this.createdBy,
    required this.createdAt,
    required this.lastActivityAt,
    this.unreadCounts = const {},
  });

  final String id;
  final String name;
  final List<String> memberIds; // user IDs
  final String createdBy;
  final DateTime createdAt;

  final DateTime lastActivityAt;


  final Map<String, int> unreadCounts;

  SplitGroup copyWith({
    String? id,
    String? name,
    List<String>? memberIds,
    String? createdBy,
    DateTime? createdAt,
    DateTime? lastActivityAt,
    Map<String, int>? unreadCounts,
  }) {
    return SplitGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      memberIds: memberIds ?? this.memberIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      unreadCounts: unreadCounts ?? this.unreadCounts,
    );
  }
}