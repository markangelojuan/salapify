class BillLimitExceededException implements Exception {
  const BillLimitExceededException(this.limit);
  final int limit;

  @override
  String toString() => 'BillLimitExceededException(limit: $limit)';
}