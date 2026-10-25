// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystemDefault => 'Predeterminado del sistema';

  @override
  String get languageChoose => 'Elegir idioma';

  @override
  String get settingsBudgetingPeriod => 'Periodo de presupuesto';

  @override
  String get budgetingPeriodMonthly => 'Mensual';

  @override
  String get budgetingPeriodMonthlyDesc =>
      'Controla tus presupuestos una vez al mes';

  @override
  String get budgetingPeriodBiMonthly => 'Quincenal';

  @override
  String get budgetingPeriodBiMonthlyDesc => 'Divide el mes en dos mitades';

  @override
  String get settingsFirstHalfEndsOn => 'La primera mitad termina el día';

  @override
  String get settingsCurrency => 'Moneda';

  @override
  String get settingsReminders => 'Recordatorios';

  @override
  String get settingsAppReminders => 'Recordatorios de la app';

  @override
  String get settingsAppRemindersDesc =>
      'Te avisamos de vez en cuando para actualizar tu presupuesto';

  @override
  String get settingsPrivacy => 'Privacidad';

  @override
  String get settingsBlockedUsers => 'Usuarios bloqueados';

  @override
  String get changePeriodTitle => 'Cambiar periodo de presupuesto';

  @override
  String get changePeriodMessage =>
      'Las categorías existentes se convertirán para ajustarse al nuevo periodo (los montos no cambian). Las categorías definidas para una mitad específica pasarán a contar para el mes completo, o viceversa; quizá quieras revisar y consolidar los duplicados después. ¿Continuar?';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonContinue => 'Continuar';

  @override
  String settingsLoadFailed(String error) {
    return 'No se pudo cargar la configuración: $error';
  }

  @override
  String get currencyTapToChange => 'Toca para cambiar';

  @override
  String get currencyChoose => 'Elegir moneda';

  @override
  String get reminderMonthStartTitle => 'Nuevo mes, presupuesto fresco 📊';

  @override
  String get reminderMonthStartBody =>
      'Actualiza tu presupuesto y registra tus transacciones pendientes.';

  @override
  String get reminderMidMonthTitle => 'Revisión de mitad de mes 💸';

  @override
  String get reminderMidMonthBody =>
      'No olvides registrar tus gastos recientes.';

  @override
  String get settingsSyncFailedPeriod =>
      'Periodo de presupuesto guardado en este dispositivo, pero no se pudo sincronizar con tu cuenta.';

  @override
  String get settingsSyncFailedGeneric =>
      'Ajuste guardado en este dispositivo, pero no se pudo sincronizar con tu cuenta.';

  @override
  String get settingsSyncFailedCurrency =>
      'Moneda guardada en este dispositivo, pero no se pudo sincronizar con tu cuenta.';

  @override
  String get settingsNotificationsDisabled =>
      'Las notificaciones están desactivadas para Salapify. Actívalas en los ajustes de tu teléfono para recibir recordatorios.';

  @override
  String get settingsConvertingCategories => 'Convirtiendo tus categorías…';

  @override
  String get errorUserNotFound => 'Hmm… no pudimos encontrar esa cuenta.';

  @override
  String get errorInvalidCredential =>
      'Esos datos de acceso no parecen correctos.';

  @override
  String get errorEmailInUse => 'Este correo ya es parte del club.';

  @override
  String get errorNetwork => 'Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get errorTooManyRequests =>
      'Demasiados intentos. Espera un minuto antes de volver a intentarlo.';

  @override
  String get errorUserDisabled => 'Esta cuenta está de vacaciones por ahora.';

  @override
  String get errorWeakPassword =>
      'Esa contraseña es muy fácil de adivinar. Prueba con una más larga.';

  @override
  String get errorRequiresRecentLogin =>
      'Por tu seguridad, cierra sesión y vuelve a iniciarla; luego inténtalo de nuevo.';

  @override
  String get errorOffline =>
      'Estás sin conexión. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get errorGeneric => '¡Un pequeño contratiempo! ¿Intentamos de nuevo?';

  @override
  String get errorUsernameTaken => 'El nombre de usuario ya está en uso';

  @override
  String get errorEmailRegistered => 'El correo ya está registrado';

  @override
  String get errorWrongPassword => 'Esa contraseña no parece correcta';

  @override
  String get errorReauthCancelled => 'Se canceló la confirmación';

  @override
  String get errorAccountDisabled => 'Esta cuenta ha sido deshabilitada';

  @override
  String get authSignInSubtitle =>
      'Ingresa tus credenciales para acceder a tu cuenta';

  @override
  String get authEmailLabel => 'Correo electrónico';

  @override
  String get authEmailHint => 'Ingresa tu correo';

  @override
  String get authEmailRequired => 'El correo es obligatorio';

  @override
  String get authEmailInvalid => 'Ingresa un correo válido';

  @override
  String get authPasswordLabel => 'Contraseña';

  @override
  String get authPasswordHint => 'Ingresa tu contraseña';

  @override
  String get authPasswordRequired => 'La contraseña es obligatoria';

  @override
  String get authPasswordInvalid => 'Contraseña no válida';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authSignUp => 'Regístrate';

  @override
  String get authOrContinueWith => 'O continúa con';

  @override
  String get authContinueWithGoogle => 'Continuar con Google';

  @override
  String get authNotMemberYet => '¿Aún no eres parte del club?';

  @override
  String get authContinueAsGuest => 'Continuar como invitado';

  @override
  String get authResetPasswordTitle => 'Restablece tu contraseña';

  @override
  String get authResetPasswordPrompt =>
      'Ingresa tu correo y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get authResetLinkSent =>
      'Si existe una cuenta con ese correo, el enlace de restablecimiento va en camino. Revisa tu bandeja de entrada (y la carpeta de spam).';

  @override
  String get authSendLink => 'Enviar enlace';

  @override
  String get commonDone => 'Listo';

  @override
  String get authSignUpSubtitle => 'Crea una cuenta para comenzar';

  @override
  String get authUsernameLabel => 'Nombre de usuario';

  @override
  String get authUsernameHint => 'Ingresa tu nombre de usuario preferido';

  @override
  String get authUsernameRequired => 'El nombre de usuario es obligatorio';

  @override
  String get authUsernameNoSpaces => 'Sin espacios al inicio ni al final';

  @override
  String get authUsernameStartLetter => 'Debe comenzar con una letra';

  @override
  String get authUsernameAllowedChars =>
      'Solo se permiten letras, números y guiones bajos';

  @override
  String get authUsernameMinLetters => 'Mínimo 3 letras';

  @override
  String get authUsernameMaxNumbers => 'Máximo 3 números';

  @override
  String get authPasswordPinLabel => 'Contraseña / PIN';

  @override
  String get authPasswordPinHint => 'Ingresa tu contraseña / PIN';

  @override
  String get authPasswordMinLength => 'Mínimo 6 caracteres';

  @override
  String get authConfirmPasswordLabel => 'Confirmar contraseña / PIN';

  @override
  String get authConfirmPasswordHint => 'Vuelve a ingresar tu contraseña / PIN';

  @override
  String get authConfirmPasswordRequired => 'Por favor confirma tu contraseña';

  @override
  String get authPasswordsMismatch => 'Las contraseñas no coinciden';

  @override
  String get authAgreeTerms =>
      'Acepto los Términos de servicio y la Política de privacidad';

  @override
  String get termsDialogTitle => 'Términos y privacidad';

  @override
  String get termsServiceHeading => 'Términos de servicio';

  @override
  String get termsServiceBody =>
      'Al usar Salapify, aceptas usar la app de forma responsable y proporcionar información veraz. Eres responsable de tu cuenta y de la información que ingreses.';

  @override
  String get termsPrivacyHeading => 'Política de privacidad';

  @override
  String get termsPrivacyBody =>
      'Salapify recopila la información necesaria para ofrecer tu cuenta, presupuestos, seguimiento de gastos, grupos y división de cuentas. No nos conectamos a tus cuentas bancarias ni financieras, y no vendemos tu información personal.';

  @override
  String get termsSharedHeading => 'Información compartida';

  @override
  String get termsSharedBody =>
      'Cuando te unes a grupos o divides cuentas, información relevante como tu nombre de usuario, cuentas y partes puede ser visible para los demás miembros de esos grupos.';

  @override
  String get termsImportantHeading => 'Importante';

  @override
  String get termsImportantBody =>
      'Salapify es una herramienta de presupuesto y organización, no un banco, un servicio de pagos ni un asesor financiero.';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get verifyEmailTitle => 'Verifica tu correo';

  @override
  String get verifyEmailSentGeneric => 'Te enviamos un enlace de verificación.';

  @override
  String verifyEmailSentTo(String email) {
    return 'Enviamos un enlace de verificación a $email.';
  }

  @override
  String get verifyEmailInstructions =>
      'Haz clic en el enlace de ese correo y luego toca el botón de abajo.';

  @override
  String get verifyEmailIVerified => 'Ya verifiqué';

  @override
  String get verifyEmailResend => 'Reenviar correo';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'Reenviar en $seconds s';
  }

  @override
  String get verifyEmailResent => 'Correo de verificación enviado.';

  @override
  String get verifyEmailNotYet =>
      'Aún no está verificado — revisa tu bandeja de entrada (y el spam).';

  @override
  String get commonSignOut => 'Cerrar sesión';

  @override
  String get avatarPickerTitle => '¿Qué monstruito del dinero eres?';

  @override
  String get avatarPickerSubtitle => 'Puedes cambiarlo en cualquier momento';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get avatarLuxuriousDog => 'Perro lujoso';

  @override
  String get avatarSavvyMonkey => 'Mono astuto';

  @override
  String get avatarGreedyCat => 'Gato avaricioso';

  @override
  String get avatarThriftyPig => 'Cerdito ahorrador';

  @override
  String get avatarStingyTurtle => 'Tortuga tacaña';

  @override
  String get avatarCovetousSnake => 'Serpiente codiciosa';

  @override
  String get avatarProsperousPanda => 'Panda próspero';

  @override
  String get avatarFrugalShark => 'Tiburón frugal';

  @override
  String get avatarOpulentWalrus => 'Morsa opulenta';

  @override
  String get avatarBrokeEagle => 'Águila sin un peso';

  @override
  String get accountAvatarNotSelected => 'Sin seleccionar';

  @override
  String get prefsBudgetTitle => '¿Cómo haces tu presupuesto?';

  @override
  String get prefsBudgetDescription =>
      'Tu periodo de presupuesto decide cuándo se reinician los presupuestos de tus categorías.';

  @override
  String get prefsMonthlyDesc => 'Un presupuesto para todo el mes';

  @override
  String get prefsTwiceMonthly => 'Dos veces al mes';

  @override
  String get prefsTwiceMonthlyDesc =>
      'Dividido en dos mitades, ideal si te pagan dos veces';

  @override
  String prefsFirstHalfRange(int day) {
    return 'La primera mitad va del día 1 al día $day.';
  }

  @override
  String get prefsCurrencyTitle => 'Elige tu moneda';

  @override
  String get prefsCurrencyDescription =>
      'Este es el símbolo que se muestra en tus presupuestos y transacciones.';

  @override
  String get prefsGetStarted => 'Comenzar';

  @override
  String get prefsUseDefaults => 'Usar valores predeterminados';

  @override
  String get prefsChangeLater =>
      'Puedes cambiar esto cuando quieras en Ajustes';

  @override
  String get commonNext => 'Siguiente';

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonChange => 'Cambiar';

  @override
  String get accountUserFallback => 'Usuario';

  @override
  String get accountProfileInfo => 'Información del perfil';

  @override
  String get accountEmail => 'Correo electrónico';

  @override
  String get accountSignInMethod => 'Método de inicio de sesión';

  @override
  String get accountAvatar => 'Avatar';

  @override
  String get accountMembership => 'Membresía';

  @override
  String get accountDangerZone => 'Zona de peligro';

  @override
  String get accountDeleteAccount => 'Eliminar cuenta';

  @override
  String get accountDeleteAccountDesc =>
      'Elimina permanentemente tu cuenta y todos tus datos';

  @override
  String get accountPremium => 'Premium';

  @override
  String get accountSeeWhatsInside => 'Descubre qué incluye';

  @override
  String get accountPremiumDesc =>
      'Límites más altos desbloqueados en esta cuenta';

  @override
  String get accountFreeDesc =>
      'Quita los límites de categorías, grupos y cuentas';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonRequired => 'Obligatorio';

  @override
  String get accountDeleteConfirmPhrase => 'Ahorra poco a poco, ahorra mucho';

  @override
  String get accountDeleteWarning =>
      'Esta acción es permanente y no se puede deshacer. Todos tus datos, transacciones y ajustes se eliminarán de forma permanente.';

  @override
  String accountDeleteTypePhrase(String phrase) {
    return 'Escribe “$phrase” para confirmar';
  }

  @override
  String get accountDeleteReauthGoogle =>
      'Por tu seguridad, confirma tu identidad con Google antes de eliminar tu cuenta.';

  @override
  String get accountDeleteReauthPassword =>
      'Por tu seguridad, ingresa tu contraseña para confirmar.';

  @override
  String get accountVerifyWithGoogle => 'Verificar con Google';

  @override
  String get accountDeletePermanently => 'Eliminar permanentemente';

  @override
  String get accountIncorrectPasswordRetry =>
      'Contraseña incorrecta. Inténtalo de nuevo.';

  @override
  String get accountChangeUsername => 'Cambiar nombre de usuario';

  @override
  String get accountUsernameUpdated => 'Nombre de usuario actualizado';

  @override
  String get accountChangePassword => 'Cambiar contraseña';

  @override
  String get accountCurrentPassword => 'Contraseña / PIN actual';

  @override
  String get accountNewPassword => 'Nueva contraseña / PIN';

  @override
  String get accountConfirmNewPassword => 'Confirmar nueva contraseña / PIN';

  @override
  String get accountIncorrectPassword => 'Contraseña incorrecta';

  @override
  String get accountPasswordUpdated => 'Contraseña actualizada';

  @override
  String get accountUpdatePassword => 'Actualizar contraseña';

  @override
  String get premiumHeaderBadge => 'Hazte premium';

  @override
  String get premiumHeaderActiveBadge => 'Eres premium';

  @override
  String get premiumHeadline => 'Elimina todos los límites del plan gratuito';

  @override
  String get premiumHeadlineActive =>
      'Se eliminaron todos los límites en esta cuenta.';

  @override
  String get premiumSub => 'Pago único. Sin suscripción, nunca.';

  @override
  String get premiumSubActive => 'Gracias por ayudarnos a mantener Salapify.';

  @override
  String get premiumWhatYouGet => 'Lo que obtienes';

  @override
  String premiumFeatureCategories(int count) {
    return '$count categorías de presupuesto activas';
  }

  @override
  String premiumFeatureCategoriesFree(int count) {
    return 'Plan gratuito: hasta $count activas';
  }

  @override
  String premiumFeatureGroups(int count) {
    return '$count grupos activos';
  }

  @override
  String premiumFeatureGroupsFree(int count) {
    return 'Plan gratuito: hasta $count activos';
  }

  @override
  String premiumFeatureBills(int count) {
    return '$count cuentas activas por grupo';
  }

  @override
  String premiumFeatureBillsFree(int count) {
    return 'Plan gratuito: hasta $count por grupo';
  }

  @override
  String get premiumFeatureAvatars => 'Más monstruitos desbloqueados';

  @override
  String get premiumFeatureAvatarsDesc =>
      'Avatares extra para personalizar tu perfil';

  @override
  String get premiumPricing => 'Precio';

  @override
  String get premiumBestValue => 'MEJOR VALOR — PAGA UNA VEZ';

  @override
  String get premiumOneTimeFee => 'pago único';

  @override
  String get premiumRestorePurchase => 'Restaurar compra';

  @override
  String get premiumSecurePayment =>
      'Pago único y seguro a través de App Store';

  @override
  String get premiumActiveOnAccount => 'Premium está activo en esta cuenta';

  @override
  String get premiumGo => 'Hazte Premium';

  @override
  String premiumBuyWithPrice(String price) {
    return 'Comprar — $price';
  }

  @override
  String get premiumRestored => 'Compra restaurada. ¡Disfruta!';

  @override
  String get premiumUnlocked => '¡Ya eres premium! Disfruta.';

  @override
  String get premiumErrorOtherAccount =>
      'Esta compra está vinculada a otra cuenta. Inicia sesión con esa cuenta para restaurarla.';

  @override
  String get premiumNothingToRestore =>
      'No se encontró ninguna compra anterior para restaurar.';

  @override
  String get premiumSignInFirst =>
      'Inicia sesión primero para desbloquear premium.';

  @override
  String get premiumBillingUnavailable =>
      'La facturación no está disponible en este momento. Inténtalo de nuevo más tarde.';

  @override
  String get premiumPurchaseFailed =>
      'La compra no se completó. Inténtalo de nuevo.';

  @override
  String get premiumLimitCategories =>
      '¡Tu presupuesto está creciendo! Llenaste todas las categorías gratuitas.';

  @override
  String get premiumLimitGroups =>
      'Tu grupo gratuito ya está ocupado. Solo puedes tener uno activo a la vez.';

  @override
  String get premiumLimitBills =>
      '¡Tus cuentas se multiplican! Se acabaron los espacios gratuitos.';

  @override
  String get premiumUpsellBenefit => 'Desbloqueo Premium de pago único';

  @override
  String get premiumUpsellSupport => 'Apoya la app con una compra única.';

  @override
  String get blockedUsersTitle => 'Usuarios bloqueados';

  @override
  String get blockedUsersEmpty => 'No hay usuarios bloqueados';

  @override
  String unblockTitle(String username) {
    return '¿Desbloquear a $username?';
  }

  @override
  String get unblockMessage =>
      'Esta persona podrá volver a interactuar contigo.';

  @override
  String get unblockAction => 'Desbloquear';

  @override
  String unblockedSnack(String username) {
    return 'Desbloqueaste a $username';
  }

  @override
  String commonLoadFailed(String error) {
    return 'Error al cargar: $error';
  }

  @override
  String get commonDelete => 'Eliminar';

  @override
  String confirmDeleteMessage(String itemName) {
    return '¿Seguro que quieres eliminar “$itemName”? Esta acción no se puede deshacer.';
  }

  @override
  String get navBudget => 'Presupuesto';

  @override
  String get navTransactions => 'Transacciones';

  @override
  String get navSplitBill => 'Dividir cuentas';

  @override
  String get navNotifications => 'Notificaciones';

  @override
  String get tourMenuTitle => 'Más opciones';

  @override
  String get tourMenuDesc =>
      'Administra tu cuenta, el periodo de presupuesto,\notros ajustes y obtén ayuda.';

  @override
  String get tourFabTitle => 'Añadir rápido';

  @override
  String get tourFabDesc =>
      'Toca + para añadir rápidamente una categoría,\nuna transacción o un grupo para dividir cuentas.';

  @override
  String get tourBudgetTitle => 'Planea tu presupuesto';

  @override
  String get tourBudgetDesc =>
      'Define límites de gasto por categoría\ny mira cuánto te queda.';

  @override
  String get tourTransactionsTitle => 'Controla tus gastos';

  @override
  String get tourTransactionsDesc =>
      'Registra tus ingresos y gastos.\nUsa + para añadir una transacción.';

  @override
  String get tourSplitTitle => 'Divide cuentas fácilmente';

  @override
  String get tourSplitDesc =>
      'Crea un grupo, añade cuentas\ny chatea con todos.';

  @override
  String get tourSplitDescGuest =>
      'Divide gastos con tus amigos.\nInicia sesión para desbloquear esta función.';

  @override
  String limitReachedCategories(int count) {
    return 'Llegaste al límite de $count categorías activas. Elimina una para añadir otra.';
  }

  @override
  String limitReachedGroups(int count) {
    return 'Llegaste al límite de $count grupos. Elimina un grupo para crear otro.';
  }

  @override
  String get drawerGuest => 'Invitado';

  @override
  String get drawerGuestSubtitle => 'Inicia sesión para guardar tus datos';

  @override
  String get drawerAccount => 'Cuenta';

  @override
  String get drawerDarkMode => 'Modo oscuro';

  @override
  String get drawerHelp => 'Ayuda / Preguntas frecuentes';

  @override
  String get drawerLogout => 'Cerrar sesión';
}
