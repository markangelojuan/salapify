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

  @override
  String get authSignInSubtitle =>
      'Enter your credentials to access your account';

  @override
  String get authEmailLabel => 'Email Address';

  @override
  String get authEmailHint => 'Enter your email';

  @override
  String get authEmailRequired => 'Email is required';

  @override
  String get authEmailInvalid => 'Enter a valid email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get authPasswordRequired => 'Password is required';

  @override
  String get authPasswordInvalid => 'Invalid password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authOrContinueWith => 'Or continue with';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authNotMemberYet => 'Not part of the club yet?';

  @override
  String get authContinueAsGuest => 'Continue as guest';

  @override
  String get authResetPasswordTitle => 'Reset your password';

  @override
  String get authResetPasswordPrompt =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get authResetLinkSent =>
      'If an account exists for that email, a reset link is on its way. Check your inbox (and spam folder).';

  @override
  String get authSendLink => 'Send link';

  @override
  String get commonDone => 'Done';

  @override
  String get authSignUpSubtitle => 'Create an account to get started';

  @override
  String get authUsernameLabel => 'Username';

  @override
  String get authUsernameHint => 'Enter your preferred username';

  @override
  String get authUsernameRequired => 'Username is required';

  @override
  String get authUsernameNoSpaces => 'No leading or trailing spaces';

  @override
  String get authUsernameStartLetter => 'Must start with a letter';

  @override
  String get authUsernameAllowedChars =>
      'Only letters, numbers, and underscores allowed';

  @override
  String get authUsernameMinLetters => 'Minimum 3 letters';

  @override
  String get authUsernameMaxNumbers => 'Maximum 3 numbers';

  @override
  String get authPasswordPinLabel => 'Password / PIN';

  @override
  String get authPasswordPinHint => 'Enter your password / PIN';

  @override
  String get authPasswordMinLength => 'Minimum 6 characters';

  @override
  String get authConfirmPasswordLabel => 'Confirm Password / PIN';

  @override
  String get authConfirmPasswordHint => 'Re-enter your password / PIN';

  @override
  String get authConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get authPasswordsMismatch => 'Passwords do not match';

  @override
  String get authAgreeTerms =>
      'I agree to the Terms of Service and Privacy Policy';

  @override
  String get termsDialogTitle => 'Terms & Privacy';

  @override
  String get termsServiceHeading => 'Terms of Service';

  @override
  String get termsServiceBody =>
      'By using Salapify, you agree to use the app responsibly and provide accurate information. You are responsible for your account and the information you enter.';

  @override
  String get termsPrivacyHeading => 'Privacy Policy';

  @override
  String get termsPrivacyBody =>
      'Salapify collects information needed to provide your account, budgeting, expense tracking, groups, and bill-splitting features. We do not connect to your bank accounts or financial accounts, and we do not sell your personal information.';

  @override
  String get termsSharedHeading => 'Shared Information';

  @override
  String get termsSharedBody =>
      'When you join groups or split bills, relevant information such as your username, bills, and shares may be visible to other members of those groups.';

  @override
  String get termsImportantHeading => 'Important';

  @override
  String get termsImportantBody =>
      'Salapify is a budgeting and organization tool, not a bank, payment service, or financial adviser.';

  @override
  String get commonClose => 'Close';

  @override
  String get verifyEmailTitle => 'Verify your email';

  @override
  String get verifyEmailSentGeneric => 'We’ve sent you a verification link.';

  @override
  String verifyEmailSentTo(String email) {
    return 'We’ve sent a verification link to $email.';
  }

  @override
  String get verifyEmailInstructions =>
      'Click the link in that email, then tap the button below.';

  @override
  String get verifyEmailIVerified => 'I’ve verified';

  @override
  String get verifyEmailResend => 'Resend email';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get verifyEmailResent => 'Verification email sent.';

  @override
  String get verifyEmailNotYet =>
      'Not verified yet — check your inbox (and spam).';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get avatarPickerTitle => 'Which little money beast are you?';

  @override
  String get avatarPickerSubtitle => 'You can change this anytime';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get avatarLuxuriousDog => 'Luxurious Dog';

  @override
  String get avatarSavvyMonkey => 'Savvy Monkey';

  @override
  String get avatarGreedyCat => 'Greedy Cat';

  @override
  String get avatarThriftyPig => 'Thrifty Pig';

  @override
  String get avatarStingyTurtle => 'Stingy Turtle';

  @override
  String get avatarCovetousSnake => 'Covetous Snake';

  @override
  String get avatarProsperousPanda => 'Prosperous Panda';

  @override
  String get avatarFrugalShark => 'Frugal Shark';

  @override
  String get avatarOpulentWalrus => 'Opulent Walrus';

  @override
  String get avatarBrokeEagle => 'Broke Eagle';

  @override
  String get accountAvatarNotSelected => 'Not selected';

  @override
  String get prefsBudgetTitle => 'How do you budget?';

  @override
  String get prefsBudgetDescription =>
      'Your budget period decides when your category budgets reset.';

  @override
  String get prefsMonthlyDesc => 'One budget for the whole month';

  @override
  String get prefsTwiceMonthly => 'Twice a month';

  @override
  String get prefsTwiceMonthlyDesc =>
      'Split into two halves, great if you get paid twice';

  @override
  String prefsFirstHalfRange(int day) {
    return 'The first half runs from day 1 to day $day.';
  }

  @override
  String get prefsCurrencyTitle => 'Pick your currency';

  @override
  String get prefsCurrencyDescription =>
      'This is the symbol shown across your budgets and transactions.';

  @override
  String get prefsGetStarted => 'Get started';

  @override
  String get prefsUseDefaults => 'Use defaults';

  @override
  String get prefsChangeLater => 'You can change these anytime in Settings';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonChange => 'Change';

  @override
  String get accountUserFallback => 'User';

  @override
  String get accountProfileInfo => 'Profile info';

  @override
  String get accountEmail => 'Email';

  @override
  String get accountSignInMethod => 'Sign-in method';

  @override
  String get accountAvatar => 'Avatar';

  @override
  String get accountMembership => 'Membership';

  @override
  String get accountDangerZone => 'Danger zone';

  @override
  String get accountDeleteAccount => 'Delete account';

  @override
  String get accountDeleteAccountDesc =>
      'Permanently remove your account and all data';

  @override
  String get accountPremium => 'Premium';

  @override
  String get accountSeeWhatsInside => 'See what’s inside';

  @override
  String get accountPremiumDesc => 'Higher limits unlocked on this account';

  @override
  String get accountFreeDesc => 'Lift category, group and bill limits';

  @override
  String get commonSave => 'Save';

  @override
  String get commonRequired => 'Required';

  @override
  String get accountDeleteConfirmPhrase => 'Save small sums, see savings soar';

  @override
  String get accountDeleteWarning =>
      'This action is permanent and cannot be undone. All your data, transactions, and settings will be permanently deleted.';

  @override
  String accountDeleteTypePhrase(String phrase) {
    return 'Type “$phrase” to confirm';
  }

  @override
  String get accountDeleteReauthGoogle =>
      'For your security, please confirm your identity with Google before we delete your account.';

  @override
  String get accountDeleteReauthPassword =>
      'For your security, please enter your password to confirm.';

  @override
  String get accountVerifyWithGoogle => 'Verify with Google';

  @override
  String get accountDeletePermanently => 'Delete permanently';

  @override
  String get accountIncorrectPasswordRetry =>
      'Incorrect password. Please try again.';

  @override
  String get accountChangeUsername => 'Change username';

  @override
  String get accountUsernameUpdated => 'Username updated';

  @override
  String get accountChangePassword => 'Change password';

  @override
  String get accountCurrentPassword => 'Current password / PIN';

  @override
  String get accountNewPassword => 'New password / PIN';

  @override
  String get accountConfirmNewPassword => 'Confirm new password / PIN';

  @override
  String get accountIncorrectPassword => 'Incorrect password';

  @override
  String get accountPasswordUpdated => 'Password updated';

  @override
  String get accountUpdatePassword => 'Update password';

  @override
  String get premiumHeaderBadge => 'Be premium';

  @override
  String get premiumHeaderActiveBadge => 'You are premium';

  @override
  String get premiumHeadline => 'Remove every free-plan limit';

  @override
  String get premiumHeadlineActive => 'Every limit is removed on this account.';

  @override
  String get premiumSub => 'One-time payment. No subscription, ever.';

  @override
  String get premiumSubActive => 'Thanks for helping us maintain Salapify.';

  @override
  String get premiumWhatYouGet => 'What you get';

  @override
  String premiumFeatureCategories(int count) {
    return '$count active budget categories';
  }

  @override
  String premiumFeatureCategoriesFree(int count) {
    return 'Free plan: up to $count active';
  }

  @override
  String premiumFeatureGroups(int count) {
    return '$count active groups';
  }

  @override
  String premiumFeatureGroupsFree(int count) {
    return 'Free plan: up to $count active';
  }

  @override
  String premiumFeatureBills(int count) {
    return '$count active bills per group';
  }

  @override
  String premiumFeatureBillsFree(int count) {
    return 'Free plan: up to $count per group';
  }

  @override
  String get premiumFeatureAvatars => 'More beasts unlocked';

  @override
  String get premiumFeatureAvatarsDesc =>
      'Extra avatars to personalize your profile';

  @override
  String get premiumPricing => 'Pricing';

  @override
  String get premiumBestValue => 'BEST VALUE — PAY ONCE';

  @override
  String get premiumOneTimeFee => 'one-time fee';

  @override
  String get premiumRestorePurchase => 'Restore purchase';

  @override
  String get premiumSecurePayment => 'Secure one-time payment via App Store';

  @override
  String get premiumActiveOnAccount => 'Premium is active on this account';

  @override
  String get premiumGo => 'Go Premium';

  @override
  String premiumBuyWithPrice(String price) {
    return 'Buy — $price';
  }

  @override
  String get premiumRestored => 'Purchase restored — enjoy!';

  @override
  String get premiumUnlocked => 'You’re premium now — enjoy!';

  @override
  String get premiumErrorOtherAccount =>
      'This purchase is linked to a different account. Sign in with that account to restore it.';

  @override
  String get premiumNothingToRestore =>
      'No previous purchase found to restore.';

  @override
  String get premiumSignInFirst => 'Please sign in first to unlock premium.';

  @override
  String get premiumBillingUnavailable =>
      'Billing is unavailable right now. Please try again later.';

  @override
  String get premiumPurchaseFailed =>
      'Purchase didn’t go through. Please try again.';

  @override
  String get premiumLimitCategories =>
      'Your budget is growing! You’ve filled every free category.';

  @override
  String get premiumLimitGroups =>
      'Your free group is all booked. Only one active at a time.';

  @override
  String get premiumLimitBills =>
      'Your bills are multiplying! The free slots are all used up.';

  @override
  String get premiumUpsellBenefit => 'One-time Premium unlock';

  @override
  String get premiumUpsellSupport =>
      'Support the app with a one-time purchase.';

  @override
  String get blockedUsersTitle => 'Blocked Users';

  @override
  String get blockedUsersEmpty => 'No blocked users';

  @override
  String unblockTitle(String username) {
    return 'Unblock $username?';
  }

  @override
  String get unblockMessage => 'They will be able to interact with you again.';

  @override
  String get unblockAction => 'Unblock';

  @override
  String unblockedSnack(String username) {
    return 'Unblocked $username';
  }

  @override
  String commonLoadFailed(String error) {
    return 'Failed to load: $error';
  }

  @override
  String get commonDelete => 'Delete';

  @override
  String confirmDeleteMessage(String itemName) {
    return 'Are you sure you want to delete “$itemName”? This cannot be undone.';
  }

  @override
  String get navBudget => 'Budget';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navSplitBill => 'Split Bill';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get tourMenuTitle => 'More Options';

  @override
  String get tourMenuDesc =>
      'Manage your account, budget period,\nother settings, and get help.';

  @override
  String get tourFabTitle => 'Quick Add';

  @override
  String get tourFabDesc =>
      'Tap + to quickly add a category,\ntransaction, or split-bill group.';

  @override
  String get tourBudgetTitle => 'Plan Your Budget';

  @override
  String get tourBudgetDesc =>
      'Set spending limits per category\nand see how much you have left.';

  @override
  String get tourTransactionsTitle => 'Track Your Expenses';

  @override
  String get tourTransactionsDesc =>
      'Track your income and expenses.\nUse + to add a transaction.';

  @override
  String get tourSplitTitle => 'Split Bills Easily';

  @override
  String get tourSplitDesc =>
      'Create a group, add bills,\nand chat with everyone.';

  @override
  String get tourSplitDescGuest =>
      'Split expenses with friends.\nSign in to unlock this feature.';

  @override
  String limitReachedCategories(int count) {
    return 'You’ve reached the limit of $count active categories. Delete one to add a new one.';
  }

  @override
  String limitReachedGroups(int count) {
    return 'You’ve reached the limit of $count groups. Delete a group to create a new one.';
  }

  @override
  String get drawerGuest => 'Guest';

  @override
  String get drawerGuestSubtitle => 'Sign in to save your data';

  @override
  String get drawerAccount => 'Account';

  @override
  String get drawerDarkMode => 'Dark Mode';

  @override
  String get drawerHelp => 'Help / FAQ';

  @override
  String get drawerLogout => 'Logout';
}
