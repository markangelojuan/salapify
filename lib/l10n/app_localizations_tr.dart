// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get languageSystemDefault => 'Sistem varsayılanı';

  @override
  String get languageChoose => 'Dil Seç';

  @override
  String get settingsBudgetingPeriod => 'Bütçe Dönemi';

  @override
  String get budgetingPeriodMonthly => 'Aylık';

  @override
  String get budgetingPeriodMonthlyDesc => 'Bütçeni ayda bir takip et';

  @override
  String get budgetingPeriodBiMonthly => 'Ayda İki Dönem';

  @override
  String get budgetingPeriodBiMonthlyDesc => 'Ayı iki yarıya böl';

  @override
  String get settingsFirstHalfEndsOn => 'İlk yarı şu gün biter';

  @override
  String get settingsCurrency => 'Para Birimi';

  @override
  String get settingsReminders => 'Hatırlatıcılar';

  @override
  String get settingsAppReminders => 'Uygulama hatırlatıcıları';

  @override
  String get settingsAppRemindersDesc =>
      'Bütçeni güncellemen için ara sıra hatırlatır';

  @override
  String get settingsPrivacy => 'Gizlilik';

  @override
  String get settingsBlockedUsers => 'Engellenen kullanıcılar';

  @override
  String get changePeriodTitle => 'Bütçe Dönemini Değiştir';

  @override
  String get changePeriodMessage =>
      'Mevcut kategoriler yeni döneme uyacak şekilde dönüştürülecek (tutarlar aynı kalır). Belirli bir yarı için ayarlanmış kategoriler artık tüm ayı kapsayacak, ya da tam tersi; sonrasında yinelenenleri gözden geçirip birleştirmek isteyebilirsin. Devam edilsin mi?';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonContinue => 'Devam';

  @override
  String settingsLoadFailed(String error) {
    return 'Ayarlar yüklenemedi: $error';
  }

  @override
  String get currencyTapToChange => 'Değiştirmek için dokun';

  @override
  String get currencyChoose => 'Para Birimi Seç';

  @override
  String get reminderMonthStartTitle => 'Yeni ay, taze bütçe 📊';

  @override
  String get reminderMonthStartBody =>
      'Bütçeni güncelle ve bekleyen işlemleri kaydet.';

  @override
  String get reminderMidMonthTitle => 'Ay ortası kontrolü 💸';

  @override
  String get reminderMidMonthBody => 'Son harcamalarını kaydetmeyi unutma.';

  @override
  String get settingsSyncFailedPeriod =>
      'Bütçe dönemi bu cihaza kaydedildi ancak hesabınla eşitlenemedi.';

  @override
  String get settingsSyncFailedGeneric =>
      'Ayar bu cihaza kaydedildi ancak hesabınla eşitlenemedi.';

  @override
  String get settingsSyncFailedCurrency =>
      'Para birimi bu cihaza kaydedildi ancak hesabınla eşitlenemedi.';

  @override
  String get settingsNotificationsDisabled =>
      'Salapify için bildirimler kapalı. Hatırlatıcı almak için telefon ayarlarından aç.';

  @override
  String get settingsConvertingCategories => 'Kategorilerin dönüştürülüyor…';

  @override
  String get errorUserNotFound => 'Hmm… Bu hesabı bulamadık.';

  @override
  String get errorInvalidCredential => 'Giriş bilgileri doğru görünmüyor.';

  @override
  String get errorEmailInUse => 'Bu e-posta zaten kulübümüzde.';

  @override
  String get errorNetwork => 'Lütfen bağlantını kontrol edip tekrar dene.';

  @override
  String get errorTooManyRequests =>
      'Çok fazla deneme yaptın. Biraz bekleyip tekrar dene.';

  @override
  String get errorUserDisabled => 'Bu hesap şu an tatilde.';

  @override
  String get errorWeakPassword =>
      'Bu şifre tahmin etmesi çok kolay. Daha uzun bir şifre dene.';

  @override
  String get errorRequiresRecentLogin =>
      'Güvenliğin için lütfen çıkış yapıp tekrar giriş yap, sonra yeniden dene.';

  @override
  String get errorOffline =>
      'Çevrimdışısın. Bağlantını kontrol edip tekrar dene.';

  @override
  String get errorGeneric => 'Ufak bir aksilik! Tekrar dener misin?';

  @override
  String get errorUsernameTaken => 'Bu kullanıcı adı zaten alınmış';

  @override
  String get errorEmailRegistered => 'Bu e-posta zaten kayıtlı';

  @override
  String get errorWrongPassword => 'Bu şifre doğru görünmüyor';

  @override
  String get errorReauthCancelled => 'Onay iptal edildi';

  @override
  String get errorAccountDisabled => 'Bu hesap devre dışı bırakıldı';

  @override
  String get authSignInSubtitle =>
      'Hesabına erişmek için giriş bilgilerini gir';

  @override
  String get authEmailLabel => 'E-posta Adresi';

  @override
  String get authEmailHint => 'E-postanı gir';

  @override
  String get authEmailRequired => 'E-posta gerekli';

  @override
  String get authEmailInvalid => 'Geçerli bir e-posta gir';

  @override
  String get authPasswordLabel => 'Şifre';

  @override
  String get authPasswordHint => 'Şifreni gir';

  @override
  String get authPasswordRequired => 'Şifre gerekli';

  @override
  String get authPasswordInvalid => 'Geçersiz şifre';

  @override
  String get authForgotPassword => 'Şifreni mi unuttun?';

  @override
  String get authSignIn => 'Giriş Yap';

  @override
  String get authSignUp => 'Kayıt Ol';

  @override
  String get authOrContinueWith => 'Veya şununla devam et';

  @override
  String get authContinueWithGoogle => 'Google ile devam et';

  @override
  String get authNotMemberYet => 'Henüz kulübümüze katılmadın mı?';

  @override
  String get authContinueAsGuest => 'Misafir olarak devam et';

  @override
  String get authResetPasswordTitle => 'Şifreni sıfırla';

  @override
  String get authResetPasswordPrompt =>
      'E-posta adresini gir, sana şifreni sıfırlaman için bir bağlantı gönderelim.';

  @override
  String get authResetLinkSent =>
      'Bu e-posta ile kayıtlı bir hesap varsa sıfırlama bağlantısı yolda. Gelen kutunu (ve spam klasörünü) kontrol et.';

  @override
  String get authSendLink => 'Bağlantı gönder';

  @override
  String get commonDone => 'Bitti';

  @override
  String get authSignUpSubtitle => 'Başlamak için bir hesap oluştur';

  @override
  String get authUsernameLabel => 'Kullanıcı Adı';

  @override
  String get authUsernameHint => 'Tercih ettiğin kullanıcı adını gir';

  @override
  String get authUsernameRequired => 'Kullanıcı adı gerekli';

  @override
  String get authUsernameNoSpaces => 'Başta veya sonda boşluk olamaz';

  @override
  String get authUsernameStartLetter => 'Harfle başlamalı';

  @override
  String get authUsernameAllowedChars =>
      'Yalnızca harf, rakam ve alt çizgi kullanılabilir';

  @override
  String get authUsernameMinLetters => 'En az 3 harf';

  @override
  String get authUsernameMaxNumbers => 'En fazla 3 rakam';

  @override
  String get authPasswordPinLabel => 'Şifre / PIN';

  @override
  String get authPasswordPinHint => 'Şifreni / PIN’ini gir';

  @override
  String get authPasswordMinLength => 'En az 6 karakter';

  @override
  String get authConfirmPasswordLabel => 'Şifreyi / PIN’i Onayla';

  @override
  String get authConfirmPasswordHint => 'Şifreni / PIN’ini tekrar gir';

  @override
  String get authConfirmPasswordRequired => 'Lütfen şifreni onayla';

  @override
  String get authPasswordsMismatch => 'Şifreler eşleşmiyor';

  @override
  String get authAgreeTerms =>
      'Hizmet Şartları’nı ve Gizlilik Politikası’nı kabul ediyorum';

  @override
  String get termsDialogTitle => 'Şartlar ve Gizlilik';

  @override
  String get termsServiceHeading => 'Hizmet Şartları';

  @override
  String get termsServiceBody =>
      'Salapify’ı kullanarak uygulamayı sorumlu bir şekilde kullanmayı ve doğru bilgi vermeyi kabul edersin. Hesabından ve girdiğin bilgilerden sen sorumlusun.';

  @override
  String get termsPrivacyHeading => 'Gizlilik Politikası';

  @override
  String get termsPrivacyBody =>
      'Salapify; hesabını, bütçelemeyi, gider takibini, grupları ve hesap bölme özelliklerini sunmak için gereken bilgileri toplar. Banka hesaplarına veya finansal hesaplarına bağlanmayız ve kişisel bilgilerini satmayız.';

  @override
  String get termsSharedHeading => 'Paylaşılan Bilgiler';

  @override
  String get termsSharedBody =>
      'Gruplara katıldığında veya hesap böldüğünde kullanıcı adın, hesapların ve payların gibi ilgili bilgiler o grupların diğer üyelerine görünebilir.';

  @override
  String get termsImportantHeading => 'Önemli';

  @override
  String get termsImportantBody =>
      'Salapify bir bütçeleme ve düzenleme aracıdır; banka, ödeme hizmeti veya finansal danışman değildir.';

  @override
  String get commonClose => 'Kapat';

  @override
  String get verifyEmailTitle => 'E-postanı doğrula';

  @override
  String get verifyEmailSentGeneric =>
      'Sana bir doğrulama bağlantısı gönderdik.';

  @override
  String verifyEmailSentTo(String email) {
    return 'Doğrulama bağlantısını şu adrese gönderdik: $email';
  }

  @override
  String get verifyEmailInstructions =>
      'O e-postadaki bağlantıya tıkla, sonra aşağıdaki düğmeye dokun.';

  @override
  String get verifyEmailIVerified => 'Doğruladım';

  @override
  String get verifyEmailResend => 'E-postayı tekrar gönder';

  @override
  String verifyEmailResendIn(int seconds) {
    return '$seconds sn sonra tekrar gönder';
  }

  @override
  String get verifyEmailResent => 'Doğrulama e-postası gönderildi.';

  @override
  String get verifyEmailNotYet =>
      'Henüz doğrulanmadı — gelen kutunu (ve spam’i) kontrol et.';

  @override
  String get commonSignOut => 'Çıkış yap';

  @override
  String get avatarPickerTitle => 'Hangi küçük para canavarısın?';

  @override
  String get avatarPickerSubtitle => 'İstediğin zaman değiştirebilirsin';

  @override
  String get commonConfirm => 'Onayla';

  @override
  String get avatarLuxuriousDog => 'Lüks Köpek';

  @override
  String get avatarSavvyMonkey => 'Açıkgöz Maymun';

  @override
  String get avatarGreedyCat => 'Açgözlü Kedi';

  @override
  String get avatarThriftyPig => 'Tutumlu Domuz';

  @override
  String get avatarStingyTurtle => 'Cimri Kaplumbağa';

  @override
  String get avatarCovetousSnake => 'Hırslı Yılan';

  @override
  String get avatarProsperousPanda => 'Varlıklı Panda';

  @override
  String get avatarFrugalShark => 'Tasarruflu Köpekbalığı';

  @override
  String get avatarOpulentWalrus => 'Debdebeli Mors';

  @override
  String get avatarBrokeEagle => 'Meteliksiz Kartal';

  @override
  String get accountAvatarNotSelected => 'Seçilmedi';

  @override
  String get prefsBudgetTitle => 'Nasıl bütçe yaparsın?';

  @override
  String get prefsBudgetDescription =>
      'Bütçe dönemin, kategori bütçelerinin ne zaman sıfırlanacağını belirler.';

  @override
  String get prefsMonthlyDesc => 'Tüm ay için tek bir bütçe';

  @override
  String get prefsTwiceMonthly => 'Ayda iki kez';

  @override
  String get prefsTwiceMonthlyDesc =>
      'İki yarıya bölünür, ayda iki kez maaş alanlar için ideal';

  @override
  String prefsFirstHalfRange(int day) {
    return 'İlk yarı ayın 1’i ile $day. günü arasındadır.';
  }

  @override
  String get prefsCurrencyTitle => 'Para birimini seç';

  @override
  String get prefsCurrencyDescription =>
      'Bu sembol bütçelerinde ve işlemlerinde görünür.';

  @override
  String get prefsGetStarted => 'Başla';

  @override
  String get prefsUseDefaults => 'Varsayılanları kullan';

  @override
  String get prefsChangeLater =>
      'Bunları istediğin zaman Ayarlar’dan değiştirebilirsin';

  @override
  String get commonNext => 'İleri';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonChange => 'Değiştir';

  @override
  String get accountUserFallback => 'Kullanıcı';

  @override
  String get accountProfileInfo => 'Profil bilgileri';

  @override
  String get accountEmail => 'E-posta';

  @override
  String get accountSignInMethod => 'Giriş yöntemi';

  @override
  String get accountAvatar => 'Avatar';

  @override
  String get accountMembership => 'Üyelik';

  @override
  String get accountDangerZone => 'Tehlikeli bölge';

  @override
  String get accountDeleteAccount => 'Hesabı sil';

  @override
  String get accountDeleteAccountDesc =>
      'Hesabını ve tüm verilerini kalıcı olarak kaldır';

  @override
  String get accountPremium => 'Premium';

  @override
  String get accountSeeWhatsInside => 'İçinde neler var gör';

  @override
  String get accountPremiumDesc =>
      'Bu hesapta daha yüksek limitlerin kilidi açıldı';

  @override
  String get accountFreeDesc => 'Kategori, grup ve hesap limitlerini kaldır';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonRequired => 'Zorunlu';

  @override
  String get accountDeleteConfirmPhrase =>
      'Azar azar biriktir, birikimin uçsun';

  @override
  String get accountDeleteWarning =>
      'Bu işlem kalıcıdır ve geri alınamaz. Tüm verilerin, işlemlerin ve ayarların kalıcı olarak silinecek.';

  @override
  String accountDeleteTypePhrase(String phrase) {
    return 'Onaylamak için “$phrase” yaz';
  }

  @override
  String get accountDeleteReauthGoogle =>
      'Güvenliğin için hesabını silmeden önce lütfen kimliğini Google ile doğrula.';

  @override
  String get accountDeleteReauthPassword =>
      'Güvenliğin için onaylamak üzere lütfen şifreni gir.';

  @override
  String get accountVerifyWithGoogle => 'Google ile doğrula';

  @override
  String get accountDeletePermanently => 'Kalıcı olarak sil';

  @override
  String get accountIncorrectPasswordRetry =>
      'Şifre yanlış. Lütfen tekrar dene.';

  @override
  String get accountChangeUsername => 'Kullanıcı adını değiştir';

  @override
  String get accountUsernameUpdated => 'Kullanıcı adı güncellendi';

  @override
  String get accountChangePassword => 'Şifreyi değiştir';

  @override
  String get accountCurrentPassword => 'Mevcut şifre / PIN';

  @override
  String get accountNewPassword => 'Yeni şifre / PIN';

  @override
  String get accountConfirmNewPassword => 'Yeni şifreyi / PIN’i onayla';

  @override
  String get accountIncorrectPassword => 'Şifre yanlış';

  @override
  String get accountPasswordUpdated => 'Şifre güncellendi';

  @override
  String get accountUpdatePassword => 'Şifreyi güncelle';

  @override
  String get premiumHeaderBadge => 'Premium ol';

  @override
  String get premiumHeaderActiveBadge => 'Premium üyesin';

  @override
  String get premiumHeadline => 'Ücretsiz plandaki tüm limitleri kaldır';

  @override
  String get premiumHeadlineActive => 'Bu hesaptaki tüm limitler kaldırıldı.';

  @override
  String get premiumSub => 'Tek seferlik ödeme. Abonelik yok, asla.';

  @override
  String get premiumSubActive =>
      'Salapify’ı ayakta tutmamıza yardım ettiğin için teşekkürler.';

  @override
  String get premiumWhatYouGet => 'Neler kazanırsın';

  @override
  String premiumFeatureCategories(int count) {
    return '$count aktif bütçe kategorisi';
  }

  @override
  String premiumFeatureCategoriesFree(int count) {
    return 'Ücretsiz plan: en fazla $count aktif';
  }

  @override
  String premiumFeatureGroups(int count) {
    return '$count aktif grup';
  }

  @override
  String premiumFeatureGroupsFree(int count) {
    return 'Ücretsiz plan: en fazla $count aktif';
  }

  @override
  String premiumFeatureBills(int count) {
    return 'Grup başına $count aktif hesap';
  }

  @override
  String premiumFeatureBillsFree(int count) {
    return 'Ücretsiz plan: grup başına en fazla $count';
  }

  @override
  String get premiumFeatureAvatars => 'Daha fazla canavarın kilidi açıldı';

  @override
  String get premiumFeatureAvatarsDesc =>
      'Profilini kişiselleştirmek için ekstra avatarlar';

  @override
  String get premiumPricing => 'Fiyat';

  @override
  String get premiumBestValue => 'EN İYİ DEĞER — BİR KEZ ÖDE';

  @override
  String get premiumOneTimeFee => 'tek seferlik ücret';

  @override
  String get premiumRestorePurchase => 'Satın alımı geri yükle';

  @override
  String get premiumSecurePayment =>
      'App Store üzerinden güvenli tek seferlik ödeme';

  @override
  String get premiumActiveOnAccount => 'Premium bu hesapta aktif';

  @override
  String get premiumGo => 'Premium’a Geç';

  @override
  String premiumBuyWithPrice(String price) {
    return 'Satın al — $price';
  }

  @override
  String get premiumRestored => 'Satın alım geri yüklendi — keyfini çıkar!';

  @override
  String get premiumUnlocked => 'Artık premiumsun — keyfini çıkar!';

  @override
  String get premiumErrorOtherAccount =>
      'Bu satın alım farklı bir hesaba bağlı. Geri yüklemek için o hesapla giriş yap.';

  @override
  String get premiumNothingToRestore =>
      'Geri yüklenecek önceki bir satın alım bulunamadı.';

  @override
  String get premiumSignInFirst =>
      'Premium’un kilidini açmak için lütfen önce giriş yap.';

  @override
  String get premiumBillingUnavailable =>
      'Ödeme şu anda kullanılamıyor. Lütfen daha sonra tekrar dene.';

  @override
  String get premiumPurchaseFailed =>
      'Satın alım tamamlanamadı. Lütfen tekrar dene.';

  @override
  String get premiumLimitCategories =>
      'Bütçen büyüyor! Ücretsiz kategorilerin hepsini doldurdun.';

  @override
  String get premiumLimitGroups =>
      'Ücretsiz grubun dolu. Aynı anda yalnızca bir aktif grup olabilir.';

  @override
  String get premiumLimitBills =>
      'Hesapların çoğalıyor! Ücretsiz yerlerin hepsi doldu.';

  @override
  String get premiumUpsellBenefit => 'Tek seferlik Premium kilidi açma';

  @override
  String get premiumUpsellSupport =>
      'Tek seferlik bir satın alımla uygulamayı destekle.';

  @override
  String get blockedUsersTitle => 'Engellenen Kullanıcılar';

  @override
  String get blockedUsersEmpty => 'Engellenen kullanıcı yok';

  @override
  String unblockTitle(String username) {
    return '$username engeli kaldırılsın mı?';
  }

  @override
  String get unblockMessage => 'Seninle tekrar etkileşime geçebilecek.';

  @override
  String get unblockAction => 'Engeli kaldır';

  @override
  String unblockedSnack(String username) {
    return 'Engel kaldırıldı: $username';
  }

  @override
  String commonLoadFailed(String error) {
    return 'Yüklenemedi: $error';
  }

  @override
  String get commonDelete => 'Sil';

  @override
  String confirmDeleteMessage(String itemName) {
    return '“$itemName” öğesini silmek istediğine emin misin? Bu işlem geri alınamaz.';
  }

  @override
  String get navBudget => 'Bütçe';

  @override
  String get navTransactions => 'İşlemler';

  @override
  String get navSplitBill => 'Hesabı Böl';

  @override
  String get navNotifications => 'Bildirimler';

  @override
  String get tourMenuTitle => 'Daha Fazla Seçenek';

  @override
  String get tourMenuDesc =>
      'Hesabını, bütçe dönemini ve diğer\nayarları yönet, yardım al.';

  @override
  String get tourFabTitle => 'Hızlı Ekle';

  @override
  String get tourFabDesc =>
      'Hızlıca kategori, işlem veya\nhesap bölme grubu eklemek için + simgesine dokun.';

  @override
  String get tourBudgetTitle => 'Bütçeni Planla';

  @override
  String get tourBudgetDesc =>
      'Her kategori için harcama limiti belirle\nve ne kadar kaldığını gör.';

  @override
  String get tourTransactionsTitle => 'Giderlerini Takip Et';

  @override
  String get tourTransactionsDesc =>
      'Gelir ve giderlerini takip et.\nİşlem eklemek için + simgesini kullan.';

  @override
  String get tourSplitTitle => 'Hesabı Kolayca Böl';

  @override
  String get tourSplitDesc =>
      'Bir grup oluştur, hesap ekle\nve herkesle sohbet et.';

  @override
  String get tourSplitDescGuest =>
      'Masrafları arkadaşlarınla paylaş.\nBu özelliğin kilidini açmak için giriş yap.';

  @override
  String limitReachedCategories(int count) {
    return '$count aktif kategori sınırına ulaştın. Yeni eklemek için birini sil.';
  }

  @override
  String limitReachedGroups(int count) {
    return '$count grup sınırına ulaştın. Yeni grup oluşturmak için birini sil.';
  }

  @override
  String get drawerGuest => 'Misafir';

  @override
  String get drawerGuestSubtitle => 'Verilerini kaydetmek için giriş yap';

  @override
  String get drawerAccount => 'Hesap';

  @override
  String get drawerDarkMode => 'Karanlık Mod';

  @override
  String get drawerHelp => 'Yardım / SSS';

  @override
  String get drawerLogout => 'Çıkış';

  @override
  String get budgetAllocations => 'AYRILAN BÜTÇE';

  @override
  String get budgetNoCategories => 'Henüz kategori yok';

  @override
  String get budgetFilter => 'Filtre';

  @override
  String budgetFiltersCount(int count) {
    return 'Filtreler ($count)';
  }

  @override
  String get budgetClearFiltersToReorder =>
      'Kategorileri yeniden sıralamak için filtreleri temizle';

  @override
  String get budgetNoMatch => 'Filtrelerinle eşleşen kategori yok';

  @override
  String get budgetClearFilters => 'Filtreleri temizle';

  @override
  String budgetLoadFailed(String error) {
    return 'Kategoriler yüklenemedi: $error';
  }

  @override
  String budgetAutoCompleted(String name) {
    return '$name otomatik tamamlandı — harcama bütçeye ulaştı.';
  }

  @override
  String get budgetFilterTitle => 'Kategorileri Filtrele';

  @override
  String get commonClearAll => 'Tümünü temizle';

  @override
  String get budgetFilterStatus => 'Durum';

  @override
  String get budgetFilterAll => 'Tümü';

  @override
  String get budgetFilterPending => 'Bekleyen';

  @override
  String get budgetFilterCompleted => 'Tamamlanan';

  @override
  String get budgetFilterType => 'Tür';

  @override
  String get budgetTypeFixed => 'Sabit';

  @override
  String get budgetTypeVariable => 'Değişken';

  @override
  String get budgetFilterRecurrence => 'Tekrar';

  @override
  String get commonApply => 'Uygula';

  @override
  String commonApplyCount(int count) {
    return 'Uygula ($count)';
  }

  @override
  String get budgetFreqOnce => 'Tek seferlik';

  @override
  String get budgetFreqRecurring => 'Tekrarlayan';

  @override
  String get budgetFreqFirstHalf => 'İlk Yarı';

  @override
  String get budgetFreqSecondHalf => 'İkinci Yarı';

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

    return 'İlk Yarı · $monthString $start–$end';
  }

  @override
  String budgetPeriodSecondHalf(DateTime month, int start, int end) {
    final intl.DateFormat monthDateFormat = intl.DateFormat.MMM(localeName);
    final String monthString = monthDateFormat.format(month);

    return 'İkinci Yarı · $monthString $start–$end';
  }

  @override
  String get budgetUsed => 'kullanıldı';

  @override
  String get budgetOverBudget => 'Bütçe aşıldı';

  @override
  String get budgetRemaining => 'Kalan';

  @override
  String get budgetSpent => 'Harcanan';

  @override
  String get budgetAllocated => 'Ayrılan';

  @override
  String get categoryCardFirstHalf => 'İlk yarı';

  @override
  String get categoryCardSecondHalf => 'İkinci yarı';

  @override
  String get categoryCardBiMonthly => 'Ayda iki dönem';

  @override
  String get categoryMarkIncompleteTitle =>
      'Tamamlanmadı olarak işaretlensin mi?';

  @override
  String get categoryMarkIncompleteMessage =>
      'Otomatik oluşturulan giderler silinecek. Elle eklenen giderler kalacak ve bu kategoriyi yeniden tamamlandı olarak işaretleyebilir.';

  @override
  String get categoryMarkIncompleteAction => 'Tamamlanmadı Olarak İşaretle';

  @override
  String get categoryAdd => 'Kategori Ekle';

  @override
  String get categoryEdit => 'Kategoriyi Düzenle';

  @override
  String get categoryDelete => 'Kategoriyi Sil';

  @override
  String get categoryNameLabel => 'Kategori Adı';

  @override
  String get categoryNameHint => 'ör. Market, İnternet Faturası';

  @override
  String get categoryNameRequired => 'Ad gerekli';

  @override
  String amountLabelWithSymbol(String symbol) {
    return 'Tutar ($symbol)';
  }

  @override
  String get amountRequired => 'Tutar gerekli';

  @override
  String get amountInvalid => 'Geçerli bir tutar gir';

  @override
  String get amountTooLarge => 'Tutar çok büyük';

  @override
  String get categoryTypeLabel => 'Tür';

  @override
  String get categoryFixedTooltip => 'Sabit: Her seferinde aynı tutar.';

  @override
  String get categoryVariableTooltip =>
      'Değişken: Tutar her seferinde değişebilir.';

  @override
  String get categoryRepeat => 'Tekrar';

  @override
  String get categoryEveryMonth => 'Her ay';

  @override
  String get categoryOnce => 'Bir kez';

  @override
  String get categoryEveryPeriod => 'Her dönem';

  @override
  String get categoryBothHalves => 'Her iki yarı';

  @override
  String get categoryFirstHalf => 'İlk yarı';

  @override
  String get categorySecondHalf => 'İkinci yarı';

  @override
  String get categoryIcon => 'Simge';

  @override
  String get commonSaveChanges => 'Değişiklikleri Kaydet';

  @override
  String get transactionTabExpenses => 'Giderler';

  @override
  String get transactionTabIncome => 'Gelir';

  @override
  String get dateToday => 'Bugün';

  @override
  String get dateYesterday => 'Dün';

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
  String get expensesEmpty => 'Henüz gider yok';

  @override
  String expensesLoadFailed(String error) {
    return 'Giderler yüklenemedi: $error';
  }

  @override
  String get expensesDeleteTitle => 'Bu gider silinsin mi?';

  @override
  String get expensesDeleteMessage =>
      'Artık harcama toplamlarına sayılmayacak.';

  @override
  String get transactionDeletedCategory => 'Silinmiş kategori';

  @override
  String get transactionAutoNote => 'Kalan bütçe (otomatik)';

  @override
  String get incomeEmpty => 'Henüz gelir kaydı yok';

  @override
  String incomeLoadFailed(String error) {
    return 'Gelir yüklenemedi: $error';
  }

  @override
  String get incomeDeleteTitle => 'Bu gelir kaydı silinsin mi?';

  @override
  String get incomeDeleteMessage => 'Artık toplam paraya sayılmayacak.';

  @override
  String incomeEveryMonthOnDay(int day) {
    return 'Her ayın $day. günü';
  }

  @override
  String incomeEveryMonthOnDayClamped(int day, int effective) {
    return 'Her ayın $day. günü (bu ay $effective. gün)';
  }

  @override
  String get cashFlowInfo =>
      'Bu ay beklenen gelirin ve birikimin. Geçmiş tutulmaz.';

  @override
  String get cashFlowSavings => 'Birikim';

  @override
  String get expenseAdd => 'Gider Ekle';

  @override
  String get expenseEdit => 'Gideri Düzenle';

  @override
  String get amountLabel => 'Tutar';

  @override
  String get expenseCategory => 'Kategori';

  @override
  String get expenseSelectCategory => 'Lütfen bir kategori seç';

  @override
  String get expenseNoCategories =>
      'Henüz kategori yok — Bütçe sekmesinden bir tane ekle.';

  @override
  String get expenseDate => 'Tarih';

  @override
  String get expenseNoteLabel => 'Not (isteğe bağlı)';

  @override
  String get expenseNoteHint => 'ör. Arkadaşla kahve';

  @override
  String get incomeAdd => 'Gelir Ekle';

  @override
  String get incomeEdit => 'Geliri Düzenle';

  @override
  String get incomeSourceLabel => 'Kaynak';

  @override
  String get incomeSourceHint => 'ör. Maaş, Freelance, Hediye';

  @override
  String get incomeSourceRequired => 'Kaynak gerekli';

  @override
  String get incomeSourceTooLong => '50 karakterin altında tut';

  @override
  String get incomeDepositDay => 'Yatış günü';

  @override
  String get incomeCountedEveryPeriod =>
      'Tam gün ne olursa olsun her dönem için gelir sayılır.';

  @override
  String incomeAddedTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMM(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Şuraya eklenecek: $dateString';
  }

  @override
  String get splitGroupNew => 'Yeni Grup';

  @override
  String get splitGroupEdit => 'Grubu Düzenle';

  @override
  String get splitGroupCreate => 'Grup Oluştur';

  @override
  String get splitGroupNameLabel => 'Grup adı';

  @override
  String get splitGroupNameHint => 'ör. Ev arkadaşları, Bodrum Tatili';

  @override
  String get splitGroupNameRequired => 'Bir grup adı gir';

  @override
  String get splitAddMembers => 'Üye ekle';

  @override
  String splitGroupFull(int count) {
    return 'Grup dolu ($count/$count üye)';
  }

  @override
  String get splitNoUserFound => 'Kullanıcı bulunamadı';

  @override
  String get splitSearchByUsername => 'Kullanıcı adıyla ara';

  @override
  String get splitUnknownUser => 'Bilinmiyor';

  @override
  String errorBillLimit(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit hesap',
      one: '1 hesap',
    );
    return 'Bu grup $_temp0 sınırına ulaştı';
  }

  @override
  String errorGroupLimit(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit aktif grup',
      one: '1 aktif grup',
    );
    return 'Ücretsiz planda yalnızca $_temp0 olabilir';
  }

  @override
  String errorMaxMembers(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit üye',
      one: '1 üye',
    );
    return 'Gruplarda en fazla $_temp0 olabilir';
  }

  @override
  String get splitDeleteGroupTitle => 'Bu grup silinsin mi?';

  @override
  String get splitLeaveGroupTitle => 'Bu gruptan ayrılınsın mı?';

  @override
  String splitDeleteGroupMessage(String name) {
    return 'Bu işlem “$name” grubunu ve hesaplarını herkes için siler.';
  }

  @override
  String splitLeaveGroupMessage(String name) {
    return '“$name” grubunu ve hesaplarını artık görmeyeceksin.';
  }

  @override
  String get splitLeave => 'Ayrıl';

  @override
  String splitGroupsLoadFailed(String error) {
    return 'Gruplar yüklenemedi: $error';
  }

  @override
  String get splitNoGroups => 'Henüz grup yok';

  @override
  String splitMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count üye',
      one: '1 üye',
    );
    return '$_temp0';
  }

  @override
  String get splitSettled => 'Hesaplaşıldı';

  @override
  String splitOwed(String amount) {
    return 'Alacak $amount';
  }

  @override
  String splitYouOwe(String amount) {
    return 'Borcun $amount';
  }

  @override
  String get guestSplitTagline => 'Katkı yap. Hesaplaş. Dost kal.';

  @override
  String get guestSplitDescription =>
      'Gruplar oluştur, hesapları böl ve kimin kime borcu olduğunu gör. Her şeyi arkadaşlarınla eşitlemek için giriş yap.';

  @override
  String get guestSplitCta => 'Başlamak için giriş yap';

  @override
  String splitBlockUser(String username) {
    return 'Engelle: $username';
  }

  @override
  String splitReportUser(String username) {
    return 'Şikayet et: $username';
  }

  @override
  String splitBlockTitle(String username) {
    return '$username engellensin mi?';
  }

  @override
  String splitBlockMessage(String username) {
    return 'Paylaşılan gruplarda, hesap güncellemeleri dahil, $username kullanıcısının mesajlarını veya etkinliğini görmeyeceksin. Engeli istediğin zaman Ayarlar’dan kaldırabilirsin.';
  }

  @override
  String get splitBlockAction => 'Engelle';

  @override
  String splitBlockedSnack(String username) {
    return 'Engellendi: $username';
  }

  @override
  String splitGameScoreMessage(int score) {
    return '🎮 Whack-a-Debt’te $score puan yaptım!';
  }

  @override
  String splitGroupLoadFailed(String error) {
    return 'Grup yüklenemedi: $error';
  }

  @override
  String get splitGroupNotFound => 'Grup bulunamadı';

  @override
  String splitBillsLoadFailed(String error) {
    return 'Hesaplar yüklenemedi: $error';
  }

  @override
  String get balanceAllSettled => 'Tüm hesaplar kapandı';

  @override
  String get balanceOwedToYou => 'Sana borçlu olunan';

  @override
  String get balanceYouOwe => 'Borcun';

  @override
  String get billAdd => 'Hesap Ekle';

  @override
  String billLimitReachedPremium(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hesap',
      one: '1 hesap',
    );
    return 'Bu grup $_temp0 sınırına ulaştı. Yeni eklemek için bir hesabı sil.';
  }

  @override
  String billTotal(String amount) {
    return 'Toplam $amount';
  }

  @override
  String get billPaidByYou => 'Sen ödedin';

  @override
  String billPaidByName(String name) {
    return 'Ödeyen: $name';
  }

  @override
  String get billAllConfirmed => 'Hepsi onaylandı';

  @override
  String billDisputedReview(int count) {
    return '$count itiraz — incelemek için dokun';
  }

  @override
  String billWaitingOnYou(int count) {
    return '$count tanesi senin onayını bekliyor';
  }

  @override
  String get billWaitingPayments => 'Ödemeler bekleniyor';

  @override
  String get billDisputed => 'İtiraz edildi';

  @override
  String get billMarkPaidAgain => 'Tekrar ödendi işaretle';

  @override
  String get billWaitingConfirmation => 'Onay bekleniyor';

  @override
  String get billMarkPaid => 'Ödendi işaretle';

  @override
  String get activityFormerMemberCap => 'Eski bir üye';

  @override
  String get activityFormerMember => 'eski bir üye';

  @override
  String get activityABill => 'bir hesap';

  @override
  String get activitySomeone => 'biri';

  @override
  String get activityFormerBeast => 'Eski Canavar';

  @override
  String activityBillAdded(String sender, String title) {
    return '$sender “$title” ekledi';
  }

  @override
  String activityBillAddedAmount(String sender, String title, String amount) {
    return '$sender “$title” ekledi — $amount';
  }

  @override
  String activityPaymentMarked(String sender) {
    return '$sender payını ödendi olarak işaretledi';
  }

  @override
  String activityPaymentConfirmedTarget(String sender, String target) {
    return '$sender bir ödemeyi onayladı ($target)';
  }

  @override
  String activityPaymentConfirmed(String sender) {
    return '$sender bir ödemeyi onayladı';
  }

  @override
  String activityPaymentDisputedTarget(String sender, String target) {
    return '$sender bir ödemeye itiraz etti ($target)';
  }

  @override
  String activityPaymentDisputed(String sender) {
    return '$sender bir ödemeye itiraz etti';
  }

  @override
  String activityMemberAdded(String sender, String target) {
    return '$sender gruba ekledi: $target';
  }

  @override
  String activityPoke(String article, String character) {
    return '$character grubu dürttü!';
  }

  @override
  String activityPhotoSent(String sender) {
    return '$sender bir fotoğraf gönderdi';
  }

  @override
  String get activityEmpty => 'Henüz etkinlik yok';

  @override
  String get photoExpiresIn3Days => 'Bu fotoğrafın süresi 3 gün içinde dolacak';

  @override
  String photoExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün',
      one: '1 gün',
    );
    return '$_temp0 içinde sona erer';
  }

  @override
  String photoExpiresInHours(int count) {
    return '$count sa içinde sona erer';
  }

  @override
  String photoExpiresInMinutes(int count) {
    return '$count dk içinde sona erer';
  }

  @override
  String get photoExpired => 'Fotoğrafın süresi doldu';

  @override
  String get linkOpenTitle => 'Bağlantı açılsın mı?';

  @override
  String linkOpenMessage(String url) {
    return 'Salapify’dan çıkıp şunu açmak üzeresin:\n\n$url';
  }

  @override
  String get commonOpen => 'Aç';

  @override
  String get linkOpenFailed => 'Bu bağlantı açılamadı.';

  @override
  String get chatNotifyAll => 'Tüm üyeleri bilgilendir';

  @override
  String get chatAddPhoto => 'Fotoğraf ekle';

  @override
  String get chatMessageHint => 'Gruba mesaj yaz...';

  @override
  String get chatPokeGroup => 'Grubu dürt';

  @override
  String get chatSendMessage => 'Mesaj gönder';

  @override
  String get reportTitle => 'Kullanıcıyı Şikayet Et';

  @override
  String get reportReporting => 'Şikayet edilen';

  @override
  String get reportWhatsGoingOn => 'Neler oluyor?';

  @override
  String get reportBeSpecific =>
      'Mümkün olduğunca net ol — ne olduğunu açıkça yaz.';

  @override
  String get reportHint => 'Ne olduğunu anlat...';

  @override
  String get reportDescribeIssue => 'Lütfen sorunu açıkla';

  @override
  String get reportSubmitted => 'Şikayet gönderildi';

  @override
  String get reportSubmit => 'Şikayeti Gönder';

  @override
  String get billEdit => 'Hesabı Düzenle';

  @override
  String get billDetailsTitle => 'Hesap Ayrıntıları';

  @override
  String get billOnlyPayerEdit =>
      'Bu hesabı yalnızca ödeyen kişi düzenleyebilir.';

  @override
  String get billLockedBanner =>
      'Toplam tutar ve bölüşüm kilitli — bu hesapta birinin ödeme hareketi var.';

  @override
  String get billSectionDetails => 'Hesap ayrıntıları';

  @override
  String get billTitleHint => 'ör. Akşam yemeği @ Köfteci';

  @override
  String get billTitleLabel => 'Başlık';

  @override
  String get billTitleRequired => 'Bir başlık gir';

  @override
  String get billTotalAmountLabel => 'Toplam tutar';

  @override
  String billAmountTooLarge(String amount) {
    return 'Tutar en fazla $amount olabilir';
  }

  @override
  String get billLockedNote => 'Kilitli — ödeme hareketi var';

  @override
  String get billSectionSplit => 'Bölüşüm';

  @override
  String get billPaidByLabel => 'Ödeyen';

  @override
  String get billSplitEqually => 'Eşit';

  @override
  String get billSplitCustom => 'Özel';

  @override
  String get billDelete => 'Hesabı Sil';

  @override
  String get billDeleteTitle => 'Bu hesap silinsin mi?';

  @override
  String get billDeleteMessage => 'Bu işlem geri alınamaz.';

  @override
  String get billDeletedSnack =>
      'Hesap silindi. İstediğin zaman yenisini ekleyebilirsin.';

  @override
  String get billFormerMember => 'Eski üye';

  @override
  String get billPaymentStatus => 'Ödeme durumu';

  @override
  String billAwaitingReview(int count) {
    return '$count inceleme bekliyor';
  }

  @override
  String get billStatusUnpaid => 'Ödenmedi';

  @override
  String get billStatusSaysPaid => 'Ödedim diyor — incele';

  @override
  String get billStatusConfirmed => 'Onaylandı';

  @override
  String get billDecline => 'Reddet';

  @override
  String notificationsLoadFailed(String error) {
    return 'Bildirimler yüklenemedi: $error';
  }

  @override
  String get notificationsEmpty => 'Henüz bildirim yok';

  @override
  String get notificationsEarlier => 'Daha önce';

  @override
  String notificationsUnread(int count) {
    return '$count okunmamış';
  }

  @override
  String get notificationsAllCaughtUp => 'Hepsini gördün';

  @override
  String get notificationsMarkAllRead => 'Tümünü okundu işaretle';

  @override
  String get notificationDeletedUser => 'Silinmiş kullanıcı';

  @override
  String notificationAddedToGroup(String name, String group) {
    return '$name seni “$group” grubuna ekledi';
  }

  @override
  String notificationBillAdded(String name, String title, String group) {
    return '$name, $group grubunda “$title” ekledi';
  }

  @override
  String notificationPaymentMarked(String name, String group) {
    return '$name, $group grubunda payını ödendi olarak işaretledi';
  }

  @override
  String notificationPaymentConfirmed(String name, String group) {
    return '$name, $group grubunda ödemeni onayladı';
  }

  @override
  String notificationPaymentDisputed(String name, String group) {
    return '$name, $group grubunda ödemene itiraz etti';
  }

  @override
  String get timeJustNow => 'Az önce';

  @override
  String timeMinutesAgo(int count) {
    return '$count dk önce';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count sa önce';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count gün önce';
  }

  @override
  String get notificationGroupUnavailable => 'Bu grup artık mevcut değil';

  @override
  String get gameTitle => 'Whack-a-Debt';

  @override
  String get gameTimeLabel => 'Süre';

  @override
  String get gameScoreLabel => 'Puan';

  @override
  String gameSecondsShort(int seconds) {
    return '$seconds sn';
  }

  @override
  String gameHint(int penalty) {
    return 'Arkadaşlarına dokun. Gergedanlardan uzak dur (-$penalty)!';
  }

  @override
  String get gameReady => 'Hazır mısın?';

  @override
  String gameYouHaveSeconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds saniyen',
      one: '1 saniyen',
    );
    return '$_temp0 var.';
  }

  @override
  String get gameWhackBeasts => 'Canavarlara vur';

  @override
  String get gameWhackBeastsDesc => 'Her vuruş için +1 puan';

  @override
  String get gameAvoidRhino => 'Kara gergedandan uzak dur!';

  @override
  String gameAvoidRhinoDesc(int penalty) {
    String _temp0 = intl.Intl.pluralLogic(
      penalty,
      locale: localeName,
      other: '$penalty puan',
      one: '1 puan',
    );
    return '-$_temp0. Ne pahasına olursa olsun uzak dur!';
  }

  @override
  String get gameStart => 'Başla';

  @override
  String get gameTimesUp => 'Süre doldu!';

  @override
  String get gameCountingScore => 'Puanın hesaplanıyor...';

  @override
  String get gameResultTitle => 'Sonucun';

  @override
  String get gameYourScore => 'PUANIN';

  @override
  String get gameMessageWarmingUp => 'Daha yeni ısınıyorsun!';

  @override
  String get gameMessageNice => 'Güzel vuruşlar!';

  @override
  String get gameMessageGreat => 'Harika vuruyorsun!';

  @override
  String get gameMessageSuperstar => 'Vuruş süperstarı!';

  @override
  String get gamePlayAgain => 'Tekrar oyna';

  @override
  String get helpTitle => 'Yardım ve SSS';

  @override
  String get helpSearchHint => 'Bir konu ara...';

  @override
  String helpNoResults(String query) {
    return '“$query” için sonuç yok';
  }

  @override
  String get faqSectionStarted => 'Başlarken';

  @override
  String get faqSectionBudgeting => 'Bütçeleme';

  @override
  String get faqSectionTransactions => 'İşlemler ve Gelir';

  @override
  String get faqSectionSplit => 'Hesabı Böl';

  @override
  String get faqSectionPeriods => 'Dönemler ve Ayarlar';

  @override
  String get faqSectionNotifications => 'Bildirimler';

  @override
  String get faqStartedQ1 => 'Salapify ne işe yarar?';

  @override
  String get faqStartedA1 =>
      'Salapify, bütçe takibini hesap bölmeyle birleştirir. Parayı kategorilere ayırmak için Bütçe sekmesini, gelir ve harcamalarını kaydetmek için İşlemler sekmesini, arkadaşlarınla veya diğer kullanıcılarla ortak masrafları hesaplaşmak için Hesabı Böl sekmesini kullan; hepsi tek yerde.';

  @override
  String get faqBudgetQ1 => 'Bütçe kategorisini nasıl oluştururum?';

  @override
  String get faqBudgetA1 =>
      'Bütçe sekmesindeki + düğmesine dokun. İnternet Faturası veya Market gibi bir kategori adı gir, sonra ayrılacak tutarı belirle. Sabit mi Değişken mi olduğunu seç ve ne sıklıkla tekrarlanacağını ayarla. Kalan alanları doldur ve kategoriyi kaydet.';

  @override
  String get faqBudgetQ2 => 'Sabit ile Değişken arasındaki fark nedir?';

  @override
  String get faqBudgetA2 =>
      'Sabit, İnternet Faturası gibi önceden bilinen giderler içindir; tek ve kesin bir tutar belirlersin. Değişken, Market gibi değişen harcamalar içindir; kesin tutar yerine hedef bir üst sınır belirlersin.';

  @override
  String get faqBudgetQ3 =>
      'Bir kategoriyi tamamlandı olarak işaretlersem ne olur?';

  @override
  String get faqBudgetA3 =>
      'Bir kategoriyi tamamlandı olarak işaretlediğinde, bu kategori geçerli dönem için otomatik olarak bir işlem olarak kaydedilir. Kategori ayrıca bitmiş olarak işaretlenir ve listenin en altına taşınır.';

  @override
  String get faqBudgetQ4 =>
      'Bütçe sekmemde bazı kategoriler neden soluk görünüyor?';

  @override
  String get faqBudgetA4 =>
      'Ayda iki dönemli bütçe kullandığında soluk kategoriler dönemin diğer yarısına aittir. Kendi yarıları başladığında otomatik olarak yeniden belirginleşirler.';

  @override
  String get faqTxQ1 => 'İşlem veya geliri nasıl eklerim?';

  @override
  String get faqTxA1 =>
      'İşlemler sekmesinde gider veya gelir kaydı eklemek için + simgesine dokun. Gelir için Tek seferlik mi Tekrarlayan mı olduğunu seç. Tekrarlayan kayıtlar her yeni dönemin başında otomatik olarak eklenir.';

  @override
  String get faqTxQ2 => 'İşlemler bütçemi nasıl etkiler?';

  @override
  String get faqTxA2 =>
      'Bir işlem kaydettiğinde onu bir bütçe kategorisine atarsın. Tutar, o kategorinin ayrılan bütçesinden otomatik olarak düşülür; böylece Bütçe sekmen her zaman harcayabileceğin kalan tutarı gösterir.';

  @override
  String get faqTxQ3 => 'Bir geliri veya gideri nasıl silerim?';

  @override
  String get faqTxA3 =>
      'İşlemler sekmesine git ve silmek istediğin gelir veya gideri sola kaydır. Sorulursa silme işlemini onayla.';

  @override
  String get faqTxQ4 => 'Geçen dönemin işlemlerini neden görmüyorum?';

  @override
  String get faqTxA4 =>
      'Bütçe ve İşlemler sekmeleri, Ayarlar’da belirlediğin bütçe dönemine göre yalnızca geçerli dönemin toplamlarını gösterir. Bu, rakamların hâlâ etkileyebileceğin şeylere odaklanmasını sağlar.';

  @override
  String get faqSplitQ1 => 'Arkadaşlarımla hesabı nasıl bölerim?';

  @override
  String get faqSplitA1 =>
      'Bir grup oluştur ve üyeleri kullanıcı adlarıyla ekle. Grubun içinde bir hesap oluştur (ör. “Akşam yemeği @ Köfteci”), ödediğin tutarı gir ve eşit olarak ya da her üye için özel paylarla böl.';

  @override
  String get faqSplitQ2 => 'Hesabı Böl grubunu nasıl silerim?';

  @override
  String get faqSplitA2 =>
      'Grubu sen oluşturduysan silmek için sola kaydır. Bir grubu silmek, ortak hesap etkinliklerinin tamamını da kaldırır.';

  @override
  String get faqSplitQ3 => 'Hesabı Böl grubundan nasıl ayrılırım?';

  @override
  String get faqSplitA3 =>
      'Bir grubun üyesiysen grubu sola kaydır ve Ayrıl’ı seç. Bu, grubu diğer herkes için silmeden seni gruptan çıkarır.';

  @override
  String get faqSplitQ4 =>
      'Grubumla fiş paylaşabilir veya sohbet edebilir miyim?';

  @override
  String get faqSplitA4 =>
      'Evet. Her grubun bir Etkinlik bölümü vardır; burada üyelere mesaj atabilir ve fiş gibi fotoğrafları hesap geçmişinin yanında paylaşabilirsin.';

  @override
  String get faqSplitQ5 => 'Hesabı Böl kişisel bütçemi etkiler mi?';

  @override
  String get faqSplitA5 =>
      'Hayır. Hesabı Böl, Bütçe ve İşlemler sekmelerinden ayrı tutulur. Hesaplaşılmış bir hesabın harcamalarına sayılmasını istersen onu elle bir işlem olarak kaydet.';

  @override
  String get faqSplitQ6 =>
      'Gruptaki birini nasıl şikayet eder veya engellerim?';

  @override
  String get faqSplitA6 =>
      'Grubun Etkinlik sekmesinde, bir üyenin mesajının yanındaki avatara basılı tut; Şikayet et ve Engelle seçeneklerini içeren bir menü açılır. Engellemek, onların mesajlarını ve etkinliklerini gizler; bunu istediğin zaman Ayarlar’dan geri alabilirsin.';

  @override
  String get faqPeriodQ1 => 'Aylık ile Ayda İki Dönem arasındaki fark nedir?';

  @override
  String get faqPeriodA1 =>
      'Aylık, bütçeni her ayın 1’inde sıfırlar. Ayda İki Dönem ise ayı iki yarıya böler: ilk yarının hangi gün biteceğini sen seçersin, ayın geri kalanı ikinci yarı olur.';

  @override
  String get faqPeriodQ2 => 'Dönemi değiştirirsem kategorilerime ne olur?';

  @override
  String get faqPeriodA2 =>
      'Mevcut kategoriler yeni döneme uyacak şekilde dönüştürülür ve tutarlarını korur. Belirli bir yarıya bağlı kategoriler artık tüm ayı kapsayacak (veya tam tersi); bu yüzden sonrasında yinelenenler olup olmadığını gözden geçir.';

  @override
  String get faqPeriodQ3 => 'Tekrar, ayda iki dönemli bütçeyle nasıl çalışır?';

  @override
  String get faqPeriodA3 =>
      'Tekrarlayan bir kategori, atadığın her yarıda yinelenir. Aylık döneme geçersen aynı öğe bunun yerine ayda bir kez tekrarlanır.';

  @override
  String get faqNotifQ1 => 'Bildirimler sekmesinde neler görünür?';

  @override
  String get faqNotifA1 =>
      'Hesabı Böl etkinliklerine dair güncellemeleri ve ödeyen kişi paylarından birine itiraz ettiğinde ya da onayladığında gelen uyarıları görürsün.';

  @override
  String get faqNotifQ2 => 'Bildirimleri kapatabilir miyim?';

  @override
  String get faqNotifA2 =>
      'Evet. Cihazının Ayarlar > Uygulamalar > Salapify > Bildirimler bölümüne git; buradan bildirimleri tamamen kapatabilir veya hangi tür uyarıları almak istediğini seçebilirsin.';

  @override
  String get languageChangeLaterHint =>
      'Bunu istediğiniz zaman Ayarlar\'dan değiştirebilirsiniz.';
}
