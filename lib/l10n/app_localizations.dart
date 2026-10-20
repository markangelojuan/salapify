import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Title of the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Section label for the language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Option to follow the device language
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystemDefault;

  /// Title of the language picker sheet
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get languageChoose;

  /// No description provided for @settingsBudgetingPeriod.
  ///
  /// In en, this message translates to:
  /// **'Budgeting Period'**
  String get settingsBudgetingPeriod;

  /// No description provided for @budgetingPeriodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get budgetingPeriodMonthly;

  /// No description provided for @budgetingPeriodMonthlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Track budgets once per month'**
  String get budgetingPeriodMonthlyDesc;

  /// No description provided for @budgetingPeriodBiMonthly.
  ///
  /// In en, this message translates to:
  /// **'Bi-Monthly'**
  String get budgetingPeriodBiMonthly;

  /// No description provided for @budgetingPeriodBiMonthlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Split the month into two halves'**
  String get budgetingPeriodBiMonthlyDesc;

  /// No description provided for @settingsFirstHalfEndsOn.
  ///
  /// In en, this message translates to:
  /// **'First half ends on'**
  String get settingsFirstHalfEndsOn;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsReminders;

  /// No description provided for @settingsAppReminders.
  ///
  /// In en, this message translates to:
  /// **'App reminders'**
  String get settingsAppReminders;

  /// No description provided for @settingsAppRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Nudge occasionally to update your budget'**
  String get settingsAppRemindersDesc;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsBlockedUsers.
  ///
  /// In en, this message translates to:
  /// **'Blocked users'**
  String get settingsBlockedUsers;

  /// No description provided for @changePeriodTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Budgeting Period'**
  String get changePeriodTitle;

  /// No description provided for @changePeriodMessage.
  ///
  /// In en, this message translates to:
  /// **'Existing categories will be converted to match the new period (amounts stay the same). Categories set for a specific half will now count toward the full month, or vice versa — you may want to review and consolidate any duplicates afterward. Continue?'**
  String get changePeriodMessage;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @settingsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings: {error}'**
  String settingsLoadFailed(String error);

  /// No description provided for @currencyTapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change'**
  String get currencyTapToChange;

  /// No description provided for @currencyChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose Currency'**
  String get currencyChoose;

  /// No description provided for @reminderMonthStartTitle.
  ///
  /// In en, this message translates to:
  /// **'New month, fresh budget 📊'**
  String get reminderMonthStartTitle;

  /// No description provided for @reminderMonthStartBody.
  ///
  /// In en, this message translates to:
  /// **'Update your budget and log any pending transactions.'**
  String get reminderMonthStartBody;

  /// No description provided for @reminderMidMonthTitle.
  ///
  /// In en, this message translates to:
  /// **'Midmonth check-in 💸'**
  String get reminderMidMonthTitle;

  /// No description provided for @reminderMidMonthBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to log your recent expenses.'**
  String get reminderMidMonthBody;

  /// No description provided for @settingsSyncFailedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Budgeting period saved on this device, but couldn\'t sync to your account.'**
  String get settingsSyncFailedPeriod;

  /// No description provided for @settingsSyncFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Setting saved on this device, but couldn\'t sync to your account.'**
  String get settingsSyncFailedGeneric;

  /// No description provided for @settingsSyncFailedCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency saved on this device, but couldn\'t sync to your account.'**
  String get settingsSyncFailedCurrency;

  /// No description provided for @settingsNotificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for Salapify. Enable them in your phone settings to get reminders.'**
  String get settingsNotificationsDisabled;

  /// No description provided for @settingsConvertingCategories.
  ///
  /// In en, this message translates to:
  /// **'Converting your categories…'**
  String get settingsConvertingCategories;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'Hmm… we couldn\'t find that account.'**
  String get errorUserNotFound;

  /// No description provided for @errorInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Those login details don\'t look right.'**
  String get errorInvalidCredential;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already part of the club.'**
  String get errorEmailInUse;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Give it a minute before trying again.'**
  String get errorTooManyRequests;

  /// No description provided for @errorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account is currently taking a vacation.'**
  String get errorUserDisabled;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'That password is too easy to guess. Try a longer one.'**
  String get errorWeakPassword;

  /// No description provided for @errorRequiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'For your security, please sign out and back in, then try again.'**
  String get errorRequiresRecentLogin;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Check your connection and try again.'**
  String get errorOffline;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'A tiny hiccup! Try again?'**
  String get errorGeneric;

  /// No description provided for @errorUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'Username is already taken'**
  String get errorUsernameTaken;

  /// No description provided for @errorEmailRegistered.
  ///
  /// In en, this message translates to:
  /// **'Email is already registered'**
  String get errorEmailRegistered;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'That password doesn\'t look right'**
  String get errorWrongPassword;

  /// No description provided for @errorReauthCancelled.
  ///
  /// In en, this message translates to:
  /// **'Confirmation was cancelled'**
  String get errorReauthCancelled;

  /// No description provided for @errorAccountDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
  String get errorAccountDisabled;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
