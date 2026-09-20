class GroupLimitExceededException implements Exception {
  const GroupLimitExceededException(this.limit);
  final int limit;

  @override
  String toString() => 'GroupLimitExceededException(limit: $limit)';
}