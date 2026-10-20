import 'package:salapify/l10n/app_localizations.dart';

/// Exceptions that know how to describe themselves in the user's language.
/// `toString()` stays English for logs; the snackbar uses this for the UI.
abstract interface class LocalizedException implements Exception {
  String localizedMessage(AppLocalizations l10n);
}