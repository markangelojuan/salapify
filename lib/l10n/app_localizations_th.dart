// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get settingsLanguage => 'ภาษา';

  @override
  String get languageSystemDefault => 'ตามระบบ';

  @override
  String get languageChoose => 'เลือกภาษา';

  @override
  String get settingsBudgetingPeriod => 'รอบงบประมาณ';

  @override
  String get budgetingPeriodMonthly => 'รายเดือน';

  @override
  String get budgetingPeriodMonthlyDesc => 'ติดตามงบประมาณเดือนละครั้ง';

  @override
  String get budgetingPeriodBiMonthly => 'สองรอบต่อเดือน';

  @override
  String get budgetingPeriodBiMonthlyDesc => 'แบ่งเดือนออกเป็นสองช่วง';

  @override
  String get settingsFirstHalfEndsOn => 'ช่วงแรกสิ้นสุดวันที่';

  @override
  String get settingsCurrency => 'สกุลเงิน';

  @override
  String get settingsReminders => 'การเตือน';

  @override
  String get settingsAppReminders => 'การเตือนจากแอป';

  @override
  String get settingsAppRemindersDesc =>
      'เตือนเป็นระยะให้มาอัปเดตงบประมาณของคุณ';

  @override
  String get settingsPrivacy => 'ความเป็นส่วนตัว';

  @override
  String get settingsBlockedUsers => 'ผู้ใช้ที่ถูกบล็อก';

  @override
  String get changePeriodTitle => 'เปลี่ยนรอบงบประมาณ';

  @override
  String get changePeriodMessage =>
      'หมวดหมู่ที่มีอยู่จะถูกแปลงให้ตรงกับรอบใหม่ (จำนวนเงินคงเดิม) หมวดหมู่ที่กำหนดไว้สำหรับช่วงใดช่วงหนึ่งจะนับรวมทั้งเดือน หรือกลับกัน คุณอาจต้องตรวจสอบและรวมรายการที่ซ้ำกันภายหลัง ดำเนินการต่อหรือไม่?';

  @override
  String get commonCancel => 'ยกเลิก';

  @override
  String get commonContinue => 'ดำเนินการต่อ';

  @override
  String settingsLoadFailed(String error) {
    return 'โหลดการตั้งค่าไม่สำเร็จ: $error';
  }

  @override
  String get currencyTapToChange => 'แตะเพื่อเปลี่ยน';

  @override
  String get currencyChoose => 'เลือกสกุลเงิน';

  @override
  String get reminderMonthStartTitle => 'เดือนใหม่ งบใหม่ 📊';

  @override
  String get reminderMonthStartBody =>
      'อัปเดตงบประมาณและบันทึกรายการที่ค้างอยู่กันเถอะ';

  @override
  String get reminderMidMonthTitle => 'เช็กอินกลางเดือน 💸';

  @override
  String get reminderMidMonthBody => 'อย่าลืมบันทึกรายจ่ายล่าสุดของคุณนะ';

  @override
  String get settingsSyncFailedPeriod =>
      'บันทึกรอบงบประมาณในอุปกรณ์นี้แล้ว แต่ซิงก์กับบัญชีของคุณไม่สำเร็จ';

  @override
  String get settingsSyncFailedGeneric =>
      'บันทึกการตั้งค่าในอุปกรณ์นี้แล้ว แต่ซิงก์กับบัญชีของคุณไม่สำเร็จ';

  @override
  String get settingsSyncFailedCurrency =>
      'บันทึกสกุลเงินในอุปกรณ์นี้แล้ว แต่ซิงก์กับบัญชีของคุณไม่สำเร็จ';

  @override
  String get settingsNotificationsDisabled =>
      'การแจ้งเตือนของ Salapify ถูกปิดอยู่ เปิดได้ในการตั้งค่าโทรศัพท์เพื่อรับการเตือน';

  @override
  String get settingsConvertingCategories => 'กำลังแปลงหมวดหมู่ของคุณ…';

  @override
  String get errorUserNotFound => 'อืม… หาบัญชีนี้ไม่เจอ';

  @override
  String get errorInvalidCredential => 'ข้อมูลเข้าสู่ระบบดูเหมือนจะไม่ถูกต้อง';

  @override
  String get errorEmailInUse => 'อีเมลนี้เป็นส่วนหนึ่งของแก๊งเราแล้ว';

  @override
  String get errorNetwork => 'โปรดตรวจสอบการเชื่อมต่อแล้วลองอีกครั้ง';

  @override
  String get errorTooManyRequests =>
      'ลองหลายครั้งเกินไป รอสักครู่แล้วลองใหม่นะ';

  @override
  String get errorUserDisabled => 'บัญชีนี้กำลังพักร้อนอยู่';

  @override
  String get errorWeakPassword =>
      'รหัสผ่านนี้เดาง่ายเกินไป ลองตั้งให้ยาวขึ้นอีกหน่อย';

  @override
  String get errorRequiresRecentLogin =>
      'เพื่อความปลอดภัย โปรดออกจากระบบแล้วเข้าสู่ระบบใหม่ จากนั้นลองอีกครั้ง';

  @override
  String get errorOffline =>
      'คุณออฟไลน์อยู่ ตรวจสอบการเชื่อมต่อแล้วลองอีกครั้ง';

  @override
  String get errorGeneric => 'มีสะดุดนิดหน่อย! ลองอีกทีไหม?';

  @override
  String get errorUsernameTaken => 'ชื่อผู้ใช้นี้ถูกใช้แล้ว';

  @override
  String get errorEmailRegistered => 'อีเมลนี้ลงทะเบียนแล้ว';

  @override
  String get errorWrongPassword => 'รหัสผ่านดูเหมือนจะไม่ถูกต้อง';

  @override
  String get errorReauthCancelled => 'ยกเลิกการยืนยันแล้ว';

  @override
  String get errorAccountDisabled => 'บัญชีนี้ถูกปิดใช้งาน';

  @override
  String get authSignInSubtitle => 'กรอกข้อมูลของคุณเพื่อเข้าสู่บัญชี';

  @override
  String get authEmailLabel => 'อีเมล';

  @override
  String get authEmailHint => 'กรอกอีเมลของคุณ';

  @override
  String get authEmailRequired => 'กรุณากรอกอีเมล';

  @override
  String get authEmailInvalid => 'กรอกอีเมลที่ถูกต้อง';

  @override
  String get authPasswordLabel => 'รหัสผ่าน';

  @override
  String get authPasswordHint => 'กรอกรหัสผ่านของคุณ';

  @override
  String get authPasswordRequired => 'กรุณากรอกรหัสผ่าน';

  @override
  String get authPasswordInvalid => 'รหัสผ่านไม่ถูกต้อง';

  @override
  String get authForgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get authSignIn => 'เข้าสู่ระบบ';

  @override
  String get authSignUp => 'สมัครสมาชิก';

  @override
  String get authOrContinueWith => 'หรือดำเนินการต่อด้วย';

  @override
  String get authContinueWithGoogle => 'ดำเนินการต่อด้วย Google';

  @override
  String get authNotMemberYet => 'ยังไม่ได้เป็นส่วนหนึ่งของแก๊งเราใช่ไหม?';

  @override
  String get authContinueAsGuest => 'ใช้งานแบบผู้เยี่ยมชม';

  @override
  String get authResetPasswordTitle => 'รีเซ็ตรหัสผ่าน';

  @override
  String get authResetPasswordPrompt =>
      'กรอกอีเมลของคุณ แล้วเราจะส่งลิงก์สำหรับรีเซ็ตรหัสผ่านให้';

  @override
  String get authResetLinkSent =>
      'หากมีบัญชีที่ใช้อีเมลนี้ ลิงก์รีเซ็ตกำลังส่งไปแล้ว ตรวจสอบกล่องจดหมาย (และโฟลเดอร์สแปม) ได้เลย';

  @override
  String get authSendLink => 'ส่งลิงก์';

  @override
  String get commonDone => 'เสร็จสิ้น';

  @override
  String get authSignUpSubtitle => 'สร้างบัญชีเพื่อเริ่มต้นใช้งาน';

  @override
  String get authUsernameLabel => 'ชื่อผู้ใช้';

  @override
  String get authUsernameHint => 'กรอกชื่อผู้ใช้ที่ต้องการ';

  @override
  String get authUsernameRequired => 'กรุณากรอกชื่อผู้ใช้';

  @override
  String get authUsernameNoSpaces => 'ห้ามมีช่องว่างหน้าหรือหลัง';

  @override
  String get authUsernameStartLetter => 'ต้องขึ้นต้นด้วยตัวอักษร';

  @override
  String get authUsernameAllowedChars =>
      'ใช้ได้เฉพาะตัวอักษร ตัวเลข และเครื่องหมายขีดล่าง';

  @override
  String get authUsernameMinLetters => 'ต้องมีตัวอักษรอย่างน้อย 3 ตัว';

  @override
  String get authUsernameMaxNumbers => 'มีตัวเลขได้ไม่เกิน 3 ตัว';

  @override
  String get authPasswordPinLabel => 'รหัสผ่าน / PIN';

  @override
  String get authPasswordPinHint => 'กรอกรหัสผ่าน / PIN ของคุณ';

  @override
  String get authPasswordMinLength => 'ต้องมีอย่างน้อย 6 ตัวอักษร';

  @override
  String get authConfirmPasswordLabel => 'ยืนยันรหัสผ่าน / PIN';

  @override
  String get authConfirmPasswordHint => 'กรอกรหัสผ่าน / PIN อีกครั้ง';

  @override
  String get authConfirmPasswordRequired => 'กรุณายืนยันรหัสผ่าน';

  @override
  String get authPasswordsMismatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get authAgreeTerms =>
      'ฉันยอมรับข้อกำหนดการให้บริการและนโยบายความเป็นส่วนตัว';

  @override
  String get termsDialogTitle => 'ข้อกำหนดและความเป็นส่วนตัว';

  @override
  String get termsServiceHeading => 'ข้อกำหนดการให้บริการ';

  @override
  String get termsServiceBody =>
      'การใช้ Salapify แสดงว่าคุณตกลงที่จะใช้แอปอย่างรับผิดชอบและให้ข้อมูลที่ถูกต้อง คุณเป็นผู้รับผิดชอบบัญชีของคุณและข้อมูลที่คุณกรอก';

  @override
  String get termsPrivacyHeading => 'นโยบายความเป็นส่วนตัว';

  @override
  String get termsPrivacyBody =>
      'Salapify เก็บรวบรวมข้อมูลที่จำเป็นเพื่อให้บริการบัญชี งบประมาณ การติดตามรายจ่าย กลุ่ม และการหารบิล เราไม่เชื่อมต่อกับบัญชีธนาคารหรือบัญชีทางการเงินของคุณ และเราไม่ขายข้อมูลส่วนบุคคลของคุณ';

  @override
  String get termsSharedHeading => 'ข้อมูลที่แชร์';

  @override
  String get termsSharedBody =>
      'เมื่อคุณเข้าร่วมกลุ่มหรือหารบิล ข้อมูลที่เกี่ยวข้อง เช่น ชื่อผู้ใช้ บิล และส่วนที่ต้องจ่าย อาจแสดงให้สมาชิกคนอื่นในกลุ่มนั้นเห็น';

  @override
  String get termsImportantHeading => 'สำคัญ';

  @override
  String get termsImportantBody =>
      'Salapify เป็นเครื่องมือช่วยวางแผนงบประมาณและจัดระเบียบการเงิน ไม่ใช่ธนาคาร บริการชำระเงิน หรือที่ปรึกษาทางการเงิน';

  @override
  String get commonClose => 'ปิด';

  @override
  String get verifyEmailTitle => 'ยืนยันอีเมลของคุณ';

  @override
  String get verifyEmailSentGeneric => 'เราส่งลิงก์ยืนยันให้คุณแล้ว';

  @override
  String verifyEmailSentTo(String email) {
    return 'เราส่งลิงก์ยืนยันไปที่ $email แล้ว';
  }

  @override
  String get verifyEmailInstructions =>
      'กดลิงก์ในอีเมลนั้น แล้วแตะปุ่มด้านล่าง';

  @override
  String get verifyEmailIVerified => 'ฉันยืนยันแล้ว';

  @override
  String get verifyEmailResend => 'ส่งอีเมลอีกครั้ง';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'ส่งอีกครั้งใน $seconds วินาที';
  }

  @override
  String get verifyEmailResent => 'ส่งอีเมลยืนยันแล้ว';

  @override
  String get verifyEmailNotYet =>
      'ยังไม่ได้ยืนยัน — ตรวจสอบกล่องจดหมาย (และสแปม)';

  @override
  String get commonSignOut => 'ออกจากระบบ';

  @override
  String get avatarPickerTitle => 'คุณเป็นสัตว์การเงินตัวไหนนะ?';

  @override
  String get avatarPickerSubtitle => 'เปลี่ยนได้ทุกเมื่อ';

  @override
  String get commonConfirm => 'ยืนยัน';

  @override
  String get avatarLuxuriousDog => 'หมาหรูหรา';

  @override
  String get avatarSavvyMonkey => 'ลิงช่างคิด';

  @override
  String get avatarGreedyCat => 'แมวละโมบ';

  @override
  String get avatarThriftyPig => 'หมูประหยัด';

  @override
  String get avatarStingyTurtle => 'เต่าขี้เหนียว';

  @override
  String get avatarCovetousSnake => 'งูโลภมาก';

  @override
  String get avatarProsperousPanda => 'แพนด้ามั่งคั่ง';

  @override
  String get avatarFrugalShark => 'ฉลามสุดประหยัด';

  @override
  String get avatarOpulentWalrus => 'วอลรัสสุดหรู';

  @override
  String get avatarBrokeEagle => 'อินทรีหมดตัว';

  @override
  String get accountAvatarNotSelected => 'ยังไม่ได้เลือก';

  @override
  String get prefsBudgetTitle => 'คุณวางแผนงบประมาณแบบไหน?';

  @override
  String get prefsBudgetDescription =>
      'รอบงบประมาณจะกำหนดว่างบของแต่ละหมวดหมู่รีเซ็ตเมื่อไร';

  @override
  String get prefsMonthlyDesc => 'งบเดียวสำหรับทั้งเดือน';

  @override
  String get prefsTwiceMonthly => 'เดือนละสองรอบ';

  @override
  String get prefsTwiceMonthlyDesc =>
      'แบ่งเป็นสองช่วง เหมาะสำหรับคนที่เงินเดือนออกสองครั้ง';

  @override
  String prefsFirstHalfRange(int day) {
    return 'ช่วงแรกเริ่มตั้งแต่วันที่ 1 ถึงวันที่ $day';
  }

  @override
  String get prefsCurrencyTitle => 'เลือกสกุลเงินของคุณ';

  @override
  String get prefsCurrencyDescription =>
      'สัญลักษณ์นี้จะแสดงในงบประมาณและรายการทั้งหมดของคุณ';

  @override
  String get prefsGetStarted => 'เริ่มเลย';

  @override
  String get prefsUseDefaults => 'ใช้ค่าเริ่มต้น';

  @override
  String get prefsChangeLater => 'เปลี่ยนได้ทุกเมื่อในการตั้งค่า';

  @override
  String get commonNext => 'ถัดไป';

  @override
  String get commonBack => 'ย้อนกลับ';

  @override
  String get commonChange => 'เปลี่ยน';

  @override
  String get accountUserFallback => 'ผู้ใช้';

  @override
  String get accountProfileInfo => 'ข้อมูลโปรไฟล์';

  @override
  String get accountEmail => 'อีเมล';

  @override
  String get accountSignInMethod => 'วิธีเข้าสู่ระบบ';

  @override
  String get accountAvatar => 'อวตาร';

  @override
  String get accountMembership => 'สมาชิก';

  @override
  String get accountDangerZone => 'โซนอันตราย';

  @override
  String get accountDeleteAccount => 'ลบบัญชี';

  @override
  String get accountDeleteAccountDesc =>
      'ลบบัญชีและข้อมูลทั้งหมดของคุณอย่างถาวร';

  @override
  String get accountPremium => 'พรีเมียม';

  @override
  String get accountSeeWhatsInside => 'ดูว่ามีอะไรบ้าง';

  @override
  String get accountPremiumDesc => 'ปลดล็อกขีดจำกัดที่สูงขึ้นในบัญชีนี้แล้ว';

  @override
  String get accountFreeDesc => 'ปลดขีดจำกัดของหมวดหมู่ กลุ่ม และบิล';

  @override
  String get commonSave => 'บันทึก';

  @override
  String get commonRequired => 'จำเป็น';

  @override
  String get accountDeleteConfirmPhrase => 'เก็บทีละนิด เงินออมพุ่งปรี๊ด';

  @override
  String get accountDeleteWarning =>
      'การดำเนินการนี้เป็นการถาวรและไม่สามารถย้อนกลับได้ ข้อมูล รายการ และการตั้งค่าทั้งหมดของคุณจะถูกลบอย่างถาวร';

  @override
  String accountDeleteTypePhrase(String phrase) {
    return 'พิมพ์ “$phrase” เพื่อยืนยัน';
  }

  @override
  String get accountDeleteReauthGoogle =>
      'เพื่อความปลอดภัย โปรดยืนยันตัวตนด้วย Google ก่อนที่เราจะลบบัญชีของคุณ';

  @override
  String get accountDeleteReauthPassword =>
      'เพื่อความปลอดภัย โปรดกรอกรหัสผ่านเพื่อยืนยัน';

  @override
  String get accountVerifyWithGoogle => 'ยืนยันด้วย Google';

  @override
  String get accountDeletePermanently => 'ลบถาวร';

  @override
  String get accountIncorrectPasswordRetry =>
      'รหัสผ่านไม่ถูกต้อง โปรดลองอีกครั้ง';

  @override
  String get accountChangeUsername => 'เปลี่ยนชื่อผู้ใช้';

  @override
  String get accountUsernameUpdated => 'อัปเดตชื่อผู้ใช้แล้ว';

  @override
  String get accountChangePassword => 'เปลี่ยนรหัสผ่าน';

  @override
  String get accountCurrentPassword => 'รหัสผ่าน / PIN ปัจจุบัน';

  @override
  String get accountNewPassword => 'รหัสผ่าน / PIN ใหม่';

  @override
  String get accountConfirmNewPassword => 'ยืนยันรหัสผ่าน / PIN ใหม่';

  @override
  String get accountIncorrectPassword => 'รหัสผ่านไม่ถูกต้อง';

  @override
  String get accountPasswordUpdated => 'อัปเดตรหัสผ่านแล้ว';

  @override
  String get accountUpdatePassword => 'อัปเดตรหัสผ่าน';

  @override
  String get premiumHeaderBadge => 'อัปเกรดเป็นพรีเมียม';

  @override
  String get premiumHeaderActiveBadge => 'คุณเป็นพรีเมียมแล้ว';

  @override
  String get premiumHeadline => 'ปลดทุกขีดจำกัดของแพ็กเกจฟรี';

  @override
  String get premiumHeadlineActive => 'ปลดทุกขีดจำกัดในบัญชีนี้แล้ว';

  @override
  String get premiumSub => 'จ่ายครั้งเดียว ไม่มีค่าสมัครสมาชิกตลอดไป';

  @override
  String get premiumSubActive => 'ขอบคุณที่ช่วยให้เราดูแล Salapify ต่อไปได้';

  @override
  String get premiumWhatYouGet => 'สิ่งที่คุณจะได้รับ';

  @override
  String premiumFeatureCategories(int count) {
    return 'หมวดหมู่งบประมาณที่ใช้งานได้ $count หมวด';
  }

  @override
  String premiumFeatureCategoriesFree(int count) {
    return 'แพ็กเกจฟรี: ใช้งานได้สูงสุด $count หมวด';
  }

  @override
  String premiumFeatureGroups(int count) {
    return 'กลุ่มที่ใช้งานได้ $count กลุ่ม';
  }

  @override
  String premiumFeatureGroupsFree(int count) {
    return 'แพ็กเกจฟรี: ใช้งานได้สูงสุด $count กลุ่ม';
  }

  @override
  String premiumFeatureBills(int count) {
    return 'บิลที่ใช้งานได้ $count บิลต่อกลุ่ม';
  }

  @override
  String premiumFeatureBillsFree(int count) {
    return 'แพ็กเกจฟรี: สูงสุด $count บิลต่อกลุ่ม';
  }

  @override
  String get premiumFeatureAvatars => 'ปลดล็อกสัตว์เพิ่มแล้ว';

  @override
  String get premiumFeatureAvatarsDesc =>
      'อวตารเพิ่มเติมไว้แต่งโปรไฟล์ให้เป็นตัวคุณ';

  @override
  String get premiumPricing => 'ราคา';

  @override
  String get premiumBestValue => 'คุ้มที่สุด — จ่ายครั้งเดียว';

  @override
  String get premiumOneTimeFee => 'จ่ายครั้งเดียว';

  @override
  String get premiumRestorePurchase => 'กู้คืนการซื้อ';

  @override
  String get premiumSecurePayment =>
      'ชำระเงินครั้งเดียวอย่างปลอดภัยผ่าน App Store';

  @override
  String get premiumActiveOnAccount => 'บัญชีนี้เปิดใช้งานพรีเมียมแล้ว';

  @override
  String get premiumGo => 'อัปเกรดเป็นพรีเมียม';

  @override
  String premiumBuyWithPrice(String price) {
    return 'ซื้อ — $price';
  }

  @override
  String get premiumRestored => 'กู้คืนการซื้อแล้ว — ใช้งานให้สนุกนะ!';

  @override
  String get premiumUnlocked => 'คุณเป็นพรีเมียมแล้ว — ใช้งานให้สนุกนะ!';

  @override
  String get premiumErrorOtherAccount =>
      'การซื้อนี้ผูกอยู่กับอีกบัญชีหนึ่ง โปรดเข้าสู่ระบบด้วยบัญชีนั้นเพื่อกู้คืน';

  @override
  String get premiumNothingToRestore => 'ไม่พบการซื้อก่อนหน้าที่จะกู้คืนได้';

  @override
  String get premiumSignInFirst => 'โปรดเข้าสู่ระบบก่อนเพื่อปลดล็อกพรีเมียม';

  @override
  String get premiumBillingUnavailable =>
      'ระบบชำระเงินใช้งานไม่ได้ในขณะนี้ โปรดลองใหม่ภายหลัง';

  @override
  String get premiumPurchaseFailed => 'การซื้อไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get premiumLimitCategories =>
      'งบของคุณโตขึ้นแล้ว! คุณใช้หมวดหมู่ฟรีครบทุกหมวดแล้ว';

  @override
  String get premiumLimitGroups =>
      'กลุ่มฟรีของคุณเต็มแล้ว ใช้งานได้ทีละกลุ่มเท่านั้น';

  @override
  String get premiumLimitBills =>
      'บิลของคุณเพิ่มขึ้นเรื่อยๆ! ช่องฟรีถูกใช้หมดแล้ว';

  @override
  String get premiumUpsellBenefit => 'ปลดล็อกพรีเมียมครั้งเดียว';

  @override
  String get premiumUpsellSupport => 'สนับสนุนแอปด้วยการซื้อครั้งเดียว';

  @override
  String get blockedUsersTitle => 'ผู้ใช้ที่ถูกบล็อก';

  @override
  String get blockedUsersEmpty => 'ไม่มีผู้ใช้ที่ถูกบล็อก';

  @override
  String unblockTitle(String username) {
    return 'เลิกบล็อก $username ไหม?';
  }

  @override
  String get unblockMessage => 'เขาจะสามารถโต้ตอบกับคุณได้อีกครั้ง';

  @override
  String get unblockAction => 'เลิกบล็อก';

  @override
  String unblockedSnack(String username) {
    return 'เลิกบล็อก $username แล้ว';
  }

  @override
  String commonLoadFailed(String error) {
    return 'โหลดไม่สำเร็จ: $error';
  }

  @override
  String get commonDelete => 'ลบ';

  @override
  String confirmDeleteMessage(String itemName) {
    return 'คุณแน่ใจไหมว่าต้องการลบ “$itemName” การลบนี้ไม่สามารถย้อนกลับได้';
  }

  @override
  String get navBudget => 'งบประมาณ';

  @override
  String get navTransactions => 'รายการ';

  @override
  String get navSplitBill => 'หารบิล';

  @override
  String get navNotifications => 'การแจ้งเตือน';

  @override
  String get tourMenuTitle => 'ตัวเลือกเพิ่มเติม';

  @override
  String get tourMenuDesc =>
      'จัดการบัญชี รอบงบประมาณ\nการตั้งค่าอื่นๆ และขอความช่วยเหลือ';

  @override
  String get tourFabTitle => 'เพิ่มด่วน';

  @override
  String get tourFabDesc =>
      'แตะ + เพื่อเพิ่มหมวดหมู่\nรายการ หรือกลุ่มหารบิลได้ทันที';

  @override
  String get tourBudgetTitle => 'วางแผนงบประมาณ';

  @override
  String get tourBudgetDesc =>
      'ตั้งวงเงินใช้จ่ายของแต่ละหมวดหมู่\nแล้วดูว่าเหลือเท่าไร';

  @override
  String get tourTransactionsTitle => 'ติดตามรายจ่ายของคุณ';

  @override
  String get tourTransactionsDesc =>
      'บันทึกรายรับและรายจ่าย\nแตะ + เพื่อเพิ่มรายการ';

  @override
  String get tourSplitTitle => 'หารบิลได้ง่ายๆ';

  @override
  String get tourSplitDesc => 'สร้างกลุ่ม เพิ่มบิล\nและแชตกับทุกคน';

  @override
  String get tourSplitDescGuest =>
      'หารค่าใช้จ่ายกับเพื่อน\nเข้าสู่ระบบเพื่อปลดล็อกฟีเจอร์นี้';

  @override
  String limitReachedCategories(int count) {
    return 'คุณใช้หมวดหมู่ครบ $count หมวดแล้ว ลบหนึ่งหมวดเพื่อเพิ่มหมวดใหม่';
  }

  @override
  String limitReachedGroups(int count) {
    return 'คุณมีกลุ่มครบ $count กลุ่มแล้ว ลบหนึ่งกลุ่มเพื่อสร้างกลุ่มใหม่';
  }

  @override
  String get drawerGuest => 'ผู้เยี่ยมชม';

  @override
  String get drawerGuestSubtitle => 'เข้าสู่ระบบเพื่อบันทึกข้อมูลของคุณ';

  @override
  String get drawerAccount => 'บัญชี';

  @override
  String get drawerDarkMode => 'โหมดมืด';

  @override
  String get drawerHelp => 'ช่วยเหลือ / คำถามที่พบบ่อย';

  @override
  String get drawerLogout => 'ออกจากระบบ';

  @override
  String get budgetAllocations => 'งบที่จัดสรร';

  @override
  String get budgetNoCategories => 'ยังไม่มีหมวดหมู่';

  @override
  String get budgetFilter => 'ตัวกรอง';

  @override
  String budgetFiltersCount(int count) {
    return 'ตัวกรอง ($count)';
  }

  @override
  String get budgetClearFiltersToReorder =>
      'ล้างตัวกรองเพื่อจัดเรียงหมวดหมู่ใหม่';

  @override
  String get budgetNoMatch => 'ไม่มีหมวดหมู่ที่ตรงกับตัวกรองของคุณ';

  @override
  String get budgetClearFilters => 'ล้างตัวกรอง';

  @override
  String budgetLoadFailed(String error) {
    return 'โหลดหมวดหมู่ไม่สำเร็จ: $error';
  }

  @override
  String budgetAutoCompleted(String name) {
    return '$name เสร็จสมบูรณ์โดยอัตโนมัติ — ยอดใช้จ่ายถึงงบแล้ว';
  }

  @override
  String get budgetFilterTitle => 'กรองหมวดหมู่';

  @override
  String get commonClearAll => 'ล้างทั้งหมด';

  @override
  String get budgetFilterStatus => 'สถานะ';

  @override
  String get budgetFilterAll => 'ทั้งหมด';

  @override
  String get budgetFilterPending => 'รอดำเนินการ';

  @override
  String get budgetFilterCompleted => 'เสร็จสมบูรณ์';

  @override
  String get budgetFilterType => 'ประเภท';

  @override
  String get budgetTypeFixed => 'คงที่';

  @override
  String get budgetTypeVariable => 'ไม่คงที่';

  @override
  String get budgetFilterRecurrence => 'การเกิดซ้ำ';

  @override
  String get commonApply => 'ใช้';

  @override
  String commonApplyCount(int count) {
    return 'ใช้ ($count)';
  }

  @override
  String get budgetFreqOnce => 'ครั้งเดียว';

  @override
  String get budgetFreqRecurring => 'เกิดซ้ำ';

  @override
  String get budgetFreqFirstHalf => 'ช่วงแรก';

  @override
  String get budgetFreqSecondHalf => 'ช่วงหลัง';

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

    return 'ช่วงแรก · $monthString $start–$end';
  }

  @override
  String budgetPeriodSecondHalf(DateTime month, int start, int end) {
    final intl.DateFormat monthDateFormat = intl.DateFormat.MMM(localeName);
    final String monthString = monthDateFormat.format(month);

    return 'ช่วงหลัง · $monthString $start–$end';
  }

  @override
  String get budgetUsed => 'ใช้ไปแล้ว';

  @override
  String get budgetOverBudget => 'เกินงบ';

  @override
  String get budgetRemaining => 'คงเหลือ';

  @override
  String get budgetSpent => 'ใช้จ่ายแล้ว';

  @override
  String get budgetAllocated => 'จัดสรรไว้';

  @override
  String get categoryCardFirstHalf => 'ช่วงแรก';

  @override
  String get categoryCardSecondHalf => 'ช่วงหลัง';

  @override
  String get categoryCardBiMonthly => 'สองรอบต่อเดือน';

  @override
  String get categoryMarkIncompleteTitle => 'ทำเครื่องหมายว่ายังไม่เสร็จ?';

  @override
  String get categoryMarkIncompleteMessage =>
      'รายจ่ายที่สร้างโดยอัตโนมัติจะถูกลบ ส่วนรายจ่ายที่เพิ่มเองจะยังอยู่ และอาจทำให้หมวดหมู่นี้ถูกทำเครื่องหมายว่าเสร็จอีกครั้ง';

  @override
  String get categoryMarkIncompleteAction => 'ทำเครื่องหมายว่ายังไม่เสร็จ';

  @override
  String get categoryAdd => 'เพิ่มหมวดหมู่';

  @override
  String get categoryEdit => 'แก้ไขหมวดหมู่';

  @override
  String get categoryDelete => 'ลบหมวดหมู่';

  @override
  String get categoryNameLabel => 'ชื่อหมวดหมู่';

  @override
  String get categoryNameHint => 'เช่น ของใช้ในบ้าน ค่าอินเทอร์เน็ต';

  @override
  String get categoryNameRequired => 'กรุณากรอกชื่อ';

  @override
  String amountLabelWithSymbol(String symbol) {
    return 'จำนวนเงิน ($symbol)';
  }

  @override
  String get amountRequired => 'กรุณากรอกจำนวนเงิน';

  @override
  String get amountInvalid => 'กรอกจำนวนเงินที่ถูกต้อง';

  @override
  String get amountTooLarge => 'จำนวนเงินมากเกินไป';

  @override
  String get categoryTypeLabel => 'ประเภท';

  @override
  String get categoryFixedTooltip => 'คงที่: จำนวนเงินเท่าเดิมทุกครั้ง';

  @override
  String get categoryVariableTooltip =>
      'ไม่คงที่: จำนวนเงินอาจเปลี่ยนไปในแต่ละครั้ง';

  @override
  String get categoryRepeat => 'ทำซ้ำ';

  @override
  String get categoryEveryMonth => 'ทุกเดือน';

  @override
  String get categoryOnce => 'ครั้งเดียว';

  @override
  String get categoryEveryPeriod => 'ทุกรอบ';

  @override
  String get categoryBothHalves => 'ทั้งสองช่วง';

  @override
  String get categoryFirstHalf => 'ช่วงแรก';

  @override
  String get categorySecondHalf => 'ช่วงหลัง';

  @override
  String get categoryIcon => 'ไอคอน';

  @override
  String get commonSaveChanges => 'บันทึกการเปลี่ยนแปลง';

  @override
  String get transactionTabExpenses => 'รายจ่าย';

  @override
  String get transactionTabIncome => 'รายรับ';

  @override
  String get dateToday => 'วันนี้';

  @override
  String get dateYesterday => 'เมื่อวาน';

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
  String get expensesEmpty => 'ยังไม่มีรายจ่าย';

  @override
  String expensesLoadFailed(String error) {
    return 'โหลดรายจ่ายไม่สำเร็จ: $error';
  }

  @override
  String get expensesDeleteTitle => 'ลบรายจ่ายนี้ไหม?';

  @override
  String get expensesDeleteMessage =>
      'รายการนี้จะไม่ถูกนับรวมในยอดใช้จ่ายของคุณอีกต่อไป';

  @override
  String get transactionDeletedCategory => 'หมวดหมู่ที่ถูกลบ';

  @override
  String get transactionAutoNote => 'งบที่เหลือ (อัตโนมัติ)';

  @override
  String get incomeEmpty => 'ยังไม่มีรายรับ';

  @override
  String incomeLoadFailed(String error) {
    return 'โหลดรายรับไม่สำเร็จ: $error';
  }

  @override
  String get incomeDeleteTitle => 'ลบรายรับนี้ไหม?';

  @override
  String get incomeDeleteMessage =>
      'รายการนี้จะไม่ถูกนับรวมในเงินทั้งหมดอีกต่อไป';

  @override
  String incomeEveryMonthOnDay(int day) {
    return 'ทุกเดือนในวันที่ $day';
  }

  @override
  String incomeEveryMonthOnDayClamped(int day, int effective) {
    return 'ทุกเดือนในวันที่ $day (เดือนนี้เป็นวันที่ $effective)';
  }

  @override
  String get cashFlowInfo =>
      'รายรับและเงินออมที่คาดว่าจะได้ในเดือนนี้ ไม่มีการเก็บประวัติ';

  @override
  String get cashFlowSavings => 'เงินออม';

  @override
  String get expenseAdd => 'เพิ่มรายจ่าย';

  @override
  String get expenseEdit => 'แก้ไขรายจ่าย';

  @override
  String get amountLabel => 'จำนวนเงิน';

  @override
  String get expenseCategory => 'หมวดหมู่';

  @override
  String get expenseSelectCategory => 'กรุณาเลือกหมวดหมู่';

  @override
  String get expenseNoCategories =>
      'ยังไม่มีหมวดหมู่ — เพิ่มได้จากแท็บงบประมาณ';

  @override
  String get expenseDate => 'วันที่';

  @override
  String get expenseNoteLabel => 'บันทึก (ไม่บังคับ)';

  @override
  String get expenseNoteHint => 'เช่น กาแฟกับเพื่อน';

  @override
  String get incomeAdd => 'เพิ่มรายรับ';

  @override
  String get incomeEdit => 'แก้ไขรายรับ';

  @override
  String get incomeSourceLabel => 'แหล่งที่มา';

  @override
  String get incomeSourceHint => 'เช่น เงินเดือน ฟรีแลนซ์ ของขวัญ';

  @override
  String get incomeSourceRequired => 'กรุณากรอกแหล่งที่มา';

  @override
  String get incomeSourceTooLong => 'ไม่เกิน 50 ตัวอักษร';

  @override
  String get incomeDepositDay => 'วันที่เงินเข้า';

  @override
  String get incomeCountedEveryPeriod =>
      'นับเป็นรายรับในทุกรอบ ไม่ว่าจะเป็นวันไหนก็ตาม';

  @override
  String incomeAddedTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMM(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'จะถูกเพิ่มไปที่: $dateString';
  }

  @override
  String get splitGroupNew => 'กลุ่มใหม่';

  @override
  String get splitGroupEdit => 'แก้ไขกลุ่ม';

  @override
  String get splitGroupCreate => 'สร้างกลุ่ม';

  @override
  String get splitGroupNameLabel => 'ชื่อกลุ่ม';

  @override
  String get splitGroupNameHint => 'เช่น เพื่อนร่วมห้อง ทริปเชียงใหม่';

  @override
  String get splitGroupNameRequired => 'กรอกชื่อกลุ่ม';

  @override
  String get splitAddMembers => 'เพิ่มสมาชิก';

  @override
  String splitGroupFull(int count) {
    return 'กลุ่มเต็มแล้ว (สมาชิก $count/$count คน)';
  }

  @override
  String get splitNoUserFound => 'ไม่พบผู้ใช้';

  @override
  String get splitSearchByUsername => 'ค้นหาด้วยชื่อผู้ใช้';

  @override
  String get splitUnknownUser => 'ไม่ทราบชื่อ';

  @override
  String errorBillLimit(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit บิล',
      one: '1 บิล',
    );
    return 'กลุ่มนี้ถึงขีดจำกัด $_temp0 แล้ว';
  }

  @override
  String errorGroupLimit(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit กลุ่ม',
      one: '1 กลุ่ม',
    );
    return 'แพ็กเกจฟรีมีกลุ่มที่ใช้งานได้ $_temp0 เท่านั้น';
  }

  @override
  String errorMaxMembers(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit คน',
      one: '1 คน',
    );
    return 'กลุ่มมีสมาชิกได้สูงสุด $_temp0';
  }

  @override
  String get splitDeleteGroupTitle => 'ลบกลุ่มนี้ไหม?';

  @override
  String get splitLeaveGroupTitle => 'ออกจากกลุ่มนี้ไหม?';

  @override
  String splitDeleteGroupMessage(String name) {
    return 'การดำเนินการนี้จะลบ “$name” และบิลทั้งหมดของทุกคน';
  }

  @override
  String splitLeaveGroupMessage(String name) {
    return 'คุณจะไม่เห็น “$name” และบิลของกลุ่มนี้อีก';
  }

  @override
  String get splitLeave => 'ออกจากกลุ่ม';

  @override
  String splitGroupsLoadFailed(String error) {
    return 'โหลดกลุ่มไม่สำเร็จ: $error';
  }

  @override
  String get splitNoGroups => 'ยังไม่มีกลุ่ม';

  @override
  String splitMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'สมาชิก $count คน',
      one: 'สมาชิก 1 คน',
    );
    return '$_temp0';
  }

  @override
  String get splitSettled => 'เคลียร์แล้ว';

  @override
  String splitOwed(String amount) {
    return 'ค้างรับ $amount';
  }

  @override
  String splitYouOwe(String amount) {
    return 'คุณต้องจ่าย $amount';
  }

  @override
  String get guestSplitTagline =>
      'ช่วยกันจ่าย เคลียร์กันให้จบ เป็นเพื่อนกันต่อไป';

  @override
  String get guestSplitDescription =>
      'สร้างกลุ่ม หารบิล และดูว่าใครติดใครอยู่เท่าไร เข้าสู่ระบบเพื่อซิงก์ทุกอย่างกับเพื่อนของคุณ';

  @override
  String get guestSplitCta => 'เข้าสู่ระบบเพื่อเริ่มต้น';

  @override
  String splitBlockUser(String username) {
    return 'บล็อก $username';
  }

  @override
  String splitReportUser(String username) {
    return 'รายงาน $username';
  }

  @override
  String splitBlockTitle(String username) {
    return 'บล็อก $username ไหม?';
  }

  @override
  String splitBlockMessage(String username) {
    return 'คุณจะไม่เห็นข้อความหรือกิจกรรมของ $username ในกลุ่มที่ใช้ร่วมกัน รวมถึงการอัปเดตบิล คุณเลิกบล็อกได้ทุกเมื่อจากการตั้งค่า';
  }

  @override
  String get splitBlockAction => 'บล็อก';

  @override
  String splitBlockedSnack(String username) {
    return 'บล็อก $username แล้ว';
  }

  @override
  String splitGameScoreMessage(int score) {
    return '🎮 ฉันได้ $score คะแนนใน Whack-a-Debt!';
  }

  @override
  String splitGroupLoadFailed(String error) {
    return 'โหลดกลุ่มไม่สำเร็จ: $error';
  }

  @override
  String get splitGroupNotFound => 'ไม่พบกลุ่ม';

  @override
  String splitBillsLoadFailed(String error) {
    return 'โหลดบิลไม่สำเร็จ: $error';
  }

  @override
  String get balanceAllSettled => 'เคลียร์กันครบแล้ว';

  @override
  String get balanceOwedToYou => 'ยอดที่ค้างรับ';

  @override
  String get balanceYouOwe => 'ยอดที่คุณต้องจ่าย';

  @override
  String get billAdd => 'เพิ่มบิล';

  @override
  String billLimitReachedPremium(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count บิล',
      one: '1 บิล',
    );
    return 'กลุ่มนี้ถึงขีดจำกัด $_temp0 แล้ว ลบหนึ่งบิลเพื่อเพิ่มบิลใหม่';
  }

  @override
  String billTotal(String amount) {
    return 'รวม $amount';
  }

  @override
  String get billPaidByYou => 'คุณเป็นคนจ่าย';

  @override
  String billPaidByName(String name) {
    return '$name เป็นคนจ่าย';
  }

  @override
  String get billAllConfirmed => 'ยืนยันครบแล้ว';

  @override
  String billDisputedReview(int count) {
    return '$count รายการมีข้อโต้แย้ง — แตะเพื่อตรวจสอบ';
  }

  @override
  String billWaitingOnYou(int count) {
    return 'รอคุณยืนยัน $count รายการ';
  }

  @override
  String get billWaitingPayments => 'รอการชำระเงิน';

  @override
  String get billDisputed => 'มีข้อโต้แย้ง';

  @override
  String get billMarkPaidAgain => 'ทำเครื่องหมายว่าจ่ายอีกครั้ง';

  @override
  String get billWaitingConfirmation => 'รอการยืนยัน';

  @override
  String get billMarkPaid => 'ทำเครื่องหมายว่าจ่ายแล้ว';

  @override
  String get activityFormerMemberCap => 'อดีตสมาชิก';

  @override
  String get activityFormerMember => 'อดีตสมาชิก';

  @override
  String get activityABill => 'บิล';

  @override
  String get activitySomeone => 'ใครบางคน';

  @override
  String get activityFormerBeast => 'สัตว์ที่ออกไปแล้ว';

  @override
  String activityBillAdded(String sender, String title) {
    return '$sender เพิ่ม “$title”';
  }

  @override
  String activityBillAddedAmount(String sender, String title, String amount) {
    return '$sender เพิ่ม “$title” — $amount';
  }

  @override
  String activityPaymentMarked(String sender) {
    return '$sender ทำเครื่องหมายว่าจ่ายส่วนของตัวเองแล้ว';
  }

  @override
  String activityPaymentConfirmedTarget(String sender, String target) {
    return '$sender ยืนยันการชำระเงินของ $target';
  }

  @override
  String activityPaymentConfirmed(String sender) {
    return '$sender ยืนยันการชำระเงิน';
  }

  @override
  String activityPaymentDisputedTarget(String sender, String target) {
    return '$sender โต้แย้งการชำระเงินของ $target';
  }

  @override
  String activityPaymentDisputed(String sender) {
    return '$sender โต้แย้งการชำระเงิน';
  }

  @override
  String activityMemberAdded(String sender, String target) {
    return '$sender เพิ่ม $target เข้ากลุ่ม';
  }

  @override
  String activityPoke(String article, String character) {
    return '$character สะกิดกลุ่ม!';
  }

  @override
  String activityPhotoSent(String sender) {
    return '$sender ส่งรูปภาพ';
  }

  @override
  String get activityEmpty => 'ยังไม่มีกิจกรรม';

  @override
  String get photoExpiresIn3Days => 'รูปนี้จะหมดอายุใน 3 วัน';

  @override
  String photoExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count วัน',
      one: '1 วัน',
    );
    return 'หมดอายุใน $_temp0';
  }

  @override
  String photoExpiresInHours(int count) {
    return 'หมดอายุใน $count ชม.';
  }

  @override
  String photoExpiresInMinutes(int count) {
    return 'หมดอายุใน $count นาที';
  }

  @override
  String get photoExpired => 'รูปหมดอายุแล้ว';

  @override
  String get linkOpenTitle => 'เปิดลิงก์ไหม?';

  @override
  String linkOpenMessage(String url) {
    return 'คุณกำลังจะออกจาก Salapify และเปิด:\n\n$url';
  }

  @override
  String get commonOpen => 'เปิด';

  @override
  String get linkOpenFailed => 'เปิดลิงก์นี้ไม่ได้';

  @override
  String get chatNotifyAll => 'แจ้งเตือนสมาชิกทุกคน';

  @override
  String get chatAddPhoto => 'เพิ่มรูปภาพ';

  @override
  String get chatMessageHint => 'ส่งข้อความถึงกลุ่ม...';

  @override
  String get chatPokeGroup => 'สะกิดกลุ่ม';

  @override
  String get chatSendMessage => 'ส่งข้อความ';

  @override
  String get reportTitle => 'รายงานผู้ใช้';

  @override
  String get reportReporting => 'กำลังรายงาน';

  @override
  String get reportWhatsGoingOn => 'เกิดอะไรขึ้น?';

  @override
  String get reportBeSpecific =>
      'ระบุให้ชัดเจนที่สุดเท่าที่ทำได้ — เล่าให้ชัดว่าเกิดอะไรขึ้น';

  @override
  String get reportHint => 'อธิบายสิ่งที่เกิดขึ้น...';

  @override
  String get reportDescribeIssue => 'โปรดอธิบายปัญหา';

  @override
  String get reportSubmitted => 'ส่งรายงานแล้ว';

  @override
  String get reportSubmit => 'ส่งรายงาน';

  @override
  String get billEdit => 'แก้ไขบิล';

  @override
  String get billDetailsTitle => 'รายละเอียดบิล';

  @override
  String get billOnlyPayerEdit => 'เฉพาะคนที่จ่ายเท่านั้นที่แก้ไขบิลนี้ได้';

  @override
  String get billLockedBanner =>
      'ยอดรวมและการแบ่งจ่ายถูกล็อกแล้ว — มีคนเริ่มดำเนินการชำระเงินในบิลนี้แล้ว';

  @override
  String get billSectionDetails => 'รายละเอียดบิล';

  @override
  String get billTitleHint => 'เช่น มื้อเย็นที่ร้านหมูกระทะ';

  @override
  String get billTitleLabel => 'ชื่อบิล';

  @override
  String get billTitleRequired => 'กรอกชื่อบิล';

  @override
  String get billTotalAmountLabel => 'ยอดรวม';

  @override
  String billAmountTooLarge(String amount) {
    return 'จำนวนเงินต้องไม่เกิน $amount';
  }

  @override
  String get billLockedNote => 'ล็อกแล้ว — มีการดำเนินการชำระเงินแล้ว';

  @override
  String get billSectionSplit => 'การแบ่งจ่าย';

  @override
  String get billPaidByLabel => 'คนจ่าย';

  @override
  String get billSplitEqually => 'หารเท่ากัน';

  @override
  String get billSplitCustom => 'กำหนดเอง';

  @override
  String get billDelete => 'ลบบิล';

  @override
  String get billDeleteTitle => 'ลบบิลนี้ไหม?';

  @override
  String get billDeleteMessage => 'การลบนี้ไม่สามารถย้อนกลับได้';

  @override
  String get billDeletedSnack => 'ลบบิลแล้ว คุณเพิ่มบิลใหม่ได้ทุกเมื่อ';

  @override
  String get billFormerMember => 'อดีตสมาชิก';

  @override
  String get billPaymentStatus => 'สถานะการชำระเงิน';

  @override
  String billAwaitingReview(int count) {
    return 'รอตรวจสอบ $count รายการ';
  }

  @override
  String get billStatusUnpaid => 'ยังไม่จ่าย';

  @override
  String get billStatusSaysPaid => 'แจ้งว่าจ่ายแล้ว — ตรวจสอบ';

  @override
  String get billStatusConfirmed => 'ยืนยันแล้ว';

  @override
  String get billDecline => 'ปฏิเสธ';

  @override
  String notificationsLoadFailed(String error) {
    return 'โหลดการแจ้งเตือนไม่สำเร็จ: $error';
  }

  @override
  String get notificationsEmpty => 'ยังไม่มีการแจ้งเตือน';

  @override
  String get notificationsEarlier => 'ก่อนหน้านี้';

  @override
  String notificationsUnread(int count) {
    return 'ยังไม่ได้อ่าน $count รายการ';
  }

  @override
  String get notificationsAllCaughtUp => 'คุณอ่านครบทุกอย่างแล้ว';

  @override
  String get notificationsMarkAllRead => 'ทำเครื่องหมายว่าอ่านทั้งหมด';

  @override
  String get notificationDeletedUser => 'ผู้ใช้ที่ถูกลบ';

  @override
  String notificationAddedToGroup(String name, String group) {
    return '$name เพิ่มคุณเข้ากลุ่ม “$group”';
  }

  @override
  String notificationBillAdded(String name, String title, String group) {
    return '$name เพิ่ม “$title” ใน $group';
  }

  @override
  String notificationPaymentMarked(String name, String group) {
    return '$name ทำเครื่องหมายว่าจ่ายส่วนของตัวเองแล้วใน $group';
  }

  @override
  String notificationPaymentConfirmed(String name, String group) {
    return '$name ยืนยันการชำระเงินของคุณใน $group';
  }

  @override
  String notificationPaymentDisputed(String name, String group) {
    return '$name โต้แย้งการชำระเงินของคุณใน $group';
  }

  @override
  String get timeJustNow => 'เมื่อสักครู่';

  @override
  String timeMinutesAgo(int count) {
    return '$count นาทีที่แล้ว';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count ชั่วโมงที่แล้ว';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count วันที่แล้ว';
  }

  @override
  String get notificationGroupUnavailable => 'กลุ่มนี้ไม่มีอยู่แล้ว';

  @override
  String get gameTitle => 'Whack-a-Debt';

  @override
  String get gameTimeLabel => 'เวลา';

  @override
  String get gameScoreLabel => 'คะแนน';

  @override
  String gameSecondsShort(int seconds) {
    return '$seconds วิ';
  }

  @override
  String gameHint(int penalty) {
    return 'แตะเพื่อนของคุณ หลีกเลี่ยงแรด (-$penalty)!';
  }

  @override
  String get gameReady => 'พร้อมไหม?';

  @override
  String gameYouHaveSeconds(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds วินาที',
      one: '1 วินาที',
    );
    return 'คุณมีเวลา $_temp0';
  }

  @override
  String get gameWhackBeasts => 'ตีเจ้าสัตว์ทั้งหลาย';

  @override
  String get gameWhackBeastsDesc => 'ตีโดนทุกครั้ง +1 คะแนน';

  @override
  String get gameAvoidRhino => 'หลีกเลี่ยงแรดดำ!';

  @override
  String gameAvoidRhinoDesc(int penalty) {
    String _temp0 = intl.Intl.pluralLogic(
      penalty,
      locale: localeName,
      other: '$penalty คะแนน',
      one: '1 คะแนน',
    );
    return '-$_temp0 หลบให้ไกลที่สุด!';
  }

  @override
  String get gameStart => 'เริ่ม';

  @override
  String get gameTimesUp => 'หมดเวลา!';

  @override
  String get gameCountingScore => 'กำลังนับคะแนนของคุณ...';

  @override
  String get gameResultTitle => 'ผลของคุณ';

  @override
  String get gameYourScore => 'คะแนนของคุณ';

  @override
  String get gameMessageWarmingUp => 'เพิ่งวอร์มอัป!';

  @override
  String get gameMessageNice => 'ตีได้เยี่ยม!';

  @override
  String get gameMessageGreat => 'คุณตีเก่งมาก!';

  @override
  String get gameMessageSuperstar => 'ซูเปอร์สตาร์สายตี!';

  @override
  String get gamePlayAgain => 'เล่นอีกครั้ง';

  @override
  String get helpTitle => 'ช่วยเหลือและคำถามที่พบบ่อย';

  @override
  String get helpSearchHint => 'ค้นหาหัวข้อ...';

  @override
  String helpNoResults(String query) {
    return 'ไม่พบผลลัพธ์สำหรับ “$query”';
  }

  @override
  String get faqSectionStarted => 'เริ่มต้นใช้งาน';

  @override
  String get faqSectionBudgeting => 'งบประมาณ';

  @override
  String get faqSectionTransactions => 'รายการและรายรับ';

  @override
  String get faqSectionSplit => 'หารบิล';

  @override
  String get faqSectionPeriods => 'รอบและการตั้งค่า';

  @override
  String get faqSectionNotifications => 'การแจ้งเตือน';

  @override
  String get faqStartedQ1 => 'Salapify ทำอะไรได้บ้าง?';

  @override
  String get faqStartedA1 =>
      'Salapify รวมการติดตามงบประมาณกับการหารบิลไว้ด้วยกัน ใช้แท็บงบประมาณเพื่อจัดสรรเงินเข้าหมวดหมู่ต่างๆ แท็บรายการเพื่อบันทึกรายรับและรายจ่าย และแท็บหารบิลเพื่อเคลียร์ค่าใช้จ่ายร่วมกับเพื่อนหรือผู้ใช้คนอื่น ทั้งหมดในที่เดียว';

  @override
  String get faqBudgetQ1 => 'สร้างหมวดหมู่งบประมาณได้อย่างไร?';

  @override
  String get faqBudgetA1 =>
      'แตะปุ่ม + ในแท็บงบประมาณ ใส่ชื่อหมวดหมู่ เช่น ค่าอินเทอร์เน็ตหรือของใช้ในบ้าน แล้วกำหนดจำนวนเงินที่จัดสรร เลือกว่าเป็นแบบคงที่หรือไม่คงที่ และตั้งว่าให้ทำซ้ำบ่อยแค่ไหน จากนั้นกรอกช่องที่เหลือแล้วบันทึกหมวดหมู่ของคุณ';

  @override
  String get faqBudgetQ2 => 'แบบคงที่กับไม่คงที่ต่างกันอย่างไร?';

  @override
  String get faqBudgetA2 =>
      'แบบคงที่ใช้กับค่าใช้จ่ายที่คาดเดาได้ เช่น ค่าอินเทอร์เน็ต ซึ่งคุณกำหนดจำนวนเงินที่แน่นอนไว้ ส่วนแบบไม่คงที่ใช้กับรายจ่ายที่เปลี่ยนไปเรื่อยๆ เช่น ของใช้ในบ้าน ซึ่งคุณกำหนดเป็นเพดานเป้าหมายแทนจำนวนเงินที่แน่นอน';

  @override
  String get faqBudgetQ3 =>
      'จะเกิดอะไรขึ้นเมื่อฉันติ๊กว่าหมวดหมู่เสร็จสมบูรณ์?';

  @override
  String get faqBudgetA3 =>
      'เมื่อทำเครื่องหมายว่าหมวดหมู่เสร็จสมบูรณ์ ระบบจะบันทึกเป็นรายการของรอบปัจจุบันให้โดยอัตโนมัติ หมวดหมู่นั้นจะถูกทำเครื่องหมายว่าเสร็จและย้ายไปอยู่ท้ายรายการด้วย';

  @override
  String get faqBudgetQ4 => 'ทำไมบางหมวดหมู่ในแท็บงบประมาณถึงจางลง?';

  @override
  String get faqBudgetA4 =>
      'หมวดหมู่ที่จางลงเป็นของอีกช่วงหนึ่งของรอบ เมื่อคุณใช้งบประมาณแบบสองรอบต่อเดือน หมวดหมู่เหล่านั้นจะกลับมาชัดเจนโดยอัตโนมัติเมื่อถึงช่วงของมัน';

  @override
  String get faqTxQ1 => 'เพิ่มรายการหรือรายรับได้อย่างไร?';

  @override
  String get faqTxA1 =>
      'ในแท็บรายการ แตะ + เพื่อเพิ่มรายจ่ายหรือรายรับ สำหรับรายรับ ให้เลือกว่าเป็นแบบครั้งเดียวหรือเกิดซ้ำ รายรับที่เกิดซ้ำจะถูกเพิ่มโดยอัตโนมัติเมื่อเริ่มรอบใหม่';

  @override
  String get faqTxQ2 => 'รายการส่งผลต่องบประมาณของฉันอย่างไร?';

  @override
  String get faqTxA2 =>
      'เมื่อคุณบันทึกรายการ คุณจะกำหนดให้อยู่ในหมวดหมู่งบประมาณหนึ่ง จำนวนเงินจะถูกหักออกจากงบที่จัดสรรของหมวดหมู่นั้นโดยอัตโนมัติ แท็บงบประมาณจึงแสดงยอดที่เหลือให้ใช้จ่ายอยู่เสมอ';

  @override
  String get faqTxQ3 => 'ลบรายรับหรือรายจ่ายได้อย่างไร?';

  @override
  String get faqTxA3 =>
      'ไปที่แท็บรายการ แล้วปัดไปทางซ้ายที่รายรับหรือรายจ่ายที่ต้องการลบ ยืนยันการลบหากมีข้อความถาม';

  @override
  String get faqTxQ4 => 'ทำไมฉันไม่เห็นรายการของรอบที่แล้ว?';

  @override
  String get faqTxA4 =>
      'แท็บงบประมาณและแท็บรายการแสดงยอดรวมเฉพาะรอบปัจจุบัน ตามรอบงบประมาณที่คุณตั้งไว้ในการตั้งค่า เพื่อให้ตัวเลขโฟกัสกับสิ่งที่คุณยังจัดการได้';

  @override
  String get faqSplitQ1 => 'หารบิลกับเพื่อนได้อย่างไร?';

  @override
  String get faqSplitA1 =>
      'สร้างกลุ่มและเพิ่มสมาชิกด้วยชื่อผู้ใช้ จากนั้นในกลุ่มให้สร้างบิล (เช่น “มื้อเย็นที่ร้านหมูกระทะ”) ใส่จำนวนเงินที่คุณจ่าย แล้วเลือกหารเท่ากันหรือกำหนดส่วนของแต่ละคนเอง';

  @override
  String get faqSplitQ2 => 'ลบกลุ่มหารบิลได้อย่างไร?';

  @override
  String get faqSplitA2 =>
      'หากคุณเป็นคนสร้างกลุ่ม ให้ปัดไปทางซ้ายที่กลุ่มเพื่อลบ การลบกลุ่มจะลบกิจกรรมบิลที่ใช้ร่วมกันทั้งหมดของกลุ่มนั้นด้วย';

  @override
  String get faqSplitQ3 => 'ออกจากกลุ่มหารบิลได้อย่างไร?';

  @override
  String get faqSplitA3 =>
      'หากคุณเป็นสมาชิกของกลุ่ม ให้ปัดไปทางซ้ายที่กลุ่มแล้วเลือกออกจากกลุ่ม คุณจะออกจากกลุ่มโดยที่กลุ่มยังคงอยู่สำหรับคนอื่น';

  @override
  String get faqSplitQ4 => 'แชร์ใบเสร็จหรือแชตกับกลุ่มได้ไหม?';

  @override
  String get faqSplitA4 =>
      'ได้ ทุกกลุ่มมีส่วนกิจกรรมที่คุณส่งข้อความหาสมาชิกและแชร์รูปภาพ เช่น ใบเสร็จ ควบคู่ไปกับประวัติบิลได้';

  @override
  String get faqSplitQ5 => 'การหารบิลส่งผลต่องบประมาณส่วนตัวของฉันไหม?';

  @override
  String get faqSplitA5 =>
      'ไม่ส่งผล การหารบิลแยกจากแท็บงบประมาณและแท็บรายการของคุณ หากต้องการให้บิลที่เคลียร์แล้วนับเป็นรายจ่ายของคุณ ให้บันทึกเป็นรายการด้วยตัวเอง';

  @override
  String get faqSplitQ6 => 'รายงานหรือบล็อกคนในกลุ่มได้อย่างไร?';

  @override
  String get faqSplitA6 =>
      'ในแท็บกิจกรรมของกลุ่ม ให้กดค้างที่อวตารของสมาชิกข้างข้อความของเขา เพื่อเปิดเมนูที่มีตัวเลือกรายงานและบล็อก การบล็อกจะซ่อนข้อความและกิจกรรมของเขา และคุณยกเลิกได้ทุกเมื่อจากการตั้งค่า';

  @override
  String get faqPeriodQ1 => 'รายเดือนกับสองรอบต่อเดือนต่างกันอย่างไร?';

  @override
  String get faqPeriodA1 =>
      'รายเดือนจะรีเซ็ตงบประมาณของคุณในวันที่ 1 ของทุกเดือน ส่วนสองรอบต่อเดือนจะแบ่งเดือนเป็นสองช่วง คุณเลือกได้ว่าช่วงแรกสิ้นสุดวันไหน และที่เหลือของเดือนจะเป็นช่วงหลัง';

  @override
  String get faqPeriodQ2 => 'จะเกิดอะไรกับหมวดหมู่ของฉันถ้าเปลี่ยนรอบ?';

  @override
  String get faqPeriodA2 =>
      'หมวดหมู่ที่มีอยู่จะถูกแปลงให้ตรงกับรอบใหม่และคงจำนวนเงินเดิมไว้ หมวดหมู่ที่กำหนดไว้สำหรับช่วงใดช่วงหนึ่งจะนับรวมทั้งเดือน (หรือกลับกัน) จึงควรตรวจสอบภายหลังว่ามีรายการซ้ำหรือไม่';

  @override
  String get faqPeriodQ3 => 'การเกิดซ้ำทำงานอย่างไรกับงบประมาณสองรอบต่อเดือน?';

  @override
  String get faqPeriodA3 =>
      'หมวดหมู่ที่เกิดซ้ำจะทำซ้ำในทุกช่วงที่คุณกำหนดไว้ หากเปลี่ยนไปใช้รายเดือน รายการเดิมก็จะทำซ้ำเดือนละครั้งแทน';

  @override
  String get faqNotifQ1 => 'แท็บการแจ้งเตือนแสดงอะไรบ้าง?';

  @override
  String get faqNotifA1 =>
      'คุณจะเห็นความเคลื่อนไหวของกิจกรรมหารบิล รวมถึงการแจ้งเตือนเมื่อคนที่จ่ายโต้แย้งหรือยืนยันส่วนที่คุณต้องจ่าย';

  @override
  String get faqNotifQ2 => 'ปิดการแจ้งเตือนได้ไหม?';

  @override
  String get faqNotifA2 =>
      'ได้ ไปที่การตั้งค่าอุปกรณ์ > แอป > Salapify > การแจ้งเตือน ซึ่งคุณปิดการแจ้งเตือนทั้งหมด หรือเลือกประเภทการแจ้งเตือนที่ต้องการรับได้';
}
