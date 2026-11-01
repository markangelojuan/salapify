enum IncomeFrequency {
  once,
  monthly,
  biMonthly;

  static IncomeFrequency fromString(String value) {
    return IncomeFrequency.values.firstWhere(
      (f) => f.name == value,
      orElse: () => IncomeFrequency.once,
    );
  }
}