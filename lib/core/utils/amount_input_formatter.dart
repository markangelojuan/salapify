import 'package:flutter/services.dart';

/// Limits input to digits plus an optional decimal part.
/// With [maxDecimalDigits] == 0, only whole numbers are accepted.
class AmountInputFormatter extends TextInputFormatter {
  AmountInputFormatter({
    required this.maxIntegerDigits,
    required this.maxDecimalDigits,
  }) : _pattern = RegExp(
         maxDecimalDigits == 0
             ? '^\\d{0,$maxIntegerDigits}\$'
             : '^\\d{0,$maxIntegerDigits}(\\.\\d{0,$maxDecimalDigits})?\$',
       );

  final int maxIntegerDigits;
  final int maxDecimalDigits;
  final RegExp _pattern;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return _pattern.hasMatch(newValue.text) ? newValue : oldValue;
  }
}