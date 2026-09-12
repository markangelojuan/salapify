enum AppCurrency {
  php('₱', 'Philippine Peso', 2),
  usd('\$', 'US Dollar', 2),
  aud('A\$', 'Australian Dollar', 2),
  sgd('S\$', 'Singapore Dollar', 2),
  twd('NT\$', 'New Taiwan Dollar', 2),
  eur('€', 'Euro', 2),
  thb('฿', 'Thai Baht', 2);

  const AppCurrency(this.symbol, this.label, this.decimalDigits);

  final String symbol;
  final String label;

  /// JPY and KRW aren't subdivided in everyday use — included now so
  /// whichever NumberFormat call eventually reads this setting doesn't
  /// show "¥1,200.00" instead of "¥1,200".
  final int decimalDigits;
}