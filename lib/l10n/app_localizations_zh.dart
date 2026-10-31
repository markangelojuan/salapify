// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '語言';

  @override
  String get languageSystemDefault => '跟隨系統';

  @override
  String get languageChoose => '選擇語言';

  @override
  String get settingsBudgetingPeriod => '預算週期';

  @override
  String get budgetingPeriodMonthly => '每月';

  @override
  String get budgetingPeriodMonthlyDesc => '每月追蹤一次預算';

  @override
  String get budgetingPeriodBiMonthly => '每月兩期';

  @override
  String get budgetingPeriodBiMonthlyDesc => '將一個月分成上下兩半';

  @override
  String get settingsFirstHalfEndsOn => '上半月結束於';

  @override
  String get settingsCurrency => '幣別';

  @override
  String get settingsReminders => '提醒';

  @override
  String get settingsAppReminders => 'App 提醒';

  @override
  String get settingsAppRemindersDesc => '偶爾提醒你更新預算';

  @override
  String get settingsPrivacy => '隱私權';

  @override
  String get settingsBlockedUsers => '已封鎖的使用者';

  @override
  String get changePeriodTitle => '變更預算週期';

  @override
  String get changePeriodMessage =>
      '現有的分類會轉換為符合新週期（金額不變）。原本設定在特定半月的分類，之後會改為計入整個月，反之亦然，建議事後檢查並合併重複的項目。要繼續嗎？';

  @override
  String get commonCancel => '取消';

  @override
  String get commonContinue => '繼續';

  @override
  String settingsLoadFailed(String error) {
    return '無法載入設定：$error';
  }

  @override
  String get currencyTapToChange => '點一下即可變更';

  @override
  String get currencyChoose => '選擇幣別';

  @override
  String get reminderMonthStartTitle => '新的一個月，新的預算 📊';

  @override
  String get reminderMonthStartBody => '更新你的預算，並記錄尚未登記的交易吧。';

  @override
  String get reminderMidMonthTitle => '月中小檢查 💸';

  @override
  String get reminderMidMonthBody => '別忘了記錄最近的支出喔。';

  @override
  String get settingsSyncFailedPeriod => '預算週期已儲存在此裝置，但無法同步到你的帳號。';

  @override
  String get settingsSyncFailedGeneric => '設定已儲存在此裝置，但無法同步到你的帳號。';

  @override
  String get settingsSyncFailedCurrency => '幣別已儲存在此裝置，但無法同步到你的帳號。';

  @override
  String get settingsNotificationsDisabled =>
      'Salapify 的通知已關閉。請到手機設定中開啟，才能收到提醒。';

  @override
  String get settingsConvertingCategories => '正在轉換你的分類…';

  @override
  String get errorUserNotFound => '嗯…找不到這個帳號。';

  @override
  String get errorInvalidCredential => '登入資訊似乎不正確。';

  @override
  String get errorEmailInUse => '這個電子郵件已經是我們的一份子了。';

  @override
  String get errorNetwork => '請檢查網路連線後再試一次。';

  @override
  String get errorTooManyRequests => '嘗試次數過多，請稍等一下再試。';

  @override
  String get errorUserDisabled => '這個帳號目前正在放長假。';

  @override
  String get errorWeakPassword => '這組密碼太容易被猜到了，換一組更長的吧。';

  @override
  String get errorRequiresRecentLogin => '為了你的安全，請先登出再重新登入，然後再試一次。';

  @override
  String get errorOffline => '你目前處於離線狀態，請檢查網路連線後再試一次。';

  @override
  String get errorGeneric => '小小卡了一下！再試一次？';

  @override
  String get errorUsernameTaken => '這個使用者名稱已被使用';

  @override
  String get errorEmailRegistered => '這個電子郵件已經註冊過了';

  @override
  String get errorWrongPassword => '密碼似乎不正確';

  @override
  String get errorReauthCancelled => '已取消確認';

  @override
  String get errorAccountDisabled => '這個帳號已被停用';

  @override
  String get authSignInSubtitle => '輸入你的登入資訊以進入帳號';

  @override
  String get authEmailLabel => '電子郵件';

  @override
  String get authEmailHint => '輸入你的電子郵件';

  @override
  String get authEmailRequired => '請輸入電子郵件';

  @override
  String get authEmailInvalid => '請輸入有效的電子郵件';

  @override
  String get authPasswordLabel => '密碼';

  @override
  String get authPasswordHint => '輸入你的密碼';

  @override
  String get authPasswordRequired => '請輸入密碼';

  @override
  String get authPasswordInvalid => '密碼無效';

  @override
  String get authForgotPassword => '忘記密碼？';

  @override
  String get authSignIn => '登入';

  @override
  String get authSignUp => '註冊';

  @override
  String get authOrContinueWith => '或使用以下方式繼續';

  @override
  String get authContinueWithGoogle => '使用 Google 繼續';

  @override
  String get authNotMemberYet => '還不是我們的一份子嗎？';

  @override
  String get authContinueAsGuest => '以訪客身分繼續';

  @override
  String get authResetPasswordTitle => '重設密碼';

  @override
  String get authResetPasswordPrompt => '輸入你的電子郵件，我們會寄送重設密碼的連結給你。';

  @override
  String get authResetLinkSent =>
      '如果這個電子郵件有對應的帳號，重設連結已經在路上了。請檢查你的收件匣（以及垃圾郵件匣）。';

  @override
  String get authSendLink => '寄送連結';

  @override
  String get commonDone => '完成';

  @override
  String get authSignUpSubtitle => '建立帳號即可開始使用';

  @override
  String get authUsernameLabel => '使用者名稱';

  @override
  String get authUsernameHint => '輸入你想使用的名稱';

  @override
  String get authUsernameRequired => '請輸入使用者名稱';

  @override
  String get authUsernameNoSpaces => '開頭和結尾不可有空格';

  @override
  String get authUsernameStartLetter => '必須以字母開頭';

  @override
  String get authUsernameAllowedChars => '只能使用字母、數字和底線';

  @override
  String get authUsernameMinLetters => '至少 3 個字母';

  @override
  String get authUsernameMaxNumbers => '數字最多 3 個';

  @override
  String get authPasswordPinLabel => '密碼 / PIN';

  @override
  String get authPasswordPinHint => '輸入你的密碼 / PIN';

  @override
  String get authPasswordMinLength => '至少 6 個字元';

  @override
  String get authConfirmPasswordLabel => '確認密碼 / PIN';

  @override
  String get authConfirmPasswordHint => '再次輸入你的密碼 / PIN';

  @override
  String get authConfirmPasswordRequired => '請確認你的密碼';

  @override
  String get authPasswordsMismatch => '兩次輸入的密碼不一致';

  @override
  String get authAgreeTerms => '我同意服務條款與隱私權政策';

  @override
  String get termsDialogTitle => '條款與隱私權';

  @override
  String get termsServiceHeading => '服務條款';

  @override
  String get termsServiceBody =>
      '使用 Salapify 即表示你同意負責任地使用本 App，並提供正確的資訊。你須為自己的帳號以及所輸入的資訊負責。';

  @override
  String get termsPrivacyHeading => '隱私權政策';

  @override
  String get termsPrivacyBody =>
      'Salapify 會蒐集提供帳號、預算、支出追蹤、群組及分帳功能所需的資訊。我們不會連結你的銀行帳戶或金融帳戶，也不會出售你的個人資料。';

  @override
  String get termsSharedHeading => '共享的資訊';

  @override
  String get termsSharedBody =>
      '當你加入群組或分帳時，相關資訊（例如你的使用者名稱、帳單和應付金額）可能會讓該群組的其他成員看到。';

  @override
  String get termsImportantHeading => '重要提醒';

  @override
  String get termsImportantBody => 'Salapify 是預算規劃與整理工具，並非銀行、支付服務或財務顧問。';

  @override
  String get commonClose => '關閉';

  @override
  String get verifyEmailTitle => '驗證你的電子郵件';

  @override
  String get verifyEmailSentGeneric => '我們已寄出驗證連結給你。';

  @override
  String verifyEmailSentTo(String email) {
    return '我們已將驗證連結寄到 $email。';
  }

  @override
  String get verifyEmailInstructions => '請點擊信中的連結，然後按下方的按鈕。';

  @override
  String get verifyEmailIVerified => '我已完成驗證';

  @override
  String get verifyEmailResend => '重新寄送郵件';

  @override
  String verifyEmailResendIn(int seconds) {
    return '$seconds 秒後可重新寄送';
  }

  @override
  String get verifyEmailResent => '驗證郵件已寄出。';

  @override
  String get verifyEmailNotYet => '尚未驗證 — 請檢查收件匣（以及垃圾郵件匣）。';

  @override
  String get commonSignOut => '登出';

  @override
  String get avatarPickerTitle => '你是哪一隻理財小野獸？';

  @override
  String get avatarPickerSubtitle => '隨時都可以更換';

  @override
  String get commonConfirm => '確認';

  @override
  String get avatarLuxuriousDog => '奢華狗狗';

  @override
  String get avatarSavvyMonkey => '精明猴子';

  @override
  String get avatarGreedyCat => '貪心貓咪';

  @override
  String get avatarThriftyPig => '節儉小豬';

  @override
  String get avatarStingyTurtle => '小氣烏龜';

  @override
  String get avatarCovetousSnake => '貪婪蛇蛇';

  @override
  String get avatarProsperousPanda => '富足熊貓';

  @override
  String get avatarFrugalShark => '精打細算鯊魚';

  @override
  String get avatarOpulentWalrus => '豪奢海象';

  @override
  String get avatarBrokeEagle => '破產老鷹';

  @override
  String get accountAvatarNotSelected => '尚未選擇';

  @override
  String get prefsBudgetTitle => '你都怎麼做預算？';

  @override
  String get prefsBudgetDescription => '預算週期決定各分類的預算何時重新計算。';

  @override
  String get prefsMonthlyDesc => '整個月只有一份預算';

  @override
  String get prefsTwiceMonthly => '每月兩次';

  @override
  String get prefsTwiceMonthlyDesc => '分成上下兩半，很適合一個月領兩次薪水的人';

  @override
  String prefsFirstHalfRange(int day) {
    return '上半月從 1 日到 $day 日。';
  }

  @override
  String get prefsCurrencyTitle => '選擇你的幣別';

  @override
  String get prefsCurrencyDescription => '這個符號會顯示在你所有的預算和交易中。';

  @override
  String get prefsGetStarted => '開始使用';

  @override
  String get prefsUseDefaults => '使用預設值';

  @override
  String get prefsChangeLater => '之後隨時可以在設定中變更';

  @override
  String get commonNext => '下一步';

  @override
  String get commonBack => '返回';

  @override
  String get commonChange => '變更';

  @override
  String get accountUserFallback => '使用者';

  @override
  String get accountProfileInfo => '個人資料';

  @override
  String get accountEmail => '電子郵件';

  @override
  String get accountSignInMethod => '登入方式';

  @override
  String get accountAvatar => '大頭貼';

  @override
  String get accountMembership => '會員資格';

  @override
  String get accountDangerZone => '危險區域';

  @override
  String get accountDeleteAccount => '刪除帳號';

  @override
  String get accountDeleteAccountDesc => '永久刪除你的帳號和所有資料';

  @override
  String get accountPremium => 'Premium';

  @override
  String get accountSeeWhatsInside => '看看有什麼內容';

  @override
  String get accountPremiumDesc => '此帳號已解鎖更高的使用上限';

  @override
  String get accountFreeDesc => '解除分類、群組和帳單的數量限制';

  @override
  String get commonSave => '儲存';

  @override
  String get commonRequired => '必填';

  @override
  String get accountDeleteConfirmPhrase => '積少成多，存款飆升';

  @override
  String get accountDeleteWarning => '此操作無法復原。你所有的資料、交易和設定都將被永久刪除。';

  @override
  String accountDeleteTypePhrase(String phrase) {
    return '請輸入「$phrase」以確認';
  }

  @override
  String get accountDeleteReauthGoogle => '為了你的安全，在刪除帳號之前，請先使用 Google 驗證你的身分。';

  @override
  String get accountDeleteReauthPassword => '為了你的安全，請輸入密碼以確認。';

  @override
  String get accountVerifyWithGoogle => '使用 Google 驗證';

  @override
  String get accountDeletePermanently => '永久刪除';

  @override
  String get accountIncorrectPasswordRetry => '密碼不正確，請再試一次。';

  @override
  String get accountChangeUsername => '變更使用者名稱';

  @override
  String get accountUsernameUpdated => '使用者名稱已更新';

  @override
  String get accountChangePassword => '變更密碼';

  @override
  String get accountCurrentPassword => '目前的密碼 / PIN';

  @override
  String get accountNewPassword => '新的密碼 / PIN';

  @override
  String get accountConfirmNewPassword => '確認新的密碼 / PIN';

  @override
  String get accountIncorrectPassword => '密碼不正確';

  @override
  String get accountPasswordUpdated => '密碼已更新';

  @override
  String get accountUpdatePassword => '更新密碼';

  @override
  String get premiumHeaderBadge => '升級 Premium';

  @override
  String get premiumHeaderActiveBadge => '你已是 Premium 會員';

  @override
  String get premiumHeadline => '解除免費方案的所有限制';

  @override
  String get premiumHeadlineActive => '此帳號已解除所有限制。';

  @override
  String get premiumSub => '一次付費，永遠不需訂閱。';

  @override
  String get premiumSubActive => '謝謝你幫助我們持續維護 Salapify。';

  @override
  String get premiumWhatYouGet => '你可以獲得';

  @override
  String premiumFeatureCategories(int count) {
    return '$count 個可使用的預算分類';
  }

  @override
  String premiumFeatureCategoriesFree(int count) {
    return '免費方案：最多 $count 個';
  }

  @override
  String premiumFeatureGroups(int count) {
    return '$count 個可使用的群組';
  }

  @override
  String premiumFeatureGroupsFree(int count) {
    return '免費方案：最多 $count 個';
  }

  @override
  String premiumFeatureBills(int count) {
    return '每個群組 $count 張可使用的帳單';
  }

  @override
  String premiumFeatureBillsFree(int count) {
    return '免費方案：每個群組最多 $count 張';
  }

  @override
  String get premiumFeatureAvatars => '解鎖更多小野獸';

  @override
  String get premiumFeatureAvatarsDesc => '更多大頭貼，讓你的個人資料更有個性';

  @override
  String get premiumPricing => '價格';

  @override
  String get premiumBestValue => '最超值 — 一次付費';

  @override
  String get premiumOneTimeFee => '一次性費用';

  @override
  String get premiumRestorePurchase => '還原購買';

  @override
  String get premiumSecurePayment => '透過 App Store 安全地一次付款';

  @override
  String get premiumActiveOnAccount => '此帳號已啟用 Premium';

  @override
  String get premiumGo => '升級 Premium';

  @override
  String premiumBuyWithPrice(String price) {
    return '購買 — $price';
  }

  @override
  String get premiumRestored => '已還原購買 — 盡情享受吧！';

  @override
  String get premiumUnlocked => '你現在是 Premium 會員了 — 盡情享受吧！';

  @override
  String get premiumErrorOtherAccount => '這筆購買綁定在其他帳號。請登入該帳號以還原。';

  @override
  String get premiumNothingToRestore => '找不到可還原的先前購買紀錄。';

  @override
  String get premiumSignInFirst => '請先登入才能解鎖 Premium。';

  @override
  String get premiumBillingUnavailable => '目前無法使用付款功能，請稍後再試。';

  @override
  String get premiumPurchaseFailed => '購買未成功，請再試一次。';

  @override
  String get premiumLimitCategories => '你的預算越來越豐富了！免費分類已經全部用完。';

  @override
  String get premiumLimitGroups => '你的免費群組已經額滿，一次只能有一個使用中的群組。';

  @override
  String get premiumLimitBills => '你的帳單越來越多了！免費名額已經用完。';

  @override
  String get premiumUpsellBenefit => '一次性解鎖 Premium';

  @override
  String get premiumUpsellSupport => '透過一次性購買來支持這個 App。';

  @override
  String get blockedUsersTitle => '已封鎖的使用者';

  @override
  String get blockedUsersEmpty => '沒有已封鎖的使用者';

  @override
  String unblockTitle(String username) {
    return '要解除封鎖 $username 嗎？';
  }

  @override
  String get unblockMessage => '對方將可以再次與你互動。';

  @override
  String get unblockAction => '解除封鎖';

  @override
  String unblockedSnack(String username) {
    return '已解除封鎖 $username';
  }

  @override
  String commonLoadFailed(String error) {
    return '載入失敗：$error';
  }

  @override
  String get commonDelete => '刪除';

  @override
  String confirmDeleteMessage(String itemName) {
    return '確定要刪除「$itemName」嗎？此操作無法復原。';
  }

  @override
  String get navBudget => '預算';

  @override
  String get navTransactions => '交易';

  @override
  String get navSplitBill => '分帳';

  @override
  String get navNotifications => '通知';

  @override
  String get tourMenuTitle => '更多選項';

  @override
  String get tourMenuDesc => '管理你的帳號、預算週期、\n其他設定，並取得協助。';

  @override
  String get tourFabTitle => '快速新增';

  @override
  String get tourFabDesc => '點一下 + 即可快速新增分類、\n交易或分帳群組。';

  @override
  String get tourBudgetTitle => '規劃你的預算';

  @override
  String get tourBudgetDesc => '為每個分類設定花費上限，\n隨時掌握還剩多少。';

  @override
  String get tourTransactionsTitle => '追蹤你的支出';

  @override
  String get tourTransactionsDesc => '記錄你的收入與支出。\n點 + 即可新增交易。';

  @override
  String get tourSplitTitle => '輕鬆分帳';

  @override
  String get tourSplitDesc => '建立群組、新增帳單，\n還能和大家聊天。';

  @override
  String get tourSplitDescGuest => '和朋友分攤費用。\n登入即可解鎖此功能。';

  @override
  String limitReachedCategories(int count) {
    return '你已達到 $count 個使用中分類的上限。請刪除一個再新增。';
  }

  @override
  String limitReachedGroups(int count) {
    return '你已達到 $count 個群組的上限。請刪除一個群組再建立新的。';
  }

  @override
  String get drawerGuest => '訪客';

  @override
  String get drawerGuestSubtitle => '登入以儲存你的資料';

  @override
  String get drawerAccount => '帳號';

  @override
  String get drawerDarkMode => '深色模式';

  @override
  String get drawerHelp => '說明 / 常見問題';

  @override
  String get drawerLogout => '登出';

  @override
  String get budgetAllocations => '預算分配';

  @override
  String get budgetNoCategories => '還沒有任何分類';

  @override
  String get budgetFilter => '篩選';

  @override
  String budgetFiltersCount(int count) {
    return '篩選（$count）';
  }

  @override
  String get budgetClearFiltersToReorder => '清除篩選後才能重新排序分類';

  @override
  String get budgetNoMatch => '沒有符合篩選條件的分類';

  @override
  String get budgetClearFilters => '清除篩選';

  @override
  String budgetLoadFailed(String error) {
    return '無法載入分類：$error';
  }

  @override
  String budgetAutoCompleted(String name) {
    return '$name 已自動完成 — 支出已達預算。';
  }

  @override
  String get budgetFilterTitle => '篩選分類';

  @override
  String get commonClearAll => '全部清除';

  @override
  String get budgetFilterStatus => '狀態';

  @override
  String get budgetFilterAll => '全部';

  @override
  String get budgetFilterPending => '進行中';

  @override
  String get budgetFilterCompleted => '已完成';

  @override
  String get budgetFilterType => '類型';

  @override
  String get budgetTypeFixed => '固定';

  @override
  String get budgetTypeVariable => '變動';

  @override
  String get budgetFilterRecurrence => '重複方式';

  @override
  String get commonApply => '套用';

  @override
  String commonApplyCount(int count) {
    return '套用（$count）';
  }

  @override
  String get budgetFreqOnce => '單次';

  @override
  String get budgetFreqRecurring => '重複';

  @override
  String get budgetFreqFirstHalf => '上半月';

  @override
  String get budgetFreqSecondHalf => '下半月';

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

    return '上半月 · $monthString $start–$end';
  }

  @override
  String budgetPeriodSecondHalf(DateTime month, int start, int end) {
    final intl.DateFormat monthDateFormat = intl.DateFormat.MMM(localeName);
    final String monthString = monthDateFormat.format(month);

    return '下半月 · $monthString $start–$end';
  }

  @override
  String get budgetUsed => '已使用';

  @override
  String get budgetOverBudget => '超出預算';

  @override
  String get budgetRemaining => '剩餘';

  @override
  String get budgetSpent => '已花費';

  @override
  String get budgetAllocated => '已分配';

  @override
  String get categoryCardFirstHalf => '上半月';

  @override
  String get categoryCardSecondHalf => '下半月';

  @override
  String get categoryCardBiMonthly => '每月兩期';

  @override
  String get categoryMarkIncompleteTitle => '要標示為未完成嗎？';

  @override
  String get categoryMarkIncompleteMessage =>
      '自動產生的支出將會被刪除。手動新增的支出會保留，並可能再次將此分類標示為已完成。';

  @override
  String get categoryMarkIncompleteAction => '標示為未完成';

  @override
  String get categoryAdd => '新增分類';

  @override
  String get categoryEdit => '編輯分類';

  @override
  String get categoryDelete => '刪除分類';

  @override
  String get categoryNameLabel => '分類名稱';

  @override
  String get categoryNameHint => '例如：餐費、網路費';

  @override
  String get categoryNameRequired => '請輸入名稱';

  @override
  String amountLabelWithSymbol(String symbol) {
    return '金額（$symbol）';
  }

  @override
  String get amountRequired => '請輸入金額';

  @override
  String get amountInvalid => '請輸入有效的金額';

  @override
  String get amountTooLarge => '金額過大';

  @override
  String get categoryTypeLabel => '類型';

  @override
  String get categoryFixedTooltip => '固定：每次金額相同。';

  @override
  String get categoryVariableTooltip => '變動：每次金額可能不同。';

  @override
  String get categoryRepeat => '重複頻率';

  @override
  String get categoryEveryMonth => '每個月';

  @override
  String get categoryOnce => '單次';

  @override
  String get categoryEveryPeriod => '每個週期';

  @override
  String get categoryBothHalves => '上下半月';

  @override
  String get categoryFirstHalf => '上半月';

  @override
  String get categorySecondHalf => '下半月';

  @override
  String get categoryIcon => '圖示';

  @override
  String get commonSaveChanges => '儲存變更';

  @override
  String get transactionTabExpenses => '支出';

  @override
  String get transactionTabIncome => '收入';

  @override
  String get dateToday => '今天';

  @override
  String get dateYesterday => '昨天';

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
  String get expensesEmpty => '還沒有任何支出';

  @override
  String expensesLoadFailed(String error) {
    return '無法載入支出：$error';
  }

  @override
  String get expensesDeleteTitle => '要刪除這筆支出嗎？';

  @override
  String get expensesDeleteMessage => '這筆支出將不再計入你的支出總額。';

  @override
  String get transactionDeletedCategory => '已刪除的分類';

  @override
  String get transactionAutoNote => '剩餘預算（自動）';

  @override
  String get incomeEmpty => '還沒有任何收入紀錄';

  @override
  String incomeLoadFailed(String error) {
    return '無法載入收入：$error';
  }

  @override
  String get incomeDeleteTitle => '要刪除這筆收入嗎？';

  @override
  String get incomeDeleteMessage => '這筆收入將不再計入資金總額。';

  @override
  String incomeEveryMonthOnDay(int day) {
    return '每月 $day 日';
  }

  @override
  String incomeEveryMonthOnDayClamped(int day, int effective) {
    return '每月 $day 日（本月為 $effective 日）';
  }

  @override
  String get cashFlowInfo => '你本月預期的收入與儲蓄。不保留歷史紀錄。';

  @override
  String get cashFlowSavings => '儲蓄';

  @override
  String get expenseAdd => '新增支出';

  @override
  String get expenseEdit => '編輯支出';

  @override
  String get amountLabel => '金額';

  @override
  String get expenseCategory => '分類';

  @override
  String get expenseSelectCategory => '請選擇分類';

  @override
  String get expenseNoCategories => '還沒有任何分類 — 請先到「預算」分頁新增。';

  @override
  String get expenseDate => '日期';

  @override
  String get expenseNoteLabel => '備註（選填）';

  @override
  String get expenseNoteHint => '例如：和朋友喝咖啡';

  @override
  String get incomeAdd => '新增收入';

  @override
  String get incomeEdit => '編輯收入';

  @override
  String get incomeSourceLabel => '來源';

  @override
  String get incomeSourceHint => '例如：薪水、接案、禮金';

  @override
  String get incomeSourceRequired => '請輸入來源';

  @override
  String get incomeSourceTooLong => '請控制在 50 個字元以內';

  @override
  String get incomeDepositDay => '入帳日';

  @override
  String get incomeCountedEveryPeriod => '每個週期都會計入收入，不論實際入帳日是哪一天。';

  @override
  String incomeAddedTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMM(localeName);
    final String dateString = dateDateFormat.format(date);

    return '將新增至：$dateString';
  }

  @override
  String get splitGroupNew => '新群組';

  @override
  String get splitGroupEdit => '編輯群組';

  @override
  String get splitGroupCreate => '建立群組';

  @override
  String get splitGroupNameLabel => '群組名稱';

  @override
  String get splitGroupNameHint => '例如：室友、墾丁之旅';

  @override
  String get splitGroupNameRequired => '請輸入群組名稱';

  @override
  String get splitAddMembers => '新增成員';

  @override
  String splitGroupFull(int count) {
    return '群組已滿（$count/$count 位成員）';
  }

  @override
  String get splitNoUserFound => '找不到使用者';

  @override
  String get splitSearchByUsername => '以使用者名稱搜尋';

  @override
  String get splitUnknownUser => '未知';

  @override
  String errorBillLimit(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit 張帳單',
      one: '1 張帳單',
    );
    return '這個群組已達 $_temp0的上限';
  }

  @override
  String errorGroupLimit(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit 個使用中的群組',
      one: '1 個使用中的群組',
    );
    return '免費方案最多只能有 $_temp0';
  }

  @override
  String errorMaxMembers(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit 位成員',
      one: '1 位成員',
    );
    return '群組最多只能有 $_temp0';
  }

  @override
  String get splitDeleteGroupTitle => '要刪除這個群組嗎？';

  @override
  String get splitLeaveGroupTitle => '要退出這個群組嗎？';

  @override
  String splitDeleteGroupMessage(String name) {
    return '這會為所有人刪除「$name」及其帳單。';
  }

  @override
  String splitLeaveGroupMessage(String name) {
    return '你將不會再看到「$name」及其帳單。';
  }

  @override
  String get splitLeave => '退出';

  @override
  String splitGroupsLoadFailed(String error) {
    return '無法載入群組：$error';
  }

  @override
  String get splitNoGroups => '還沒有任何群組';

  @override
  String splitMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位成員',
      one: '1 位成員',
    );
    return '$_temp0';
  }

  @override
  String get splitSettled => '已結清';

  @override
  String splitOwed(String amount) {
    return '應收 $amount';
  }

  @override
  String splitYouOwe(String amount) {
    return '你需付 $amount';
  }

  @override
  String get guestSplitTagline => '一起出錢，算清楚，繼續當好朋友。';

  @override
  String get guestSplitDescription => '建立群組、分攤帳單，一眼看出誰欠誰。登入後即可與朋友同步所有內容。';

  @override
  String get guestSplitCta => '登入即可開始';

  @override
  String splitBlockUser(String username) {
    return '封鎖 $username';
  }

  @override
  String splitReportUser(String username) {
    return '檢舉 $username';
  }

  @override
  String splitBlockTitle(String username) {
    return '要封鎖 $username 嗎？';
  }

  @override
  String splitBlockMessage(String username) {
    return '你將不會在共同群組中看到 $username 的訊息或動態，包括帳單更新。你隨時可以在設定中解除封鎖。';
  }

  @override
  String get splitBlockAction => '封鎖';

  @override
  String splitBlockedSnack(String username) {
    return '已封鎖 $username';
  }

  @override
  String splitGameScoreMessage(int score) {
    return '🎮 我在 Whack-a-Debt 拿到 $score 分！';
  }

  @override
  String splitGroupLoadFailed(String error) {
    return '無法載入群組：$error';
  }

  @override
  String get splitGroupNotFound => '找不到群組';

  @override
  String splitBillsLoadFailed(String error) {
    return '無法載入帳單：$error';
  }

  @override
  String get balanceAllSettled => '全部結清';

  @override
  String get balanceOwedToYou => '別人欠你';

  @override
  String get balanceYouOwe => '你欠別人';

  @override
  String get billAdd => '新增帳單';

  @override
  String billLimitReachedPremium(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 張帳單',
      one: '1 張帳單',
    );
    return '這個群組已達 $_temp0的上限。請刪除一張帳單再新增。';
  }

  @override
  String billTotal(String amount) {
    return '總計 $amount';
  }

  @override
  String get billPaidByYou => '由你支付';

  @override
  String billPaidByName(String name) {
    return '由 $name 支付';
  }

  @override
  String get billAllConfirmed => '全部已確認';

  @override
  String billDisputedReview(int count) {
    return '$count 筆有爭議 — 點一下查看';
  }

  @override
  String billWaitingOnYou(int count) {
    return '$count 筆等你確認';
  }

  @override
  String get billWaitingPayments => '等待付款';

  @override
  String get billDisputed => '有爭議';

  @override
  String get billMarkPaidAgain => '再次標示為已付款';

  @override
  String get billWaitingConfirmation => '等待確認';

  @override
  String get billMarkPaid => '標示為已付款';

  @override
  String get activityFormerMemberCap => '前成員';

  @override
  String get activityFormerMember => '前成員';

  @override
  String get activityABill => '一張帳單';

  @override
  String get activitySomeone => '某人';

  @override
  String get activityFormerBeast => '前小野獸';

  @override
  String activityBillAdded(String sender, String title) {
    return '$sender 新增了「$title」';
  }

  @override
  String activityBillAddedAmount(String sender, String title, String amount) {
    return '$sender 新增了「$title」— $amount';
  }

  @override
  String activityPaymentMarked(String sender) {
    return '$sender 將自己的份額標示為已付款';
  }

  @override
  String activityPaymentConfirmedTarget(String sender, String target) {
    return '$sender 確認了 $target 的付款';
  }

  @override
  String activityPaymentConfirmed(String sender) {
    return '$sender 確認了一筆付款';
  }

  @override
  String activityPaymentDisputedTarget(String sender, String target) {
    return '$sender 對 $target 的付款提出爭議';
  }

  @override
  String activityPaymentDisputed(String sender) {
    return '$sender 對一筆付款提出爭議';
  }

  @override
  String activityMemberAdded(String sender, String target) {
    return '$sender 將 $target 加入了群組';
  }

  @override
  String activityPoke(String article, String character) {
    return '$character 戳了一下群組！';
  }

  @override
  String activityPhotoSent(String sender) {
    return '$sender 傳送了一張照片';
  }

  @override
  String get activityEmpty => '還沒有任何動態';

  @override
  String get photoExpiresIn3Days => '這張照片將在 3 天後到期';

  @override
  String photoExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天',
      one: '1 天',
    );
    return '$_temp0後到期';
  }

  @override
  String photoExpiresInHours(int count) {
    return '$count 小時後到期';
  }

  @override
  String photoExpiresInMinutes(int count) {
    return '$count 分鐘後到期';
  }

  @override
  String get photoExpired => '照片已到期';

  @override
  String get linkOpenTitle => '要開啟連結嗎？';

  @override
  String linkOpenMessage(String url) {
    return '你即將離開 Salapify 並開啟：\n\n$url';
  }

  @override
  String get commonOpen => '開啟';

  @override
  String get linkOpenFailed => '無法開啟這個連結。';

  @override
  String get chatNotifyAll => '通知所有成員';

  @override
  String get chatAddPhoto => '新增照片';

  @override
  String get chatMessageHint => '傳訊息給群組...';

  @override
  String get chatPokeGroup => '戳一下群組';

  @override
  String get chatSendMessage => '傳送訊息';

  @override
  String get reportTitle => '檢舉使用者';

  @override
  String get reportReporting => '檢舉對象';

  @override
  String get reportWhatsGoingOn => '發生了什麼事？';

  @override
  String get reportBeSpecific => '請盡量具體，清楚說明發生的情況。';

  @override
  String get reportHint => '請描述發生的情況...';

  @override
  String get reportDescribeIssue => '請描述問題';

  @override
  String get reportSubmitted => '檢舉已送出';

  @override
  String get reportSubmit => '送出檢舉';

  @override
  String get billEdit => '編輯帳單';

  @override
  String get billDetailsTitle => '帳單詳情';

  @override
  String get billOnlyPayerEdit => '只有付款的人才能編輯這張帳單。';

  @override
  String get billLockedBanner => '總金額與分攤方式已鎖定 — 已有人在這張帳單上進行付款操作。';

  @override
  String get billSectionDetails => '帳單詳情';

  @override
  String get billTitleHint => '例如：晚餐 @ 火鍋店';

  @override
  String get billTitleLabel => '標題';

  @override
  String get billTitleRequired => '請輸入標題';

  @override
  String get billTotalAmountLabel => '總金額';

  @override
  String billAmountTooLarge(String amount) {
    return '金額不可超過 $amount';
  }

  @override
  String get billLockedNote => '已鎖定 — 已有付款操作';

  @override
  String get billSectionSplit => '分攤方式';

  @override
  String get billPaidByLabel => '付款人';

  @override
  String get billSplitEqually => '平均分攤';

  @override
  String get billSplitCustom => '自訂';

  @override
  String get billDelete => '刪除帳單';

  @override
  String get billDeleteTitle => '要刪除這張帳單嗎？';

  @override
  String get billDeleteMessage => '此操作無法復原。';

  @override
  String get billDeletedSnack => '帳單已刪除。你隨時可以再新增一張。';

  @override
  String get billFormerMember => '前成員';

  @override
  String get billPaymentStatus => '付款狀態';

  @override
  String billAwaitingReview(int count) {
    return '$count 筆待審核';
  }

  @override
  String get billStatusUnpaid => '未付款';

  @override
  String get billStatusSaysPaid => '表示已付款 — 請審核';

  @override
  String get billStatusConfirmed => '已確認';

  @override
  String get billDecline => '拒絕';

  @override
  String notificationsLoadFailed(String error) {
    return '無法載入通知：$error';
  }

  @override
  String get notificationsEmpty => '還沒有任何通知';

  @override
  String get notificationsEarlier => '較早';

  @override
  String notificationsUnread(int count) {
    return '$count 則未讀';
  }

  @override
  String get notificationsAllCaughtUp => '你已全部看完了';

  @override
  String get notificationsMarkAllRead => '全部標示為已讀';

  @override
  String get notificationDeletedUser => '已刪除的使用者';

  @override
  String notificationAddedToGroup(String name, String group) {
    return '$name 將你加入了「$group」';
  }

  @override
  String notificationBillAdded(String name, String title, String group) {
    return '$name 在 $group 新增了「$title」';
  }

  @override
  String notificationPaymentMarked(String name, String group) {
    return '$name 在 $group 將自己的份額標示為已付款';
  }

  @override
  String notificationPaymentConfirmed(String name, String group) {
    return '$name 在 $group 確認了你的付款';
  }

  @override
  String notificationPaymentDisputed(String name, String group) {
    return '$name 在 $group 對你的付款提出爭議';
  }

  @override
  String get timeJustNow => '剛剛';

  @override
  String timeMinutesAgo(int count) {
    return '$count 分鐘前';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count 小時前';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count 天前';
  }

  @override
  String get notificationGroupUnavailable => '這個群組已不存在。';

  @override
  String get gameTitle => 'Whack-a-Debt';

  @override
  String get gameTimeLabel => '時間';

  @override
  String get gameScoreLabel => '分數';

  @override
  String gameSecondsShort(int seconds) {
    return '$seconds 秒';
  }

  @override
  String gameHint(int penalty) {
    return '點選你的朋友，避開犀牛（-$penalty）！';
  }

  @override
  String get gameReady => '準備好了嗎？';

  @override
  String gameYouHaveSeconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds 秒',
      one: '1 秒',
    );
    return '你有 $_temp0的時間。';
  }

  @override
  String get gameWhackBeasts => '打小野獸';

  @override
  String get gameWhackBeastsDesc => '每打中一次 +1 分';

  @override
  String get gameAvoidRhino => '避開黑犀牛！';

  @override
  String gameAvoidRhinoDesc(int penalty) {
    String _temp0 = intl.Intl.pluralLogic(
      penalty,
      locale: localeName,
      other: '$penalty 分',
      one: '1 分',
    );
    return '-$_temp0。千萬別打牠！';
  }

  @override
  String get gameStart => '開始';

  @override
  String get gameTimesUp => '時間到！';

  @override
  String get gameCountingScore => '正在計算你的分數...';

  @override
  String get gameResultTitle => '你的成績';

  @override
  String get gameYourScore => '你的分數';

  @override
  String get gameMessageWarmingUp => '才剛熱身而已！';

  @override
  String get gameMessageNice => '打得不錯！';

  @override
  String get gameMessageGreat => '你超會打的！';

  @override
  String get gameMessageSuperstar => '打擊超級巨星！';

  @override
  String get gamePlayAgain => '再玩一次';

  @override
  String get helpTitle => '說明與常見問題';

  @override
  String get helpSearchHint => '搜尋主題...';

  @override
  String helpNoResults(String query) {
    return '找不到「$query」的相關結果';
  }

  @override
  String get faqSectionStarted => '開始使用';

  @override
  String get faqSectionBudgeting => '預算';

  @override
  String get faqSectionTransactions => '交易與收入';

  @override
  String get faqSectionSplit => '分帳';

  @override
  String get faqSectionPeriods => '週期與設定';

  @override
  String get faqSectionNotifications => '通知';

  @override
  String get faqStartedQ1 => 'Salapify 可以做什麼？';

  @override
  String get faqStartedA1 =>
      'Salapify 結合了預算追蹤與分帳功能。用「預算」分頁把資金分配到各個分類，用「交易」分頁記錄收入與支出，用「分帳」分頁和朋友或其他使用者結清共同費用，全部都在同一個地方。';

  @override
  String get faqBudgetQ1 => '如何建立預算分類？';

  @override
  String get faqBudgetA1 =>
      '點選「預算」分頁上的 + 按鈕，輸入分類名稱（例如網路費或餐費），再設定分配金額。選擇是固定還是變動，並設定重複的頻率。填完其他欄位後，儲存你的分類即可。';

  @override
  String get faqBudgetQ2 => '固定和變動有什麼不同？';

  @override
  String get faqBudgetA2 =>
      '固定適用於可預期的費用，例如網路費，你只需設定一個確切的金額。變動適用於會變化的支出，例如餐費，你設定的是目標上限，而不是確切金額。';

  @override
  String get faqBudgetQ3 => '把分類勾選為已完成會發生什麼事？';

  @override
  String get faqBudgetA3 =>
      '將分類標示為已完成時，系統會自動把它記錄為本期的一筆交易。該分類也會被標示為完成，並移到清單最下方。';

  @override
  String get faqBudgetQ4 => '為什麼「預算」分頁上有些分類看起來變淡了？';

  @override
  String get faqBudgetA4 => '使用每月兩期的預算時，變淡的分類屬於另一半月。等到它們的半月開始時，就會自動恢復正常顯示。';

  @override
  String get faqTxQ1 => '如何新增交易或收入？';

  @override
  String get faqTxA1 =>
      '在「交易」分頁點選 +，即可新增支出或收入。新增收入時，請選擇是單次還是重複。重複的收入會在每個新週期開始時自動新增。';

  @override
  String get faqTxQ2 => '交易會如何影響我的預算？';

  @override
  String get faqTxA2 =>
      '記錄交易時，你會把它歸到某個預算分類。金額會自動從該分類的分配額度中扣除，所以「預算」分頁隨時都會顯示你還剩多少可以花。';

  @override
  String get faqTxQ3 => '如何刪除收入或支出？';

  @override
  String get faqTxA3 => '前往「交易」分頁，向左滑動想刪除的收入或支出。如果出現確認提示，請確認刪除。';

  @override
  String get faqTxQ4 => '為什麼看不到上一個週期的交易？';

  @override
  String get faqTxA4 =>
      '「預算」和「交易」分頁只會顯示目前週期的總額，依據你在設定中選擇的預算週期而定。這樣數字會專注在你還能掌控的部分。';

  @override
  String get faqSplitQ1 => '如何和朋友分帳？';

  @override
  String get faqSplitA1 =>
      '建立一個群組，並用使用者名稱新增成員。在群組內建立帳單（例如「晚餐 @ 火鍋店」），輸入你支付的金額，然後選擇平均分攤，或為每位成員自訂分攤金額。';

  @override
  String get faqSplitQ2 => '如何刪除分帳群組？';

  @override
  String get faqSplitA2 => '如果群組是你建立的，向左滑動該群組即可刪除。刪除群組時，所有共享的帳單動態也會一併移除。';

  @override
  String get faqSplitQ3 => '如何退出分帳群組？';

  @override
  String get faqSplitA3 => '如果你是群組成員，向左滑動該群組並選擇「退出」。這樣你會離開群組，但不會影響其他成員，群組仍會保留。';

  @override
  String get faqSplitQ4 => '可以在群組裡分享收據或聊天嗎？';

  @override
  String get faqSplitA4 =>
      '可以。每個群組都有「動態」區，你可以傳訊息給成員，並分享照片（例如收據），帳單紀錄也會一併顯示在那裡。';

  @override
  String get faqSplitQ5 => '分帳會影響我的個人預算嗎？';

  @override
  String get faqSplitA5 =>
      '不會。分帳與你的「預算」和「交易」分頁是分開的。如果想把已結清的帳單計入你的支出，請手動記錄成一筆交易。';

  @override
  String get faqSplitQ6 => '如何檢舉或封鎖群組裡的人？';

  @override
  String get faqSplitA6 =>
      '在群組的「動態」分頁中，長按成員訊息旁的大頭貼，即可開啟選單，裡面有「檢舉」和「封鎖」選項。封鎖後會隱藏對方的訊息和動態，你隨時可以在設定中解除。';

  @override
  String get faqPeriodQ1 => '每月和每月兩期有什麼不同？';

  @override
  String get faqPeriodA1 =>
      '每月會在每個月 1 日重設你的預算。每月兩期則把一個月分成上下兩半：你可以選擇上半月在哪一天結束，其餘日子就是下半月。';

  @override
  String get faqPeriodQ2 => '如果我變更週期，分類會怎麼樣？';

  @override
  String get faqPeriodA2 =>
      '現有的分類會轉換為符合新週期，並保留原本的金額。原本設定在特定半月的分類，之後會改為計入整個月（反之亦然），建議事後檢查是否有重複的項目。';

  @override
  String get faqPeriodQ3 => '重複功能在每月兩期的預算中如何運作？';

  @override
  String get faqPeriodA3 => '重複的分類會在你指派的每個半月中重複出現。如果改成每月，同一個項目就會改為每個月重複一次。';

  @override
  String get faqNotifQ1 => '「通知」分頁會顯示什麼？';

  @override
  String get faqNotifA1 => '你會看到分帳動態的更新，以及付款人對你的份額提出爭議或確認時的通知。';

  @override
  String get faqNotifQ2 => '可以關閉通知嗎？';

  @override
  String get faqNotifA2 =>
      '可以。前往裝置的「設定」>「應用程式」> Salapify >「通知」，你可以完全關閉通知，或選擇想接收的通知類型。';

  @override
  String get languageChangeLaterHint => '你隨時可以在「設定」中變更。';
}
