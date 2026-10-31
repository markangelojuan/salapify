import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

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
    Locale('th'),
    Locale('tr'),
    Locale('zh'),
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

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to access your account'**
  String get authSignInSubtitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEmailHint;

  /// No description provided for @authEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordHint;

  /// No description provided for @authPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get authPasswordRequired;

  /// No description provided for @authPasswordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get authPasswordInvalid;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get authOrContinueWith;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authNotMemberYet.
  ///
  /// In en, this message translates to:
  /// **'Not part of the club yet?'**
  String get authNotMemberYet;

  /// No description provided for @authContinueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get authContinueAsGuest;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get authResetPasswordTitle;

  /// No description provided for @authResetPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get authResetPasswordPrompt;

  /// No description provided for @authResetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for that email, a reset link is on its way. Check your inbox (and spam folder).'**
  String get authResetLinkSent;

  /// No description provided for @authSendLink.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get authSendLink;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @authSignUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account to get started'**
  String get authSignUpSubtitle;

  /// No description provided for @authUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsernameLabel;

  /// No description provided for @authUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your preferred username'**
  String get authUsernameHint;

  /// No description provided for @authUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get authUsernameRequired;

  /// No description provided for @authUsernameNoSpaces.
  ///
  /// In en, this message translates to:
  /// **'No leading or trailing spaces'**
  String get authUsernameNoSpaces;

  /// No description provided for @authUsernameStartLetter.
  ///
  /// In en, this message translates to:
  /// **'Must start with a letter'**
  String get authUsernameStartLetter;

  /// No description provided for @authUsernameAllowedChars.
  ///
  /// In en, this message translates to:
  /// **'Only letters, numbers, and underscores allowed'**
  String get authUsernameAllowedChars;

  /// No description provided for @authUsernameMinLetters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 3 letters'**
  String get authUsernameMinLetters;

  /// No description provided for @authUsernameMaxNumbers.
  ///
  /// In en, this message translates to:
  /// **'Maximum 3 numbers'**
  String get authUsernameMaxNumbers;

  /// No description provided for @authPasswordPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Password / PIN'**
  String get authPasswordPinLabel;

  /// No description provided for @authPasswordPinHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password / PIN'**
  String get authPasswordPinHint;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get authPasswordMinLength;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password / PIN'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password / PIN'**
  String get authConfirmPasswordHint;

  /// No description provided for @authConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authConfirmPasswordRequired;

  /// No description provided for @authPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsMismatch;

  /// No description provided for @authAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service and Privacy Policy'**
  String get authAgreeTerms;

  /// No description provided for @termsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get termsDialogTitle;

  /// No description provided for @termsServiceHeading.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsServiceHeading;

  /// No description provided for @termsServiceBody.
  ///
  /// In en, this message translates to:
  /// **'By using Salapify, you agree to use the app responsibly and provide accurate information. You are responsible for your account and the information you enter.'**
  String get termsServiceBody;

  /// No description provided for @termsPrivacyHeading.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get termsPrivacyHeading;

  /// No description provided for @termsPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Salapify collects information needed to provide your account, budgeting, expense tracking, groups, and bill-splitting features. We do not connect to your bank accounts or financial accounts, and we do not sell your personal information.'**
  String get termsPrivacyBody;

  /// No description provided for @termsSharedHeading.
  ///
  /// In en, this message translates to:
  /// **'Shared Information'**
  String get termsSharedHeading;

  /// No description provided for @termsSharedBody.
  ///
  /// In en, this message translates to:
  /// **'When you join groups or split bills, relevant information such as your username, bills, and shares may be visible to other members of those groups.'**
  String get termsSharedBody;

  /// No description provided for @termsImportantHeading.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get termsImportantHeading;

  /// No description provided for @termsImportantBody.
  ///
  /// In en, this message translates to:
  /// **'Salapify is a budgeting and organization tool, not a bank, payment service, or financial adviser.'**
  String get termsImportantBody;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailSentGeneric.
  ///
  /// In en, this message translates to:
  /// **'We’ve sent you a verification link.'**
  String get verifyEmailSentGeneric;

  /// No description provided for @verifyEmailSentTo.
  ///
  /// In en, this message translates to:
  /// **'We’ve sent a verification link to {email}.'**
  String verifyEmailSentTo(String email);

  /// No description provided for @verifyEmailInstructions.
  ///
  /// In en, this message translates to:
  /// **'Click the link in that email, then tap the button below.'**
  String get verifyEmailInstructions;

  /// No description provided for @verifyEmailIVerified.
  ///
  /// In en, this message translates to:
  /// **'I’ve verified'**
  String get verifyEmailIVerified;

  /// No description provided for @verifyEmailResend.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get verifyEmailResend;

  /// No description provided for @verifyEmailResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String verifyEmailResendIn(int seconds);

  /// No description provided for @verifyEmailResent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent.'**
  String get verifyEmailResent;

  /// No description provided for @verifyEmailNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not verified yet — check your inbox (and spam).'**
  String get verifyEmailNotYet;

  /// No description provided for @commonSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get commonSignOut;

  /// No description provided for @avatarPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Which little money beast are you?'**
  String get avatarPickerTitle;

  /// No description provided for @avatarPickerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime'**
  String get avatarPickerSubtitle;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @avatarLuxuriousDog.
  ///
  /// In en, this message translates to:
  /// **'Luxurious Dog'**
  String get avatarLuxuriousDog;

  /// No description provided for @avatarSavvyMonkey.
  ///
  /// In en, this message translates to:
  /// **'Savvy Monkey'**
  String get avatarSavvyMonkey;

  /// No description provided for @avatarGreedyCat.
  ///
  /// In en, this message translates to:
  /// **'Greedy Cat'**
  String get avatarGreedyCat;

  /// No description provided for @avatarThriftyPig.
  ///
  /// In en, this message translates to:
  /// **'Thrifty Pig'**
  String get avatarThriftyPig;

  /// No description provided for @avatarStingyTurtle.
  ///
  /// In en, this message translates to:
  /// **'Stingy Turtle'**
  String get avatarStingyTurtle;

  /// No description provided for @avatarCovetousSnake.
  ///
  /// In en, this message translates to:
  /// **'Covetous Snake'**
  String get avatarCovetousSnake;

  /// No description provided for @avatarProsperousPanda.
  ///
  /// In en, this message translates to:
  /// **'Prosperous Panda'**
  String get avatarProsperousPanda;

  /// No description provided for @avatarFrugalShark.
  ///
  /// In en, this message translates to:
  /// **'Frugal Shark'**
  String get avatarFrugalShark;

  /// No description provided for @avatarOpulentWalrus.
  ///
  /// In en, this message translates to:
  /// **'Opulent Walrus'**
  String get avatarOpulentWalrus;

  /// No description provided for @avatarBrokeEagle.
  ///
  /// In en, this message translates to:
  /// **'Broke Eagle'**
  String get avatarBrokeEagle;

  /// No description provided for @accountAvatarNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get accountAvatarNotSelected;

  /// No description provided for @prefsBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you budget?'**
  String get prefsBudgetTitle;

  /// No description provided for @prefsBudgetDescription.
  ///
  /// In en, this message translates to:
  /// **'Your budget period decides when your category budgets reset.'**
  String get prefsBudgetDescription;

  /// No description provided for @prefsMonthlyDesc.
  ///
  /// In en, this message translates to:
  /// **'One budget for the whole month'**
  String get prefsMonthlyDesc;

  /// No description provided for @prefsTwiceMonthly.
  ///
  /// In en, this message translates to:
  /// **'Twice a month'**
  String get prefsTwiceMonthly;

  /// No description provided for @prefsTwiceMonthlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Split into two halves, great if you get paid twice'**
  String get prefsTwiceMonthlyDesc;

  /// No description provided for @prefsFirstHalfRange.
  ///
  /// In en, this message translates to:
  /// **'The first half runs from day 1 to day {day}.'**
  String prefsFirstHalfRange(int day);

  /// No description provided for @prefsCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your currency'**
  String get prefsCurrencyTitle;

  /// No description provided for @prefsCurrencyDescription.
  ///
  /// In en, this message translates to:
  /// **'This is the symbol shown across your budgets and transactions.'**
  String get prefsCurrencyDescription;

  /// No description provided for @prefsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get prefsGetStarted;

  /// No description provided for @prefsUseDefaults.
  ///
  /// In en, this message translates to:
  /// **'Use defaults'**
  String get prefsUseDefaults;

  /// No description provided for @prefsChangeLater.
  ///
  /// In en, this message translates to:
  /// **'You can change these anytime in Settings'**
  String get prefsChangeLater;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get commonChange;

  /// No description provided for @accountUserFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get accountUserFallback;

  /// No description provided for @accountProfileInfo.
  ///
  /// In en, this message translates to:
  /// **'Profile info'**
  String get accountProfileInfo;

  /// No description provided for @accountEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountEmail;

  /// No description provided for @accountSignInMethod.
  ///
  /// In en, this message translates to:
  /// **'Sign-in method'**
  String get accountSignInMethod;

  /// No description provided for @accountAvatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get accountAvatar;

  /// No description provided for @accountMembership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get accountMembership;

  /// No description provided for @accountDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get accountDangerZone;

  /// No description provided for @accountDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get accountDeleteAccount;

  /// No description provided for @accountDeleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove your account and all data'**
  String get accountDeleteAccountDesc;

  /// No description provided for @accountPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get accountPremium;

  /// No description provided for @accountSeeWhatsInside.
  ///
  /// In en, this message translates to:
  /// **'See what’s inside'**
  String get accountSeeWhatsInside;

  /// No description provided for @accountPremiumDesc.
  ///
  /// In en, this message translates to:
  /// **'Higher limits unlocked on this account'**
  String get accountPremiumDesc;

  /// No description provided for @accountFreeDesc.
  ///
  /// In en, this message translates to:
  /// **'Lift category, group and bill limits'**
  String get accountFreeDesc;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// No description provided for @accountDeleteConfirmPhrase.
  ///
  /// In en, this message translates to:
  /// **'Save small sums, see savings soar'**
  String get accountDeleteConfirmPhrase;

  /// No description provided for @accountDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone. All your data, transactions, and settings will be permanently deleted.'**
  String get accountDeleteWarning;

  /// No description provided for @accountDeleteTypePhrase.
  ///
  /// In en, this message translates to:
  /// **'Type “{phrase}” to confirm'**
  String accountDeleteTypePhrase(String phrase);

  /// No description provided for @accountDeleteReauthGoogle.
  ///
  /// In en, this message translates to:
  /// **'For your security, please confirm your identity with Google before we delete your account.'**
  String get accountDeleteReauthGoogle;

  /// No description provided for @accountDeleteReauthPassword.
  ///
  /// In en, this message translates to:
  /// **'For your security, please enter your password to confirm.'**
  String get accountDeleteReauthPassword;

  /// No description provided for @accountVerifyWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Verify with Google'**
  String get accountVerifyWithGoogle;

  /// No description provided for @accountDeletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get accountDeletePermanently;

  /// No description provided for @accountIncorrectPasswordRetry.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get accountIncorrectPasswordRetry;

  /// No description provided for @accountChangeUsername.
  ///
  /// In en, this message translates to:
  /// **'Change username'**
  String get accountChangeUsername;

  /// No description provided for @accountUsernameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Username updated'**
  String get accountUsernameUpdated;

  /// No description provided for @accountChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get accountChangePassword;

  /// No description provided for @accountCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password / PIN'**
  String get accountCurrentPassword;

  /// No description provided for @accountNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password / PIN'**
  String get accountNewPassword;

  /// No description provided for @accountConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password / PIN'**
  String get accountConfirmNewPassword;

  /// No description provided for @accountIncorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get accountIncorrectPassword;

  /// No description provided for @accountPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get accountPasswordUpdated;

  /// No description provided for @accountUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get accountUpdatePassword;

  /// No description provided for @premiumHeaderBadge.
  ///
  /// In en, this message translates to:
  /// **'Be premium'**
  String get premiumHeaderBadge;

  /// No description provided for @premiumHeaderActiveBadge.
  ///
  /// In en, this message translates to:
  /// **'You are premium'**
  String get premiumHeaderActiveBadge;

  /// No description provided for @premiumHeadline.
  ///
  /// In en, this message translates to:
  /// **'Remove every free-plan limit'**
  String get premiumHeadline;

  /// No description provided for @premiumHeadlineActive.
  ///
  /// In en, this message translates to:
  /// **'Every limit is removed on this account.'**
  String get premiumHeadlineActive;

  /// No description provided for @premiumSub.
  ///
  /// In en, this message translates to:
  /// **'One-time payment. No subscription, ever.'**
  String get premiumSub;

  /// No description provided for @premiumSubActive.
  ///
  /// In en, this message translates to:
  /// **'Thanks for helping us maintain Salapify.'**
  String get premiumSubActive;

  /// No description provided for @premiumWhatYouGet.
  ///
  /// In en, this message translates to:
  /// **'What you get'**
  String get premiumWhatYouGet;

  /// No description provided for @premiumFeatureCategories.
  ///
  /// In en, this message translates to:
  /// **'{count} active budget categories'**
  String premiumFeatureCategories(int count);

  /// No description provided for @premiumFeatureCategoriesFree.
  ///
  /// In en, this message translates to:
  /// **'Free plan: up to {count} active'**
  String premiumFeatureCategoriesFree(int count);

  /// No description provided for @premiumFeatureGroups.
  ///
  /// In en, this message translates to:
  /// **'{count} active groups'**
  String premiumFeatureGroups(int count);

  /// No description provided for @premiumFeatureGroupsFree.
  ///
  /// In en, this message translates to:
  /// **'Free plan: up to {count} active'**
  String premiumFeatureGroupsFree(int count);

  /// No description provided for @premiumFeatureBills.
  ///
  /// In en, this message translates to:
  /// **'{count} active bills per group'**
  String premiumFeatureBills(int count);

  /// No description provided for @premiumFeatureBillsFree.
  ///
  /// In en, this message translates to:
  /// **'Free plan: up to {count} per group'**
  String premiumFeatureBillsFree(int count);

  /// No description provided for @premiumFeatureAvatars.
  ///
  /// In en, this message translates to:
  /// **'More beasts unlocked'**
  String get premiumFeatureAvatars;

  /// No description provided for @premiumFeatureAvatarsDesc.
  ///
  /// In en, this message translates to:
  /// **'Extra avatars to personalize your profile'**
  String get premiumFeatureAvatarsDesc;

  /// No description provided for @premiumPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get premiumPricing;

  /// No description provided for @premiumBestValue.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE — PAY ONCE'**
  String get premiumBestValue;

  /// No description provided for @premiumOneTimeFee.
  ///
  /// In en, this message translates to:
  /// **'one-time fee'**
  String get premiumOneTimeFee;

  /// No description provided for @premiumRestorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get premiumRestorePurchase;

  /// No description provided for @premiumSecurePayment.
  ///
  /// In en, this message translates to:
  /// **'Secure one-time payment via App Store'**
  String get premiumSecurePayment;

  /// No description provided for @premiumActiveOnAccount.
  ///
  /// In en, this message translates to:
  /// **'Premium is active on this account'**
  String get premiumActiveOnAccount;

  /// No description provided for @premiumGo.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get premiumGo;

  /// No description provided for @premiumBuyWithPrice.
  ///
  /// In en, this message translates to:
  /// **'Buy — {price}'**
  String premiumBuyWithPrice(String price);

  /// No description provided for @premiumRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchase restored — enjoy!'**
  String get premiumRestored;

  /// No description provided for @premiumUnlocked.
  ///
  /// In en, this message translates to:
  /// **'You’re premium now — enjoy!'**
  String get premiumUnlocked;

  /// No description provided for @premiumErrorOtherAccount.
  ///
  /// In en, this message translates to:
  /// **'This purchase is linked to a different account. Sign in with that account to restore it.'**
  String get premiumErrorOtherAccount;

  /// No description provided for @premiumNothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'No previous purchase found to restore.'**
  String get premiumNothingToRestore;

  /// No description provided for @premiumSignInFirst.
  ///
  /// In en, this message translates to:
  /// **'Please sign in first to unlock premium.'**
  String get premiumSignInFirst;

  /// No description provided for @premiumBillingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Billing is unavailable right now. Please try again later.'**
  String get premiumBillingUnavailable;

  /// No description provided for @premiumPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase didn’t go through. Please try again.'**
  String get premiumPurchaseFailed;

  /// No description provided for @premiumLimitCategories.
  ///
  /// In en, this message translates to:
  /// **'Your budget is growing! You’ve filled every free category.'**
  String get premiumLimitCategories;

  /// No description provided for @premiumLimitGroups.
  ///
  /// In en, this message translates to:
  /// **'Your free group is all booked. Only one active at a time.'**
  String get premiumLimitGroups;

  /// No description provided for @premiumLimitBills.
  ///
  /// In en, this message translates to:
  /// **'Your bills are multiplying! The free slots are all used up.'**
  String get premiumLimitBills;

  /// No description provided for @premiumUpsellBenefit.
  ///
  /// In en, this message translates to:
  /// **'One-time Premium unlock'**
  String get premiumUpsellBenefit;

  /// No description provided for @premiumUpsellSupport.
  ///
  /// In en, this message translates to:
  /// **'Support the app with a one-time purchase.'**
  String get premiumUpsellSupport;

  /// No description provided for @blockedUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocked Users'**
  String get blockedUsersTitle;

  /// No description provided for @blockedUsersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No blocked users'**
  String get blockedUsersEmpty;

  /// No description provided for @unblockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unblock {username}?'**
  String unblockTitle(String username);

  /// No description provided for @unblockMessage.
  ///
  /// In en, this message translates to:
  /// **'They will be able to interact with you again.'**
  String get unblockMessage;

  /// No description provided for @unblockAction.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblockAction;

  /// No description provided for @unblockedSnack.
  ///
  /// In en, this message translates to:
  /// **'Unblocked {username}'**
  String unblockedSnack(String username);

  /// No description provided for @commonLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {error}'**
  String commonLoadFailed(String error);

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete “{itemName}”? This cannot be undone.'**
  String confirmDeleteMessage(String itemName);

  /// No description provided for @navBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get navBudget;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navSplitBill.
  ///
  /// In en, this message translates to:
  /// **'Split Bill'**
  String get navSplitBill;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @tourMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'More Options'**
  String get tourMenuTitle;

  /// No description provided for @tourMenuDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your account, budget period,\nother settings, and get help.'**
  String get tourMenuDesc;

  /// No description provided for @tourFabTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get tourFabTitle;

  /// No description provided for @tourFabDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap + to quickly add a category,\ntransaction, or split-bill group.'**
  String get tourFabDesc;

  /// No description provided for @tourBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Budget'**
  String get tourBudgetTitle;

  /// No description provided for @tourBudgetDesc.
  ///
  /// In en, this message translates to:
  /// **'Set spending limits per category\nand see how much you have left.'**
  String get tourBudgetDesc;

  /// No description provided for @tourTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Your Expenses'**
  String get tourTransactionsTitle;

  /// No description provided for @tourTransactionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your income and expenses.\nUse + to add a transaction.'**
  String get tourTransactionsDesc;

  /// No description provided for @tourSplitTitle.
  ///
  /// In en, this message translates to:
  /// **'Split Bills Easily'**
  String get tourSplitTitle;

  /// No description provided for @tourSplitDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a group, add bills,\nand chat with everyone.'**
  String get tourSplitDesc;

  /// No description provided for @tourSplitDescGuest.
  ///
  /// In en, this message translates to:
  /// **'Split expenses with friends.\nSign in to unlock this feature.'**
  String get tourSplitDescGuest;

  /// No description provided for @limitReachedCategories.
  ///
  /// In en, this message translates to:
  /// **'You’ve reached the limit of {count} active categories. Delete one to add a new one.'**
  String limitReachedCategories(int count);

  /// No description provided for @limitReachedGroups.
  ///
  /// In en, this message translates to:
  /// **'You’ve reached the limit of {count} groups. Delete a group to create a new one.'**
  String limitReachedGroups(int count);

  /// No description provided for @drawerGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get drawerGuest;

  /// No description provided for @drawerGuestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save your data'**
  String get drawerGuestSubtitle;

  /// No description provided for @drawerAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get drawerAccount;

  /// No description provided for @drawerDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get drawerDarkMode;

  /// No description provided for @drawerHelp.
  ///
  /// In en, this message translates to:
  /// **'Help / FAQ'**
  String get drawerHelp;

  /// No description provided for @drawerLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get drawerLogout;

  /// No description provided for @budgetAllocations.
  ///
  /// In en, this message translates to:
  /// **'ALLOCATIONS'**
  String get budgetAllocations;

  /// No description provided for @budgetNoCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get budgetNoCategories;

  /// No description provided for @budgetFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get budgetFilter;

  /// No description provided for @budgetFiltersCount.
  ///
  /// In en, this message translates to:
  /// **'Filters ({count})'**
  String budgetFiltersCount(int count);

  /// No description provided for @budgetClearFiltersToReorder.
  ///
  /// In en, this message translates to:
  /// **'Clear filters to reorder categories'**
  String get budgetClearFiltersToReorder;

  /// No description provided for @budgetNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No categories match your filters'**
  String get budgetNoMatch;

  /// No description provided for @budgetClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get budgetClearFilters;

  /// No description provided for @budgetLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories: {error}'**
  String budgetLoadFailed(String error);

  /// No description provided for @budgetAutoCompleted.
  ///
  /// In en, this message translates to:
  /// **'{name} auto-completed — spending reached the budget.'**
  String budgetAutoCompleted(String name);

  /// No description provided for @budgetFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Categories'**
  String get budgetFilterTitle;

  /// No description provided for @commonClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get commonClearAll;

  /// No description provided for @budgetFilterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get budgetFilterStatus;

  /// No description provided for @budgetFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get budgetFilterAll;

  /// No description provided for @budgetFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get budgetFilterPending;

  /// No description provided for @budgetFilterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get budgetFilterCompleted;

  /// No description provided for @budgetFilterType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get budgetFilterType;

  /// No description provided for @budgetTypeFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get budgetTypeFixed;

  /// No description provided for @budgetTypeVariable.
  ///
  /// In en, this message translates to:
  /// **'Variable'**
  String get budgetTypeVariable;

  /// No description provided for @budgetFilterRecurrence.
  ///
  /// In en, this message translates to:
  /// **'Recurrence'**
  String get budgetFilterRecurrence;

  /// No description provided for @commonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// No description provided for @commonApplyCount.
  ///
  /// In en, this message translates to:
  /// **'Apply ({count})'**
  String commonApplyCount(int count);

  /// No description provided for @budgetFreqOnce.
  ///
  /// In en, this message translates to:
  /// **'One-time'**
  String get budgetFreqOnce;

  /// No description provided for @budgetFreqRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get budgetFreqRecurring;

  /// No description provided for @budgetFreqFirstHalf.
  ///
  /// In en, this message translates to:
  /// **'First Half'**
  String get budgetFreqFirstHalf;

  /// No description provided for @budgetFreqSecondHalf.
  ///
  /// In en, this message translates to:
  /// **'Second Half'**
  String get budgetFreqSecondHalf;

  /// No description provided for @budgetPeriodMonthly.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String budgetPeriodMonthly(DateTime date);

  /// No description provided for @budgetPeriodFirstHalf.
  ///
  /// In en, this message translates to:
  /// **'1st Half · {month} {start}–{end}'**
  String budgetPeriodFirstHalf(DateTime month, int start, int end);

  /// No description provided for @budgetPeriodSecondHalf.
  ///
  /// In en, this message translates to:
  /// **'2nd Half · {month} {start}–{end}'**
  String budgetPeriodSecondHalf(DateTime month, int start, int end);

  /// No description provided for @budgetUsed.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get budgetUsed;

  /// No description provided for @budgetOverBudget.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get budgetOverBudget;

  /// No description provided for @budgetRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get budgetRemaining;

  /// No description provided for @budgetSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get budgetSpent;

  /// No description provided for @budgetAllocated.
  ///
  /// In en, this message translates to:
  /// **'Allocated'**
  String get budgetAllocated;

  /// No description provided for @categoryCardFirstHalf.
  ///
  /// In en, this message translates to:
  /// **'1st half'**
  String get categoryCardFirstHalf;

  /// No description provided for @categoryCardSecondHalf.
  ///
  /// In en, this message translates to:
  /// **'2nd half'**
  String get categoryCardSecondHalf;

  /// No description provided for @categoryCardBiMonthly.
  ///
  /// In en, this message translates to:
  /// **'Bi-monthly'**
  String get categoryCardBiMonthly;

  /// No description provided for @categoryMarkIncompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as incomplete?'**
  String get categoryMarkIncompleteTitle;

  /// No description provided for @categoryMarkIncompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Auto-generated expenses will be deleted. Manually added expenses will remain and may mark this category complete again.'**
  String get categoryMarkIncompleteMessage;

  /// No description provided for @categoryMarkIncompleteAction.
  ///
  /// In en, this message translates to:
  /// **'Mark Incomplete'**
  String get categoryMarkIncompleteAction;

  /// No description provided for @categoryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get categoryAdd;

  /// No description provided for @categoryEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get categoryEdit;

  /// No description provided for @categoryDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get categoryDelete;

  /// No description provided for @categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryNameLabel;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Groceries, Internet Bill'**
  String get categoryNameHint;

  /// No description provided for @categoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get categoryNameRequired;

  /// No description provided for @amountLabelWithSymbol.
  ///
  /// In en, this message translates to:
  /// **'Amount ({symbol})'**
  String amountLabelWithSymbol(String symbol);

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get amountRequired;

  /// No description provided for @amountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get amountInvalid;

  /// No description provided for @amountTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Amount is too large'**
  String get amountTooLarge;

  /// No description provided for @categoryTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get categoryTypeLabel;

  /// No description provided for @categoryFixedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Fixed: Same amount each time.'**
  String get categoryFixedTooltip;

  /// No description provided for @categoryVariableTooltip.
  ///
  /// In en, this message translates to:
  /// **'Variable: Amount may change each time.'**
  String get categoryVariableTooltip;

  /// No description provided for @categoryRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get categoryRepeat;

  /// No description provided for @categoryEveryMonth.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get categoryEveryMonth;

  /// No description provided for @categoryOnce.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get categoryOnce;

  /// No description provided for @categoryEveryPeriod.
  ///
  /// In en, this message translates to:
  /// **'Every period'**
  String get categoryEveryPeriod;

  /// No description provided for @categoryBothHalves.
  ///
  /// In en, this message translates to:
  /// **'Both halves'**
  String get categoryBothHalves;

  /// No description provided for @categoryFirstHalf.
  ///
  /// In en, this message translates to:
  /// **'First half'**
  String get categoryFirstHalf;

  /// No description provided for @categorySecondHalf.
  ///
  /// In en, this message translates to:
  /// **'Second half'**
  String get categorySecondHalf;

  /// No description provided for @categoryIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get categoryIcon;

  /// No description provided for @commonSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get commonSaveChanges;

  /// No description provided for @transactionTabExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get transactionTabExpenses;

  /// No description provided for @transactionTabIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transactionTabIncome;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @dateMonthDay.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String dateMonthDay(DateTime date);

  /// No description provided for @dateMonthDayYear.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String dateMonthDayYear(DateTime date);

  /// No description provided for @expensesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get expensesEmpty;

  /// No description provided for @expensesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load expenses: {error}'**
  String expensesLoadFailed(String error);

  /// No description provided for @expensesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this expense?'**
  String get expensesDeleteTitle;

  /// No description provided for @expensesDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'It will no longer count toward your spending totals.'**
  String get expensesDeleteMessage;

  /// No description provided for @transactionDeletedCategory.
  ///
  /// In en, this message translates to:
  /// **'Deleted category'**
  String get transactionDeletedCategory;

  /// No description provided for @transactionAutoNote.
  ///
  /// In en, this message translates to:
  /// **'Remaining budget (auto)'**
  String get transactionAutoNote;

  /// No description provided for @incomeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No income entries yet'**
  String get incomeEmpty;

  /// No description provided for @incomeLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load income: {error}'**
  String incomeLoadFailed(String error);

  /// No description provided for @incomeDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this income entry?'**
  String get incomeDeleteTitle;

  /// No description provided for @incomeDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'It will no longer be counted toward total money.'**
  String get incomeDeleteMessage;

  /// No description provided for @incomeEveryMonthOnDay.
  ///
  /// In en, this message translates to:
  /// **'Every month on day {day}'**
  String incomeEveryMonthOnDay(int day);

  /// No description provided for @incomeEveryMonthOnDayClamped.
  ///
  /// In en, this message translates to:
  /// **'Every month on day {day} (day {effective} this month)'**
  String incomeEveryMonthOnDayClamped(int day, int effective);

  /// No description provided for @cashFlowInfo.
  ///
  /// In en, this message translates to:
  /// **'Your expected income and savings this month. No history kept.'**
  String get cashFlowInfo;

  /// No description provided for @cashFlowSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get cashFlowSavings;

  /// No description provided for @expenseAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get expenseAdd;

  /// No description provided for @expenseEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get expenseEdit;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expenseCategory;

  /// No description provided for @expenseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get expenseSelectCategory;

  /// No description provided for @expenseNoCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories yet — add one from the Budget tab.'**
  String get expenseNoCategories;

  /// No description provided for @expenseDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expenseDate;

  /// No description provided for @expenseNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get expenseNoteLabel;

  /// No description provided for @expenseNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Coffee with a friend'**
  String get expenseNoteHint;

  /// No description provided for @incomeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get incomeAdd;

  /// No description provided for @incomeEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Income'**
  String get incomeEdit;

  /// No description provided for @incomeSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get incomeSourceLabel;

  /// No description provided for @incomeSourceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Salary, Freelance, Gift'**
  String get incomeSourceHint;

  /// No description provided for @incomeSourceRequired.
  ///
  /// In en, this message translates to:
  /// **'Source is required'**
  String get incomeSourceRequired;

  /// No description provided for @incomeSourceTooLong.
  ///
  /// In en, this message translates to:
  /// **'Keep it under 50 characters'**
  String get incomeSourceTooLong;

  /// No description provided for @incomeDepositDay.
  ///
  /// In en, this message translates to:
  /// **'Deposit day'**
  String get incomeDepositDay;

  /// No description provided for @incomeCountedEveryPeriod.
  ///
  /// In en, this message translates to:
  /// **'Counted as income for every period, regardless of the exact day.'**
  String get incomeCountedEveryPeriod;

  /// No description provided for @incomeAddedTo.
  ///
  /// In en, this message translates to:
  /// **'Will be added to: {date}'**
  String incomeAddedTo(DateTime date);

  /// No description provided for @splitGroupNew.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get splitGroupNew;

  /// No description provided for @splitGroupEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get splitGroupEdit;

  /// No description provided for @splitGroupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get splitGroupCreate;

  /// No description provided for @splitGroupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get splitGroupNameLabel;

  /// No description provided for @splitGroupNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Roommates, Baguio Trip'**
  String get splitGroupNameHint;

  /// No description provided for @splitGroupNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a group name'**
  String get splitGroupNameRequired;

  /// No description provided for @splitAddMembers.
  ///
  /// In en, this message translates to:
  /// **'Add members'**
  String get splitAddMembers;

  /// No description provided for @splitGroupFull.
  ///
  /// In en, this message translates to:
  /// **'Group is full ({count}/{count} members)'**
  String splitGroupFull(int count);

  /// No description provided for @splitNoUserFound.
  ///
  /// In en, this message translates to:
  /// **'No user found'**
  String get splitNoUserFound;

  /// No description provided for @splitSearchByUsername.
  ///
  /// In en, this message translates to:
  /// **'Search by username'**
  String get splitSearchByUsername;

  /// No description provided for @splitUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get splitUnknownUser;

  /// No description provided for @errorBillLimit.
  ///
  /// In en, this message translates to:
  /// **'This group has reached its limit of {limit, plural, =1{1 bill} other{{limit} bills}}'**
  String errorBillLimit(int limit);

  /// No description provided for @errorGroupLimit.
  ///
  /// In en, this message translates to:
  /// **'You can only have {limit, plural, =1{1 active group} other{{limit} active groups}} on the free plan'**
  String errorGroupLimit(int limit);

  /// No description provided for @errorMaxMembers.
  ///
  /// In en, this message translates to:
  /// **'Groups can have at most {limit, plural, =1{1 member} other{{limit} members}}'**
  String errorMaxMembers(int limit);

  /// No description provided for @splitDeleteGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this group?'**
  String get splitDeleteGroupTitle;

  /// No description provided for @splitLeaveGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this group?'**
  String get splitLeaveGroupTitle;

  /// No description provided for @splitDeleteGroupMessage.
  ///
  /// In en, this message translates to:
  /// **'This deletes “{name}” and its bills for everyone.'**
  String splitDeleteGroupMessage(String name);

  /// No description provided for @splitLeaveGroupMessage.
  ///
  /// In en, this message translates to:
  /// **'You’ll no longer see “{name}” or its bills.'**
  String splitLeaveGroupMessage(String name);

  /// No description provided for @splitLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get splitLeave;

  /// No description provided for @splitGroupsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load groups: {error}'**
  String splitGroupsLoadFailed(String error);

  /// No description provided for @splitNoGroups.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get splitNoGroups;

  /// No description provided for @splitMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String splitMembersCount(int count);

  /// No description provided for @splitSettled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get splitSettled;

  /// No description provided for @splitOwed.
  ///
  /// In en, this message translates to:
  /// **'Owed {amount}'**
  String splitOwed(String amount);

  /// No description provided for @splitYouOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe {amount}'**
  String splitYouOwe(String amount);

  /// No description provided for @guestSplitTagline.
  ///
  /// In en, this message translates to:
  /// **'Chip in. Settle up. Stay friends.'**
  String get guestSplitTagline;

  /// No description provided for @guestSplitDescription.
  ///
  /// In en, this message translates to:
  /// **'Create groups, split bills, and see who owes who. Sign in to sync it all with your friends.'**
  String get guestSplitDescription;

  /// No description provided for @guestSplitCta.
  ///
  /// In en, this message translates to:
  /// **'Sign in to get started'**
  String get guestSplitCta;

  /// No description provided for @splitBlockUser.
  ///
  /// In en, this message translates to:
  /// **'Block {username}'**
  String splitBlockUser(String username);

  /// No description provided for @splitReportUser.
  ///
  /// In en, this message translates to:
  /// **'Report {username}'**
  String splitReportUser(String username);

  /// No description provided for @splitBlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Block {username}?'**
  String splitBlockTitle(String username);

  /// No description provided for @splitBlockMessage.
  ///
  /// In en, this message translates to:
  /// **'You won’t see {username}’s messages or activity in shared groups, including bill updates. You can unblock them anytime from Settings.'**
  String splitBlockMessage(String username);

  /// No description provided for @splitBlockAction.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get splitBlockAction;

  /// No description provided for @splitBlockedSnack.
  ///
  /// In en, this message translates to:
  /// **'Blocked {username}'**
  String splitBlockedSnack(String username);

  /// No description provided for @splitGameScoreMessage.
  ///
  /// In en, this message translates to:
  /// **'🎮 I scored {score} in Whack-a-Debt!'**
  String splitGameScoreMessage(int score);

  /// No description provided for @splitGroupLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load group: {error}'**
  String splitGroupLoadFailed(String error);

  /// No description provided for @splitGroupNotFound.
  ///
  /// In en, this message translates to:
  /// **'Group not found'**
  String get splitGroupNotFound;

  /// No description provided for @splitBillsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load bills: {error}'**
  String splitBillsLoadFailed(String error);

  /// No description provided for @balanceAllSettled.
  ///
  /// In en, this message translates to:
  /// **'All settled up'**
  String get balanceAllSettled;

  /// No description provided for @balanceOwedToYou.
  ///
  /// In en, this message translates to:
  /// **'Owed to you'**
  String get balanceOwedToYou;

  /// No description provided for @balanceYouOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe'**
  String get balanceYouOwe;

  /// No description provided for @billAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Bill'**
  String get billAdd;

  /// No description provided for @billLimitReachedPremium.
  ///
  /// In en, this message translates to:
  /// **'This group has reached its limit of {count, plural, =1{1 bill} other{{count} bills}}. Delete a bill to add a new one.'**
  String billLimitReachedPremium(int count);

  /// No description provided for @billTotal.
  ///
  /// In en, this message translates to:
  /// **'Total {amount}'**
  String billTotal(String amount);

  /// No description provided for @billPaidByYou.
  ///
  /// In en, this message translates to:
  /// **'Paid by you'**
  String get billPaidByYou;

  /// No description provided for @billPaidByName.
  ///
  /// In en, this message translates to:
  /// **'Paid by {name}'**
  String billPaidByName(String name);

  /// No description provided for @billAllConfirmed.
  ///
  /// In en, this message translates to:
  /// **'All confirmed'**
  String get billAllConfirmed;

  /// No description provided for @billDisputedReview.
  ///
  /// In en, this message translates to:
  /// **'{count} disputed — tap to review'**
  String billDisputedReview(int count);

  /// No description provided for @billWaitingOnYou.
  ///
  /// In en, this message translates to:
  /// **'{count} waiting on you'**
  String billWaitingOnYou(int count);

  /// No description provided for @billWaitingPayments.
  ///
  /// In en, this message translates to:
  /// **'Waiting on payments'**
  String get billWaitingPayments;

  /// No description provided for @billDisputed.
  ///
  /// In en, this message translates to:
  /// **'Disputed'**
  String get billDisputed;

  /// No description provided for @billMarkPaidAgain.
  ///
  /// In en, this message translates to:
  /// **'Mark paid again'**
  String get billMarkPaidAgain;

  /// No description provided for @billWaitingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Waiting on confirmation'**
  String get billWaitingConfirmation;

  /// No description provided for @billMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark paid'**
  String get billMarkPaid;

  /// No description provided for @activityFormerMemberCap.
  ///
  /// In en, this message translates to:
  /// **'A former member'**
  String get activityFormerMemberCap;

  /// No description provided for @activityFormerMember.
  ///
  /// In en, this message translates to:
  /// **'a former member'**
  String get activityFormerMember;

  /// No description provided for @activityABill.
  ///
  /// In en, this message translates to:
  /// **'a bill'**
  String get activityABill;

  /// No description provided for @activitySomeone.
  ///
  /// In en, this message translates to:
  /// **'someone'**
  String get activitySomeone;

  /// No description provided for @activityFormerBeast.
  ///
  /// In en, this message translates to:
  /// **'Former Beast'**
  String get activityFormerBeast;

  /// No description provided for @activityBillAdded.
  ///
  /// In en, this message translates to:
  /// **'{sender} added “{title}”'**
  String activityBillAdded(String sender, String title);

  /// No description provided for @activityBillAddedAmount.
  ///
  /// In en, this message translates to:
  /// **'{sender} added “{title}” — {amount}'**
  String activityBillAddedAmount(String sender, String title, String amount);

  /// No description provided for @activityPaymentMarked.
  ///
  /// In en, this message translates to:
  /// **'{sender} marked their share as paid'**
  String activityPaymentMarked(String sender);

  /// No description provided for @activityPaymentConfirmedTarget.
  ///
  /// In en, this message translates to:
  /// **'{sender} confirmed {target}’s payment'**
  String activityPaymentConfirmedTarget(String sender, String target);

  /// No description provided for @activityPaymentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'{sender} confirmed a payment'**
  String activityPaymentConfirmed(String sender);

  /// No description provided for @activityPaymentDisputedTarget.
  ///
  /// In en, this message translates to:
  /// **'{sender} disputed {target}’s payment'**
  String activityPaymentDisputedTarget(String sender, String target);

  /// No description provided for @activityPaymentDisputed.
  ///
  /// In en, this message translates to:
  /// **'{sender} disputed a payment'**
  String activityPaymentDisputed(String sender);

  /// No description provided for @activityMemberAdded.
  ///
  /// In en, this message translates to:
  /// **'{sender} added {target} to the group'**
  String activityMemberAdded(String sender, String target);

  /// No description provided for @activityPoke.
  ///
  /// In en, this message translates to:
  /// **'{article} {character} poked the group!'**
  String activityPoke(String article, String character);

  /// No description provided for @activityPhotoSent.
  ///
  /// In en, this message translates to:
  /// **'{sender} sent a photo'**
  String activityPhotoSent(String sender);

  /// No description provided for @activityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get activityEmpty;

  /// No description provided for @photoExpiresIn3Days.
  ///
  /// In en, this message translates to:
  /// **'This photo will expire in 3 days'**
  String get photoExpiresIn3Days;

  /// No description provided for @photoExpiresInDays.
  ///
  /// In en, this message translates to:
  /// **'Expires in {count, plural, =1{1 day} other{{count} days}}'**
  String photoExpiresInDays(int count);

  /// No description provided for @photoExpiresInHours.
  ///
  /// In en, this message translates to:
  /// **'Expires in {count}h'**
  String photoExpiresInHours(int count);

  /// No description provided for @photoExpiresInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Expires in {count}m'**
  String photoExpiresInMinutes(int count);

  /// No description provided for @photoExpired.
  ///
  /// In en, this message translates to:
  /// **'Photo expired'**
  String get photoExpired;

  /// No description provided for @linkOpenTitle.
  ///
  /// In en, this message translates to:
  /// **'Open link?'**
  String get linkOpenTitle;

  /// No description provided for @linkOpenMessage.
  ///
  /// In en, this message translates to:
  /// **'You’re about to leave Salapify and open:\n\n{url}'**
  String linkOpenMessage(String url);

  /// No description provided for @commonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// No description provided for @linkOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open this link.'**
  String get linkOpenFailed;

  /// No description provided for @chatNotifyAll.
  ///
  /// In en, this message translates to:
  /// **'Notify all members'**
  String get chatNotifyAll;

  /// No description provided for @chatAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get chatAddPhoto;

  /// No description provided for @chatMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Message the group...'**
  String get chatMessageHint;

  /// No description provided for @chatPokeGroup.
  ///
  /// In en, this message translates to:
  /// **'Poke the group'**
  String get chatPokeGroup;

  /// No description provided for @chatSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get chatSendMessage;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report User'**
  String get reportTitle;

  /// No description provided for @reportReporting.
  ///
  /// In en, this message translates to:
  /// **'Reporting'**
  String get reportReporting;

  /// No description provided for @reportWhatsGoingOn.
  ///
  /// In en, this message translates to:
  /// **'What’s going on?'**
  String get reportWhatsGoingOn;

  /// No description provided for @reportBeSpecific.
  ///
  /// In en, this message translates to:
  /// **'Be as specific as possible — include what happened clearly.'**
  String get reportBeSpecific;

  /// No description provided for @reportHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what happened...'**
  String get reportHint;

  /// No description provided for @reportDescribeIssue.
  ///
  /// In en, this message translates to:
  /// **'Please describe the issue'**
  String get reportDescribeIssue;

  /// No description provided for @reportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted'**
  String get reportSubmitted;

  /// No description provided for @reportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get reportSubmit;

  /// No description provided for @billEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Bill'**
  String get billEdit;

  /// No description provided for @billDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bill Details'**
  String get billDetailsTitle;

  /// No description provided for @billOnlyPayerEdit.
  ///
  /// In en, this message translates to:
  /// **'Only the person who paid can edit this bill.'**
  String get billOnlyPayerEdit;

  /// No description provided for @billLockedBanner.
  ///
  /// In en, this message translates to:
  /// **'Total amount and split are locked — someone already has payment activity on this bill.'**
  String get billLockedBanner;

  /// No description provided for @billSectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Bill details'**
  String get billSectionDetails;

  /// No description provided for @billTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Dinner @ KFC'**
  String get billTitleHint;

  /// No description provided for @billTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get billTitleLabel;

  /// No description provided for @billTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get billTitleRequired;

  /// No description provided for @billTotalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get billTotalAmountLabel;

  /// No description provided for @billAmountTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Amount can’t exceed {amount}'**
  String billAmountTooLarge(String amount);

  /// No description provided for @billLockedNote.
  ///
  /// In en, this message translates to:
  /// **'Locked — payment activity exists'**
  String get billLockedNote;

  /// No description provided for @billSectionSplit.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get billSectionSplit;

  /// No description provided for @billPaidByLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get billPaidByLabel;

  /// No description provided for @billSplitEqually.
  ///
  /// In en, this message translates to:
  /// **'Equally'**
  String get billSplitEqually;

  /// No description provided for @billSplitCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get billSplitCustom;

  /// No description provided for @billDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Bill'**
  String get billDelete;

  /// No description provided for @billDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this bill?'**
  String get billDeleteTitle;

  /// No description provided for @billDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get billDeleteMessage;

  /// No description provided for @billDeletedSnack.
  ///
  /// In en, this message translates to:
  /// **'Bill deleted. You can add a new one anytime.'**
  String get billDeletedSnack;

  /// No description provided for @billFormerMember.
  ///
  /// In en, this message translates to:
  /// **'Former member'**
  String get billFormerMember;

  /// No description provided for @billPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment status'**
  String get billPaymentStatus;

  /// No description provided for @billAwaitingReview.
  ///
  /// In en, this message translates to:
  /// **'{count} awaiting review'**
  String billAwaitingReview(int count);

  /// No description provided for @billStatusUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get billStatusUnpaid;

  /// No description provided for @billStatusSaysPaid.
  ///
  /// In en, this message translates to:
  /// **'Says paid — review'**
  String get billStatusSaysPaid;

  /// No description provided for @billStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get billStatusConfirmed;

  /// No description provided for @billDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get billDecline;

  /// No description provided for @notificationsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications: {error}'**
  String notificationsLoadFailed(String error);

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notificationsEarlier;

  /// No description provided for @notificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String notificationsUnread(int count);

  /// No description provided for @notificationsAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You’re all caught up'**
  String get notificationsAllCaughtUp;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationDeletedUser.
  ///
  /// In en, this message translates to:
  /// **'Deleted user'**
  String get notificationDeletedUser;

  /// No description provided for @notificationAddedToGroup.
  ///
  /// In en, this message translates to:
  /// **'{name} added you to “{group}”'**
  String notificationAddedToGroup(String name, String group);

  /// No description provided for @notificationBillAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added “{title}” in {group}'**
  String notificationBillAdded(String name, String title, String group);

  /// No description provided for @notificationPaymentMarked.
  ///
  /// In en, this message translates to:
  /// **'{name} marked their share as paid in {group}'**
  String notificationPaymentMarked(String name, String group);

  /// No description provided for @notificationPaymentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'{name} confirmed your payment in {group}'**
  String notificationPaymentConfirmed(String name, String group);

  /// No description provided for @notificationPaymentDisputed.
  ///
  /// In en, this message translates to:
  /// **'{name} disputed your payment in {group}'**
  String notificationPaymentDisputed(String name, String group);

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String timeHoursAgo(int count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String timeDaysAgo(int count);

  /// No description provided for @notificationGroupUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This group is no longer available.'**
  String get notificationGroupUnavailable;

  /// No description provided for @gameTitle.
  ///
  /// In en, this message translates to:
  /// **'Whack-a-Debt'**
  String get gameTitle;

  /// No description provided for @gameTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get gameTimeLabel;

  /// No description provided for @gameScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get gameScoreLabel;

  /// No description provided for @gameSecondsShort.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String gameSecondsShort(int seconds);

  /// No description provided for @gameHint.
  ///
  /// In en, this message translates to:
  /// **'Tap your friends. Avoid the rhinos (-{penalty})!'**
  String gameHint(int penalty);

  /// No description provided for @gameReady.
  ///
  /// In en, this message translates to:
  /// **'Ready?'**
  String get gameReady;

  /// No description provided for @gameYouHaveSeconds.
  ///
  /// In en, this message translates to:
  /// **'You have {seconds, plural, =1{1 second} other{{seconds} seconds}}.'**
  String gameYouHaveSeconds(int seconds);

  /// No description provided for @gameWhackBeasts.
  ///
  /// In en, this message translates to:
  /// **'Whack the beasts'**
  String get gameWhackBeasts;

  /// No description provided for @gameWhackBeastsDesc.
  ///
  /// In en, this message translates to:
  /// **'+1 point for every hit'**
  String get gameWhackBeastsDesc;

  /// No description provided for @gameAvoidRhino.
  ///
  /// In en, this message translates to:
  /// **'Avoid the black rhino!'**
  String get gameAvoidRhino;

  /// No description provided for @gameAvoidRhinoDesc.
  ///
  /// In en, this message translates to:
  /// **'-{penalty, plural, =1{1 point} other{{penalty} points}}. Avoid it at all cost!'**
  String gameAvoidRhinoDesc(int penalty);

  /// No description provided for @gameStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get gameStart;

  /// No description provided for @gameTimesUp.
  ///
  /// In en, this message translates to:
  /// **'Time’s up!'**
  String get gameTimesUp;

  /// No description provided for @gameCountingScore.
  ///
  /// In en, this message translates to:
  /// **'Counting your score...'**
  String get gameCountingScore;

  /// No description provided for @gameResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Your result'**
  String get gameResultTitle;

  /// No description provided for @gameYourScore.
  ///
  /// In en, this message translates to:
  /// **'YOUR SCORE'**
  String get gameYourScore;

  /// No description provided for @gameMessageWarmingUp.
  ///
  /// In en, this message translates to:
  /// **'Just warming up!'**
  String get gameMessageWarmingUp;

  /// No description provided for @gameMessageNice.
  ///
  /// In en, this message translates to:
  /// **'Nice whacking!'**
  String get gameMessageNice;

  /// No description provided for @gameMessageGreat.
  ///
  /// In en, this message translates to:
  /// **'You’re a great whacker!'**
  String get gameMessageGreat;

  /// No description provided for @gameMessageSuperstar.
  ///
  /// In en, this message translates to:
  /// **'Whack superstar!'**
  String get gameMessageSuperstar;

  /// No description provided for @gamePlayAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get gamePlayAgain;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpTitle;

  /// No description provided for @helpSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a topic...'**
  String get helpSearchHint;

  /// No description provided for @helpNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results for “{query}”'**
  String helpNoResults(String query);

  /// No description provided for @faqSectionStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get faqSectionStarted;

  /// No description provided for @faqSectionBudgeting.
  ///
  /// In en, this message translates to:
  /// **'Budgeting'**
  String get faqSectionBudgeting;

  /// No description provided for @faqSectionTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions & Income'**
  String get faqSectionTransactions;

  /// No description provided for @faqSectionSplit.
  ///
  /// In en, this message translates to:
  /// **'Split Bills'**
  String get faqSectionSplit;

  /// No description provided for @faqSectionPeriods.
  ///
  /// In en, this message translates to:
  /// **'Periods & Settings'**
  String get faqSectionPeriods;

  /// No description provided for @faqSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get faqSectionNotifications;

  /// No description provided for @faqStartedQ1.
  ///
  /// In en, this message translates to:
  /// **'What does Salapify do?'**
  String get faqStartedQ1;

  /// No description provided for @faqStartedA1.
  ///
  /// In en, this message translates to:
  /// **'Salapify combines budget tracking with bill splitting. Use the Budget tab to allocate money into categories, the Transactions tab to log your income and spending, and the Split Bills tab to settle shared expenses with friends or other users, all in one place.'**
  String get faqStartedA1;

  /// No description provided for @faqBudgetQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I create a budget category?'**
  String get faqBudgetQ1;

  /// No description provided for @faqBudgetA1.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button on the Budget tab. Enter a category name, such as Internet Bill or Groceries, then set its allocation. Choose whether it’s Fixed or Variable, and set how often it repeats. Fill in the remaining fields, then save your category.'**
  String get faqBudgetA1;

  /// No description provided for @faqBudgetQ2.
  ///
  /// In en, this message translates to:
  /// **'What’s the difference between Fixed and Variable?'**
  String get faqBudgetQ2;

  /// No description provided for @faqBudgetA2.
  ///
  /// In en, this message translates to:
  /// **'Fixed is for predictable costs, like an Internet Bill, where you set one exact amount. Variable is for spending that changes, like Groceries, where you set a target ceiling instead of an exact amount.'**
  String get faqBudgetA2;

  /// No description provided for @faqBudgetQ3.
  ///
  /// In en, this message translates to:
  /// **'What happens when I check off a category as completed?'**
  String get faqBudgetQ3;

  /// No description provided for @faqBudgetA3.
  ///
  /// In en, this message translates to:
  /// **'Marking a category as complete automatically logs it as a transaction for the current period. The category is also marked as done and moved to the bottom of the list.'**
  String get faqBudgetA3;

  /// No description provided for @faqBudgetQ4.
  ///
  /// In en, this message translates to:
  /// **'Why are some categories dimmed on my Budget tab?'**
  String get faqBudgetQ4;

  /// No description provided for @faqBudgetA4.
  ///
  /// In en, this message translates to:
  /// **'Dimmed categories belong to the other half of the period when you use bi-monthly budgeting. They’ll come back into focus automatically when their half of the period begins.'**
  String get faqBudgetA4;

  /// No description provided for @faqTxQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I add a transaction or income?'**
  String get faqTxQ1;

  /// No description provided for @faqTxA1.
  ///
  /// In en, this message translates to:
  /// **'From the Transactions tab, tap + to add an expense or income entry. For income, choose whether it’s One-time or Recurring. Recurring entries are added automatically at the start of each new period.'**
  String get faqTxA1;

  /// No description provided for @faqTxQ2.
  ///
  /// In en, this message translates to:
  /// **'How do transactions affect my budget?'**
  String get faqTxQ2;

  /// No description provided for @faqTxA2.
  ///
  /// In en, this message translates to:
  /// **'When you log a transaction, you assign it to a budget category. The amount is automatically deducted from that category’s allocation, so your Budget tab always shows what’s left to spend.'**
  String get faqTxA2;

  /// No description provided for @faqTxQ3.
  ///
  /// In en, this message translates to:
  /// **'How do I delete an income or expense?'**
  String get faqTxQ3;

  /// No description provided for @faqTxA3.
  ///
  /// In en, this message translates to:
  /// **'Go to the Transactions tab and swipe left on the income or expense you want to remove. Confirm the deletion if you are prompted.'**
  String get faqTxA3;

  /// No description provided for @faqTxQ4.
  ///
  /// In en, this message translates to:
  /// **'Why don’t I see last period’s transactions?'**
  String get faqTxQ4;

  /// No description provided for @faqTxA4.
  ///
  /// In en, this message translates to:
  /// **'The Budget and Transactions tabs only show totals for the current period, based on the budgeting period you set in Settings. This keeps the numbers focused on what you can still act on.'**
  String get faqTxA4;

  /// No description provided for @faqSplitQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I split a bill with friends?'**
  String get faqSplitQ1;

  /// No description provided for @faqSplitA1.
  ///
  /// In en, this message translates to:
  /// **'Create a group and add members by their usernames. Inside the group, create a bill (e.g. “Dinner @ KFC”), enter the amount you paid, and split it equally or with custom shares for each member.'**
  String get faqSplitA1;

  /// No description provided for @faqSplitQ2.
  ///
  /// In en, this message translates to:
  /// **'How do I delete a Split Bills group?'**
  String get faqSplitQ2;

  /// No description provided for @faqSplitA2.
  ///
  /// In en, this message translates to:
  /// **'If you created the group, swipe left on it to delete it. Deleting a group also removes all of its shared bill activity.'**
  String get faqSplitA2;

  /// No description provided for @faqSplitQ3.
  ///
  /// In en, this message translates to:
  /// **'How do I leave a Split Bills group?'**
  String get faqSplitQ3;

  /// No description provided for @faqSplitA3.
  ///
  /// In en, this message translates to:
  /// **'If you’re a member of a group, swipe left on it and choose Leave. This removes you from the group without deleting it for everyone else.'**
  String get faqSplitA3;

  /// No description provided for @faqSplitQ4.
  ///
  /// In en, this message translates to:
  /// **'Can I share receipts or chat with my group?'**
  String get faqSplitQ4;

  /// No description provided for @faqSplitA4.
  ///
  /// In en, this message translates to:
  /// **'Yes. Every group has an Activity section where you can message members and share photos, such as receipts, alongside the bill history.'**
  String get faqSplitA4;

  /// No description provided for @faqSplitQ5.
  ///
  /// In en, this message translates to:
  /// **'Do Split Bills affect my personal budget?'**
  String get faqSplitQ5;

  /// No description provided for @faqSplitA5.
  ///
  /// In en, this message translates to:
  /// **'No. Split Bills is kept separate from your Budget and Transactions tabs. If you want a settled bill to count toward your spending, log it manually as a transaction.'**
  String get faqSplitA5;

  /// No description provided for @faqSplitQ6.
  ///
  /// In en, this message translates to:
  /// **'How do I report or block someone in a group?'**
  String get faqSplitQ6;

  /// No description provided for @faqSplitA6.
  ///
  /// In en, this message translates to:
  /// **'In the group’s Activity tab, press and hold a member’s avatar next to their message to open a menu with Report and Block options. Blocking hides their messages and activity, and you can undo it anytime from Settings.'**
  String get faqSplitA6;

  /// No description provided for @faqPeriodQ1.
  ///
  /// In en, this message translates to:
  /// **'What’s the difference between Monthly and Bi-Monthly?'**
  String get faqPeriodQ1;

  /// No description provided for @faqPeriodA1.
  ///
  /// In en, this message translates to:
  /// **'Monthly resets your budget on the 1st of every month. Bi-Monthly splits the month into two halves: you choose the day the first half ends, and the rest of the month becomes the second half.'**
  String get faqPeriodA1;

  /// No description provided for @faqPeriodQ2.
  ///
  /// In en, this message translates to:
  /// **'What happens to my categories if I change the period?'**
  String get faqPeriodQ2;

  /// No description provided for @faqPeriodA2.
  ///
  /// In en, this message translates to:
  /// **'Existing categories are converted to match the new period and keep their amounts. Categories tied to a specific half will now count toward the full month (or vice versa), so review them afterward to check for duplicates.'**
  String get faqPeriodA2;

  /// No description provided for @faqPeriodQ3.
  ///
  /// In en, this message translates to:
  /// **'How does recurrence work with bi-monthly budgeting?'**
  String get faqPeriodQ3;

  /// No description provided for @faqPeriodA3.
  ///
  /// In en, this message translates to:
  /// **'A recurring category repeats in every half you’ve assigned it to. If you switch to Monthly, the same item simply repeats once a month instead.'**
  String get faqPeriodA3;

  /// No description provided for @faqNotifQ1.
  ///
  /// In en, this message translates to:
  /// **'What shows up in the Notifications tab?'**
  String get faqNotifQ1;

  /// No description provided for @faqNotifA1.
  ///
  /// In en, this message translates to:
  /// **'You’ll see updates on Split Bills activity, as well as alerts when a payer disputes or confirms one of your shares.'**
  String get faqNotifA1;

  /// No description provided for @faqNotifQ2.
  ///
  /// In en, this message translates to:
  /// **'Can I turn off notifications?'**
  String get faqNotifQ2;

  /// No description provided for @faqNotifA2.
  ///
  /// In en, this message translates to:
  /// **'Yes. Go to your device Settings > Apps > Salapify > Notifications, where you can turn off alerts entirely or choose which types of alerts you want to receive.'**
  String get faqNotifA2;

  /// Hint shown under the title of the first-launch language picker
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime in Settings.'**
  String get languageChangeLaterHint;
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
      <String>['en', 'es', 'th', 'tr', 'zh'].contains(locale.languageCode);

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
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
