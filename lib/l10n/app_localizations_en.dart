// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystemDefault => 'System default';

  @override
  String get languageChoose => 'Choose Language';

  @override
  String get settingsBudgetingPeriod => 'Budgeting Period';

  @override
  String get budgetingPeriodMonthly => 'Monthly';

  @override
  String get budgetingPeriodMonthlyDesc => 'Track budgets once per month';

  @override
  String get budgetingPeriodBiMonthly => 'Bi-Monthly';

  @override
  String get budgetingPeriodBiMonthlyDesc => 'Split the month into two halves';

  @override
  String get settingsFirstHalfEndsOn => 'First half ends on';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsReminders => 'Reminders';

  @override
  String get settingsAppReminders => 'App reminders';

  @override
  String get settingsAppRemindersDesc =>
      'Nudge occasionally to update your budget';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsBlockedUsers => 'Blocked users';

  @override
  String get changePeriodTitle => 'Change Budgeting Period';

  @override
  String get changePeriodMessage =>
      'Existing categories will be converted to match the new period (amounts stay the same). Categories set for a specific half will now count toward the full month, or vice versa — you may want to review and consolidate any duplicates afterward. Continue?';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonContinue => 'Continue';

  @override
  String settingsLoadFailed(String error) {
    return 'Failed to load settings: $error';
  }

  @override
  String get currencyTapToChange => 'Tap to change';

  @override
  String get currencyChoose => 'Choose Currency';

  @override
  String get reminderMonthStartTitle => 'New month, fresh budget 📊';

  @override
  String get reminderMonthStartBody =>
      'Update your budget and log any pending transactions.';

  @override
  String get reminderMidMonthTitle => 'Midmonth check-in 💸';

  @override
  String get reminderMidMonthBody =>
      'Don\'t forget to log your recent expenses.';

  @override
  String get settingsSyncFailedPeriod =>
      'Budgeting period saved on this device, but couldn\'t sync to your account.';

  @override
  String get settingsSyncFailedGeneric =>
      'Setting saved on this device, but couldn\'t sync to your account.';

  @override
  String get settingsSyncFailedCurrency =>
      'Currency saved on this device, but couldn\'t sync to your account.';

  @override
  String get settingsNotificationsDisabled =>
      'Notifications are turned off for Salapify. Enable them in your phone settings to get reminders.';

  @override
  String get settingsConvertingCategories => 'Converting your categories…';

  @override
  String get errorUserNotFound => 'Hmm… we couldn\'t find that account.';

  @override
  String get errorInvalidCredential => 'Those login details don\'t look right.';

  @override
  String get errorEmailInUse => 'This email is already part of the club.';

  @override
  String get errorNetwork => 'Please check your connection and try again.';

  @override
  String get errorTooManyRequests =>
      'Too many attempts. Give it a minute before trying again.';

  @override
  String get errorUserDisabled =>
      'This account is currently taking a vacation.';

  @override
  String get errorWeakPassword =>
      'That password is too easy to guess. Try a longer one.';

  @override
  String get errorRequiresRecentLogin =>
      'For your security, please sign out and back in, then try again.';

  @override
  String get errorOffline =>
      'You\'re offline. Check your connection and try again.';

  @override
  String get errorGeneric => 'A tiny hiccup! Try again?';

  @override
  String get errorUsernameTaken => 'Username is already taken';

  @override
  String get errorEmailRegistered => 'Email is already registered';

  @override
  String get errorWrongPassword => 'That password doesn\'t look right';

  @override
  String get errorReauthCancelled => 'Confirmation was cancelled';

  @override
  String get errorAccountDisabled => 'This account has been disabled';
}
