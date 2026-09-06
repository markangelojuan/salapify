enum IncomePeriod {
  firstHalf,
  secondHalf,
  both;

  static IncomePeriod fromString(String value) {
    return IncomePeriod.values.firstWhere(
      (p) => p.name == value,
      orElse: () => IncomePeriod.both,
    );
  }
}