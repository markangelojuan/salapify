import 'package:flutter/material.dart';

class AppLanguage {
  const AppLanguage(this.locale, this.nativeName);
  final Locale locale;
  final String nativeName;
}

/// Add new languages here (plus their ARB file) as you support them.
const supportedLanguages = [
  AppLanguage(Locale('en'), 'English'),
  AppLanguage(Locale('es'), 'Español'),
];

/// Returns the native name for [locale], or null for system default.
String? nativeNameFor(Locale? locale) {
  if (locale == null) return null;
  for (final l in supportedLanguages) {
    if (l.locale == locale) return l.nativeName;
  }
  return locale.languageCode;
}