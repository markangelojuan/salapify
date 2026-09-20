class CategoryLimitExceededException implements Exception {
  const CategoryLimitExceededException(this.limit);
  final int limit;

  @override
  String toString() => 'CategoryLimitExceededException(limit: $limit)';
}