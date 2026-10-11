import 'package:intl/intl.dart';

enum AppCurrency {
  php('₱', 'Philippine Peso', 2),
  usd('\$', 'US Dollar', 2),
  // Remaining entries sorted by currency code (the picker shows the code).
  aud('A\$', 'Australian Dollar', 2),
  bdt('৳', 'Bangladeshi Taka', 2),
  cad('C\$', 'Canadian Dollar', 2),
  egp('E£', 'Egyptian Pound', 2),
  eur('€', 'Euro', 2),
  gbp('£', 'British Pound', 2),
  ghs('GH₵', 'Ghanaian Cedi', 2),
  hkd('HK\$', 'Hong Kong Dollar', 2),
  idr('Rp', 'Indonesian Rupiah', 0),
  ils('₪', 'Israeli New Shekel', 2),
  inr('₹', 'Indian Rupee', 2),
  kes('KSh', 'Kenyan Shilling', 2),
  lkr('Rs', 'Sri Lankan Rupee', 2),
  myr('RM', 'Malaysian Ringgit', 2),
  ngn('₦', 'Nigerian Naira', 2),
  npr('NRs', 'Nepalese Rupee', 2),
  nzd('NZ\$', 'New Zealand Dollar', 2),
  pkr('₨', 'Pakistani Rupee', 2),
  pln('zł', 'Polish Zloty', 2),
  sgd('S\$', 'Singapore Dollar', 2),
  thb('฿', 'Thai Baht', 2),
  try_('₺', 'Turkish Lira', 2),
  twd('NT\$', 'New Taiwan Dollar', 2),
  uah('₴', 'Ukrainian Hryvnia', 2),
  vnd('₫', 'Vietnamese Dong', 0),
  zar('R', 'South African Rand', 2);

  const AppCurrency(this.symbol, this.label, this.decimalDigits);

  final String symbol;
  final String label;
  final int decimalDigits;

    /// ISO-style code for display ("TRY", not "TRY_").
  String get code => name.replaceAll('_', '').toUpperCase();

  /// Input hint matching this currency's decimals: "0.00" or "0".
  String get amountHint =>
      decimalDigits == 0 ? '0' : '0.${'0' * decimalDigits}';

  /// Formats an amount for a text field, e.g. 150.5 -> "150.50" or "151".
  String formatForInput(double amount) => amount.toStringAsFixed(decimalDigits);

    /// Formats an amount for display, e.g. 1500.5 -> "1500.50" or "1501".
  String formatAmount(double amount) =>
    NumberFormat.decimalPatternDigits(decimalDigits: decimalDigits).format(amount);
}


