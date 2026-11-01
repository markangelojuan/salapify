import 'package:flutter/material.dart';

class AppLanguage {
  const AppLanguage(this.locale, this.nativeName);
  final Locale locale;
  final String nativeName;
}

/// Add new languages here (plus their ARB file)
const supportedLanguages = [
  AppLanguage(Locale('en'), 'English'),
  AppLanguage(Locale('es'), 'Español'),
  AppLanguage(Locale('th'), 'ไทย'),
  AppLanguage(Locale('zh'), '繁體中文'),
  AppLanguage(Locale('tr'), 'Türkçe'),
];

/// Returns the native name for [locale], or null for system default.
String? nativeNameFor(Locale? locale) {
  if (locale == null) return null;
  for (final l in supportedLanguages) {
    if (l.locale == locale) return l.nativeName;
  }
  return locale.languageCode;
}
