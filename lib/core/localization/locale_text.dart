import 'package:flutter/widgets.dart';

extension LocaleUpperCase on String {
  /// Locale-aware uppercase. Turkish (and Azerbaijani) map i -> İ and ı -> I;
  /// every other language behaves exactly like [toUpperCase].
  String toUpperCaseL(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'tr' || lang == 'az') {
      return replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();
    }
    return toUpperCase();
  }
}