enum BudgetCategoryType {
  fixed,
  flexible;

  static BudgetCategoryType fromString(String value) {
    return BudgetCategoryType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown BudgetCategoryType: $value'),
    );
  }
}