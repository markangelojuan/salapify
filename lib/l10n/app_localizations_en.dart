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

  @override
  String get budgetAllocations => 'ALLOCATIONS';

  @override
  String get budgetNoCategories => 'No categories yet';

  @override
  String get budgetFilter => 'Filter';

  @override
  String budgetFiltersCount(int count) {
    return 'Filters ($count)';
  }

  @override
  String get budgetClearFiltersToReorder =>
      'Clear filters to reorder categories';

  @override
  String get budgetNoMatch => 'No categories match your filters';

  @override
  String get budgetClearFilters => 'Clear filters';

  @override
  String budgetLoadFailed(String error) {
    return 'Failed to load categories: $error';
  }

  @override
  String budgetAutoCompleted(String name) {
    return '$name auto-completed — spending reached the budget.';
  }

  @override
  String get budgetFilterTitle => 'Filter Categories';

  @override
  String get commonClearAll => 'Clear all';

  @override
  String get budgetFilterStatus => 'Status';

  @override
  String get budgetFilterAll => 'All';

  @override
  String get budgetFilterPending => 'Pending';

  @override
  String get budgetFilterCompleted => 'Completed';

  @override
  String get budgetFilterType => 'Type';

  @override
  String get budgetTypeFixed => 'Fixed';

  @override
  String get budgetTypeVariable => 'Variable';

  @override
  String get budgetFilterRecurrence => 'Recurrence';

  @override
  String get commonApply => 'Apply';

  @override
  String commonApplyCount(int count) {
    return 'Apply ($count)';
  }

  @override
  String get budgetFreqOnce => 'One-time';

  @override
  String get budgetFreqRecurring => 'Recurring';

  @override
  String get budgetFreqFirstHalf => 'First Half';

  @override
  String get budgetFreqSecondHalf => 'Second Half';

  @override
  String budgetPeriodMonthly(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMM(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String budgetPeriodFirstHalf(DateTime month, int start, int end) {
    final intl.DateFormat monthDateFormat = intl.DateFormat.MMM(localeName);
    final String monthString = monthDateFormat.format(month);

    return '1st Half · $monthString $start–$end';
  }

  @override
  String budgetPeriodSecondHalf(DateTime month, int start, int end) {
    final intl.DateFormat monthDateFormat = intl.DateFormat.MMM(localeName);
    final String monthString = monthDateFormat.format(month);

    return '2nd Half · $monthString $start–$end';
  }

  @override
  String get budgetUsed => 'used';

  @override
  String get budgetOverBudget => 'Over budget';

  @override
  String get budgetRemaining => 'Remaining';

  @override
  String get budgetSpent => 'Spent';

  @override
  String get budgetAllocated => 'Allocated';

  @override
  String get categoryCardFirstHalf => '1st half';

  @override
  String get categoryCardSecondHalf => '2nd half';

  @override
  String get categoryCardBiMonthly => 'Bi-monthly';

  @override
  String get categoryMarkIncompleteTitle => 'Mark as incomplete?';

  @override
  String get categoryMarkIncompleteMessage =>
      'Auto-generated expenses will be deleted. Manually added expenses will remain and may mark this category complete again.';

  @override
  String get categoryMarkIncompleteAction => 'Mark Incomplete';

  @override
  String get categoryAdd => 'Add Category';

  @override
  String get categoryEdit => 'Edit Category';

  @override
  String get categoryDelete => 'Delete Category';

  @override
  String get categoryNameLabel => 'Category Name';

  @override
  String get categoryNameHint => 'e.g. Groceries, Internet Bill';

  @override
  String get categoryNameRequired => 'Name is required';

  @override
  String amountLabelWithSymbol(String symbol) {
    return 'Amount ($symbol)';
  }

  @override
  String get amountRequired => 'Amount is required';

  @override
  String get amountInvalid => 'Enter a valid amount';

  @override
  String get amountTooLarge => 'Amount is too large';

  @override
  String get categoryTypeLabel => 'Type';

  @override
  String get categoryFixedTooltip => 'Fixed: Same amount each time.';

  @override
  String get categoryVariableTooltip =>
      'Variable: Amount may change each time.';

  @override
  String get categoryRepeat => 'Repeat';

  @override
  String get categoryEveryMonth => 'Every month';

  @override
  String get categoryOnce => 'Once';

  @override
  String get categoryEveryPeriod => 'Every period';

  @override
  String get categoryBothHalves => 'Both halves';

  @override
  String get categoryFirstHalf => 'First half';

  @override
  String get categorySecondHalf => 'Second half';

  @override
  String get categoryIcon => 'Icon';

  @override
  String get commonSaveChanges => 'Save Changes';

  @override
  String get transactionTabExpenses => 'Expenses';

  @override
  String get transactionTabIncome => 'Income';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String dateMonthDay(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String dateMonthDayYear(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get expensesEmpty => 'No expenses yet';

  @override
  String expensesLoadFailed(String error) {
    return 'Failed to load expenses: $error';
  }

  @override
  String get expensesDeleteTitle => 'Delete this expense?';

  @override
  String get expensesDeleteMessage =>
      'It will no longer count toward your spending totals.';

  @override
  String get transactionDeletedCategory => 'Deleted category';

  @override
  String get transactionAutoNote => 'Remaining budget (auto)';

  @override
  String get incomeEmpty => 'No income entries yet';

  @override
  String incomeLoadFailed(String error) {
    return 'Failed to load income: $error';
  }

  @override
  String get incomeDeleteTitle => 'Delete this income entry?';

  @override
  String get incomeDeleteMessage =>
      'It will no longer be counted toward total money.';

  @override
  String incomeEveryMonthOnDay(int day) {
    return 'Every month on day $day';
  }

  @override
  String incomeEveryMonthOnDayClamped(int day, int effective) {
    return 'Every month on day $day (day $effective this month)';
  }

  @override
  String get cashFlowInfo =>
      'Your expected income and savings this month. No history kept.';

  @override
  String get cashFlowSavings => 'Savings';

  @override
  String get expenseAdd => 'Add Expense';

  @override
  String get expenseEdit => 'Edit Expense';

  @override
  String get amountLabel => 'Amount';

  @override
  String get expenseCategory => 'Category';

  @override
  String get expenseSelectCategory => 'Please select a category';

  @override
  String get expenseNoCategories =>
      'No categories yet — add one from the Budget tab.';

  @override
  String get expenseDate => 'Date';

  @override
  String get expenseNoteLabel => 'Note (optional)';

  @override
  String get expenseNoteHint => 'e.g. Coffee with a friend';

  @override
  String get incomeAdd => 'Add Income';

  @override
  String get incomeEdit => 'Edit Income';

  @override
  String get incomeSourceLabel => 'Source';

  @override
  String get incomeSourceHint => 'e.g. Salary, Freelance, Gift';

  @override
  String get incomeSourceRequired => 'Source is required';

  @override
  String get incomeSourceTooLong => 'Keep it under 50 characters';

  @override
  String get incomeDepositDay => 'Deposit day';

  @override
  String get incomeCountedEveryPeriod =>
      'Counted as income for every period, regardless of the exact day.';

  @override
  String incomeAddedTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMM(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Will be added to: $dateString';
  }

  @override
  String get splitGroupNew => 'New Group';

  @override
  String get splitGroupEdit => 'Edit Group';

  @override
  String get splitGroupCreate => 'Create Group';

  @override
  String get splitGroupNameLabel => 'Group name';

  @override
  String get splitGroupNameHint => 'e.g. Roommates, Baguio Trip';

  @override
  String get splitGroupNameRequired => 'Enter a group name';

  @override
  String get splitAddMembers => 'Add members';

  @override
  String splitGroupFull(int count) {
    return 'Group is full ($count/$count members)';
  }

  @override
  String get splitNoUserFound => 'No user found';

  @override
  String get splitSearchByUsername => 'Search by username';

  @override
  String get splitUnknownUser => 'Unknown';

  @override
  String errorBillLimit(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit bills',
      one: '1 bill',
    );
    return 'This group has reached its limit of $_temp0';
  }

  @override
  String errorGroupLimit(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit active groups',
      one: '1 active group',
    );
    return 'You can only have $_temp0 on the free plan';
  }

  @override
  String errorMaxMembers(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit members',
      one: '1 member',
    );
    return 'Groups can have at most $_temp0';
  }

  @override
  String get splitDeleteGroupTitle => 'Delete this group?';

  @override
  String get splitLeaveGroupTitle => 'Leave this group?';

  @override
  String splitDeleteGroupMessage(String name) {
    return 'This deletes “$name” and its bills for everyone.';
  }

  @override
  String splitLeaveGroupMessage(String name) {
    return 'You’ll no longer see “$name” or its bills.';
  }

  @override
  String get splitLeave => 'Leave';

  @override
  String splitGroupsLoadFailed(String error) {
    return 'Failed to load groups: $error';
  }

  @override
  String get splitNoGroups => 'No groups yet';

  @override
  String splitMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get splitSettled => 'Settled';

  @override
  String splitOwed(String amount) {
    return 'Owed $amount';
  }

  @override
  String splitYouOwe(String amount) {
    return 'You owe $amount';
  }

  @override
  String get guestSplitTagline => 'Chip in. Settle up. Stay friends.';

  @override
  String get guestSplitDescription =>
      'Create groups, split bills, and see who owes who. Sign in to sync it all with your friends.';

  @override
  String get guestSplitCta => 'Sign in to get started';

  @override
  String splitBlockUser(String username) {
    return 'Block $username';
  }

  @override
  String splitReportUser(String username) {
    return 'Report $username';
  }

  @override
  String splitBlockTitle(String username) {
    return 'Block $username?';
  }

  @override
  String splitBlockMessage(String username) {
    return 'You won’t see $username’s messages or activity in shared groups, including bill updates. You can unblock them anytime from Settings.';
  }

  @override
  String get splitBlockAction => 'Block';

  @override
  String splitBlockedSnack(String username) {
    return 'Blocked $username';
  }

  @override
  String splitGameScoreMessage(int score) {
    return '🎮 I scored $score in Whack-a-Debt!';
  }

  @override
  String splitGroupLoadFailed(String error) {
    return 'Failed to load group: $error';
  }

  @override
  String get splitGroupNotFound => 'Group not found';

  @override
  String splitBillsLoadFailed(String error) {
    return 'Failed to load bills: $error';
  }

  @override
  String get balanceAllSettled => 'All settled up';

  @override
  String get balanceOwedToYou => 'Owed to you';

  @override
  String get balanceYouOwe => 'You owe';

  @override
  String get billAdd => 'Add Bill';

  @override
  String billLimitReachedPremium(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bills',
      one: '1 bill',
    );
    return 'This group has reached its limit of $_temp0. Delete a bill to add a new one.';
  }

  @override
  String billTotal(String amount) {
    return 'Total $amount';
  }

  @override
  String get billPaidByYou => 'Paid by you';

  @override
  String billPaidByName(String name) {
    return 'Paid by $name';
  }

  @override
  String get billAllConfirmed => 'All confirmed';

  @override
  String billDisputedReview(int count) {
    return '$count disputed — tap to review';
  }

  @override
  String billWaitingOnYou(int count) {
    return '$count waiting on you';
  }

  @override
  String get billWaitingPayments => 'Waiting on payments';

  @override
  String get billDisputed => 'Disputed';

  @override
  String get billMarkPaidAgain => 'Mark paid again';

  @override
  String get billWaitingConfirmation => 'Waiting on confirmation';

  @override
  String get billMarkPaid => 'Mark paid';

  @override
  String get activityFormerMemberCap => 'A former member';

  @override
  String get activityFormerMember => 'a former member';

  @override
  String get activityABill => 'a bill';

  @override
  String get activitySomeone => 'someone';

  @override
  String get activityFormerBeast => 'Former Beast';

  @override
  String activityBillAdded(String sender, String title) {
    return '$sender added “$title”';
  }

  @override
  String activityBillAddedAmount(String sender, String title, String amount) {
    return '$sender added “$title” — $amount';
  }

  @override
  String activityPaymentMarked(String sender) {
    return '$sender marked their share as paid';
  }

  @override
  String activityPaymentConfirmedTarget(String sender, String target) {
    return '$sender confirmed $target’s payment';
  }

  @override
  String activityPaymentConfirmed(String sender) {
    return '$sender confirmed a payment';
  }

  @override
  String activityPaymentDisputedTarget(String sender, String target) {
    return '$sender disputed $target’s payment';
  }

  @override
  String activityPaymentDisputed(String sender) {
    return '$sender disputed a payment';
  }

  @override
  String activityMemberAdded(String sender, String target) {
    return '$sender added $target to the group';
  }

  @override
  String activityPoke(String article, String character) {
    return '$article $character poked the group!';
  }

  @override
  String activityPhotoSent(String sender) {
    return '$sender sent a photo';
  }

  @override
  String get activityEmpty => 'No activity yet';

  @override
  String get photoExpiresIn3Days => 'This photo will expire in 3 days';

  @override
  String photoExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Expires in $_temp0';
  }

  @override
  String photoExpiresInHours(int count) {
    return 'Expires in ${count}h';
  }

  @override
  String photoExpiresInMinutes(int count) {
    return 'Expires in ${count}m';
  }

  @override
  String get photoExpired => 'Photo expired';

  @override
  String get linkOpenTitle => 'Open link?';

  @override
  String linkOpenMessage(String url) {
    return 'You’re about to leave Salapify and open:\n\n$url';
  }

  @override
  String get commonOpen => 'Open';

  @override
  String get linkOpenFailed => 'Couldn’t open this link.';

  @override
  String get chatNotifyAll => 'Notify all members';

  @override
  String get chatAddPhoto => 'Add photo';

  @override
  String get chatMessageHint => 'Message the group...';

  @override
  String get chatPokeGroup => 'Poke the group';

  @override
  String get chatSendMessage => 'Send message';

  @override
  String get reportTitle => 'Report User';

  @override
  String get reportReporting => 'Reporting';

  @override
  String get reportWhatsGoingOn => 'What’s going on?';

  @override
  String get reportBeSpecific =>
      'Be as specific as possible — include what happened clearly.';

  @override
  String get reportHint => 'Describe what happened...';

  @override
  String get reportDescribeIssue => 'Please describe the issue';

  @override
  String get reportSubmitted => 'Report submitted';

  @override
  String get reportSubmit => 'Submit Report';

  @override
  String get billEdit => 'Edit Bill';

  @override
  String get billDetailsTitle => 'Bill Details';

  @override
  String get billOnlyPayerEdit =>
      'Only the person who paid can edit this bill.';

  @override
  String get billLockedBanner =>
      'Total amount and split are locked — someone already has payment activity on this bill.';

  @override
  String get billSectionDetails => 'Bill details';

  @override
  String get billTitleHint => 'e.g. Dinner @ KFC';

  @override
  String get billTitleLabel => 'Title';

  @override
  String get billTitleRequired => 'Enter a title';

  @override
  String get billTotalAmountLabel => 'Total amount';

  @override
  String billAmountTooLarge(String amount) {
    return 'Amount can’t exceed $amount';
  }

  @override
  String get billLockedNote => 'Locked — payment activity exists';

  @override
  String get billSectionSplit => 'Split';

  @override
  String get billPaidByLabel => 'Paid by';

  @override
  String get billSplitEqually => 'Equally';

  @override
  String get billSplitCustom => 'Custom';

  @override
  String get billDelete => 'Delete Bill';

  @override
  String get billDeleteTitle => 'Delete this bill?';

  @override
  String get billDeleteMessage => 'This cannot be undone.';

  @override
  String get billDeletedSnack => 'Bill deleted. You can add a new one anytime.';

  @override
  String get billFormerMember => 'Former member';

  @override
  String get billPaymentStatus => 'Payment status';

  @override
  String billAwaitingReview(int count) {
    return '$count awaiting review';
  }

  @override
  String get billStatusUnpaid => 'Unpaid';

  @override
  String get billStatusSaysPaid => 'Says paid — review';

  @override
  String get billStatusConfirmed => 'Confirmed';

  @override
  String get billDecline => 'Decline';

  @override
  String notificationsLoadFailed(String error) {
    return 'Failed to load notifications: $error';
  }

  @override
  String get notificationsEmpty => 'No notifications yet';

  @override
  String get notificationsEarlier => 'Earlier';

  @override
  String notificationsUnread(int count) {
    return '$count unread';
  }

  @override
  String get notificationsAllCaughtUp => 'You’re all caught up';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationDeletedUser => 'Deleted user';

  @override
  String notificationAddedToGroup(String name, String group) {
    return '$name added you to “$group”';
  }

  @override
  String notificationBillAdded(String name, String title, String group) {
    return '$name added “$title” in $group';
  }

  @override
  String notificationPaymentMarked(String name, String group) {
    return '$name marked their share as paid in $group';
  }

  @override
  String notificationPaymentConfirmed(String name, String group) {
    return '$name confirmed your payment in $group';
  }

  @override
  String notificationPaymentDisputed(String name, String group) {
    return '$name disputed your payment in $group';
  }

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String timeHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String timeDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get notificationGroupUnavailable =>
      'This group is no longer available.';
}
