import 'package:salapify/core/localization/localized_exception.dart';
import 'package:salapify/l10n/app_localizations.dart';


class UsernameTakenException implements LocalizedException {
  const UsernameTakenException();

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorUsernameTaken;

  @override
  String toString() => 'Username is already taken';
}

class EmailAlreadyInUseException implements LocalizedException {
  const EmailAlreadyInUseException();

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorEmailRegistered;

  @override
  String toString() => 'Email is already registered';
}

class WrongPasswordException implements LocalizedException {
  const WrongPasswordException();

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorWrongPassword;

  @override
  String toString() => "That password doesn't look right";
}

class ReauthCancelledException implements LocalizedException {
  const ReauthCancelledException();
  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorReauthCancelled;

  @override
  String toString() => 'Confirmation was cancelled';
}

class AccountDisabledException implements LocalizedException {
  const AccountDisabledException();

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorAccountDisabled;

  @override
  String toString() => 'This account has been disabled';
}