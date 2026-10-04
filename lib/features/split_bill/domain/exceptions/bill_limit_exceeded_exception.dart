class BillLimitExceededException implements Exception {
  const BillLimitExceededException(this.limit);
  final int limit;

  @override
  String toString() =>
      'This group has reached its limit of $limit ${limit == 1 ? 'bill' : 'bills'}';
}
