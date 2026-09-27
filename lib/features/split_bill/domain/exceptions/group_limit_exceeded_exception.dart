class GroupLimitExceededException implements Exception {
  const GroupLimitExceededException(this.limit);
  final int limit;

  @override
  String toString() => 'You can only have $limit active groups on the free plan';
}

class MaxGroupMembersExceededException implements Exception {
  const MaxGroupMembersExceededException(this.limit);
  final int limit;

  @override
  String toString() => 'Groups can have at most $limit members';
}

