enum BudgetFrequency {
  monthly,
  biMonthly,
  once;

  static BudgetFrequency fromString(String value) {
    return BudgetFrequency.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown BudgetFrequency: $value'),
    );
  }
}

enum BudgetPeriod {
  firstHalf,
  secondHalf,
  both;

  static BudgetPeriod fromString(String value) {
    return BudgetPeriod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown BudgetPeriod: $value'),
    );
  }
}