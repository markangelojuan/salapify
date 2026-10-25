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
