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

  @override
  String get budgetAllocations => 'ASIGNACIONES';

  @override
  String get budgetNoCategories => 'Aún no hay categorías';

  @override
  String get budgetFilter => 'Filtrar';

  @override
  String budgetFiltersCount(int count) {
    return 'Filtros ($count)';
  }

  @override
  String get budgetClearFiltersToReorder =>
      'Quita los filtros para reordenar las categorías';

  @override
  String get budgetNoMatch => 'Ninguna categoría coincide con tus filtros';

  @override
  String get budgetClearFilters => 'Quitar filtros';

  @override
  String budgetLoadFailed(String error) {
    return 'Error al cargar las categorías: $error';
  }

  @override
  String budgetAutoCompleted(String name) {
    return '$name se completó automáticamente: el gasto alcanzó el presupuesto.';
  }

  @override
  String get budgetFilterTitle => 'Filtrar categorías';

  @override
  String get commonClearAll => 'Borrar todo';

  @override
  String get budgetFilterStatus => 'Estado';

  @override
  String get budgetFilterAll => 'Todas';

  @override
  String get budgetFilterPending => 'Pendientes';

  @override
  String get budgetFilterCompleted => 'Completadas';

  @override
  String get budgetFilterType => 'Tipo';

  @override
  String get budgetTypeFixed => 'Fijo';

  @override
  String get budgetTypeVariable => 'Variable';

  @override
  String get budgetFilterRecurrence => 'Recurrencia';

  @override
  String get commonApply => 'Aplicar';

  @override
  String commonApplyCount(int count) {
    return 'Aplicar ($count)';
  }

  @override
  String get budgetFreqOnce => 'Una sola vez';

  @override
  String get budgetFreqRecurring => 'Recurrente';

  @override
  String get budgetFreqFirstHalf => 'Primera mitad';

  @override
  String get budgetFreqSecondHalf => 'Segunda mitad';

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

    return '1.ª mitad · $monthString $start–$end';
  }

  @override
  String budgetPeriodSecondHalf(DateTime month, int start, int end) {
    final intl.DateFormat monthDateFormat = intl.DateFormat.MMM(localeName);
    final String monthString = monthDateFormat.format(month);

    return '2.ª mitad · $monthString $start–$end';
  }

  @override
  String get budgetUsed => 'usado';

  @override
  String get budgetOverBudget => 'Excedido';

  @override
  String get budgetRemaining => 'Restante';

  @override
  String get budgetSpent => 'Gastado';

  @override
  String get budgetAllocated => 'Asignado';

  @override
  String get categoryCardFirstHalf => '1.ª mitad';

  @override
  String get categoryCardSecondHalf => '2.ª mitad';

  @override
  String get categoryCardBiMonthly => 'Quincenal';

  @override
  String get categoryMarkIncompleteTitle => '¿Marcar como incompleta?';

  @override
  String get categoryMarkIncompleteMessage =>
      'Los gastos generados automáticamente se eliminarán. Los gastos añadidos manualmente permanecerán y pueden volver a marcar esta categoría como completa.';

  @override
  String get categoryMarkIncompleteAction => 'Marcar como incompleta';

  @override
  String get categoryAdd => 'Añadir categoría';

  @override
  String get categoryEdit => 'Editar categoría';

  @override
  String get categoryDelete => 'Eliminar categoría';

  @override
  String get categoryNameLabel => 'Nombre de la categoría';

  @override
  String get categoryNameHint => 'p. ej. Supermercado, Internet';

  @override
  String get categoryNameRequired => 'El nombre es obligatorio';

  @override
  String amountLabelWithSymbol(String symbol) {
    return 'Monto ($symbol)';
  }

  @override
  String get amountRequired => 'El monto es obligatorio';

  @override
  String get amountInvalid => 'Ingresa un monto válido';

  @override
  String get amountTooLarge => 'El monto es demasiado grande';

  @override
  String get categoryTypeLabel => 'Tipo';

  @override
  String get categoryFixedTooltip => 'Fijo: el mismo monto cada vez.';

  @override
  String get categoryVariableTooltip =>
      'Variable: el monto puede cambiar cada vez.';

  @override
  String get categoryRepeat => 'Repetir';

  @override
  String get categoryEveryMonth => 'Cada mes';

  @override
  String get categoryOnce => 'Una vez';

  @override
  String get categoryEveryPeriod => 'Cada periodo';

  @override
  String get categoryBothHalves => 'Ambas mitades';

  @override
  String get categoryFirstHalf => 'Primera mitad';

  @override
  String get categorySecondHalf => 'Segunda mitad';

  @override
  String get categoryIcon => 'Ícono';

  @override
  String get commonSaveChanges => 'Guardar cambios';

  @override
  String get transactionTabExpenses => 'Gastos';

  @override
  String get transactionTabIncome => 'Ingresos';

  @override
  String get dateToday => 'Hoy';

  @override
  String get dateYesterday => 'Ayer';

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
  String get expensesEmpty => 'Aún no hay gastos';

  @override
  String expensesLoadFailed(String error) {
    return 'Error al cargar los gastos: $error';
  }

  @override
  String get expensesDeleteTitle => '¿Eliminar este gasto?';

  @override
  String get expensesDeleteMessage =>
      'Ya no se contará en tus totales de gastos.';

  @override
  String get transactionDeletedCategory => 'Categoría eliminada';

  @override
  String get transactionAutoNote => 'Presupuesto restante (auto)';

  @override
  String get incomeEmpty => 'Aún no hay ingresos';

  @override
  String incomeLoadFailed(String error) {
    return 'Error al cargar los ingresos: $error';
  }

  @override
  String get incomeDeleteTitle => '¿Eliminar este ingreso?';

  @override
  String get incomeDeleteMessage => 'Ya no se contará en el total de dinero.';

  @override
  String incomeEveryMonthOnDay(int day) {
    return 'Cada mes, el día $day';
  }

  @override
  String incomeEveryMonthOnDayClamped(int day, int effective) {
    return 'Cada mes, el día $day (día $effective este mes)';
  }

  @override
  String get cashFlowInfo =>
      'Tus ingresos y ahorros esperados este mes. No se guarda historial.';

  @override
  String get cashFlowSavings => 'Ahorros';

  @override
  String get expenseAdd => 'Añadir gasto';

  @override
  String get expenseEdit => 'Editar gasto';

  @override
  String get amountLabel => 'Monto';

  @override
  String get expenseCategory => 'Categoría';

  @override
  String get expenseSelectCategory => 'Selecciona una categoría';

  @override
  String get expenseNoCategories =>
      'Aún no hay categorías: añade una desde la pestaña Presupuesto.';

  @override
  String get expenseDate => 'Fecha';

  @override
  String get expenseNoteLabel => 'Nota (opcional)';

  @override
  String get expenseNoteHint => 'p. ej. Café con un amigo';

  @override
  String get incomeAdd => 'Añadir ingreso';

  @override
  String get incomeEdit => 'Editar ingreso';

  @override
  String get incomeSourceLabel => 'Fuente';

  @override
  String get incomeSourceHint => 'p. ej. Salario, Freelance, Regalo';

  @override
  String get incomeSourceRequired => 'La fuente es obligatoria';

  @override
  String get incomeSourceTooLong => 'Máximo 50 caracteres';

  @override
  String get incomeDepositDay => 'Día de depósito';

  @override
  String get incomeCountedEveryPeriod =>
      'Se cuenta como ingreso en todos los periodos, sin importar el día exacto.';

  @override
  String incomeAddedTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMM(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Se añadirá a: $dateString';
  }

  @override
  String get splitGroupNew => 'Nuevo grupo';

  @override
  String get splitGroupEdit => 'Editar grupo';

  @override
  String get splitGroupCreate => 'Crear grupo';

  @override
  String get splitGroupNameLabel => 'Nombre del grupo';

  @override
  String get splitGroupNameHint =>
      'p. ej. Compañeros de piso, Viaje a la playa';

  @override
  String get splitGroupNameRequired => 'Ingresa un nombre para el grupo';

  @override
  String get splitAddMembers => 'Añadir miembros';

  @override
  String splitGroupFull(int count) {
    return 'El grupo está lleno ($count/$count miembros)';
  }

  @override
  String get splitNoUserFound => 'No se encontró ningún usuario';

  @override
  String get splitSearchByUsername => 'Buscar por nombre de usuario';

  @override
  String get splitUnknownUser => 'Desconocido';

  @override
  String errorBillLimit(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit cuentas',
      one: '1 cuenta',
    );
    return 'Este grupo alcanzó su límite de $_temp0';
  }

  @override
  String errorGroupLimit(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit grupos activos',
      one: '1 grupo activo',
    );
    return 'Solo puedes tener $_temp0 en el plan gratuito';
  }

  @override
  String errorMaxMembers(int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit miembros',
      one: '1 miembro',
    );
    return 'Los grupos pueden tener como máximo $_temp0';
  }

  @override
  String get splitDeleteGroupTitle => '¿Eliminar este grupo?';

  @override
  String get splitLeaveGroupTitle => '¿Salir de este grupo?';

  @override
  String splitDeleteGroupMessage(String name) {
    return 'Esto elimina “$name” y sus cuentas para todos.';
  }

  @override
  String splitLeaveGroupMessage(String name) {
    return 'Ya no verás “$name” ni sus cuentas.';
  }

  @override
  String get splitLeave => 'Salir';

  @override
  String splitGroupsLoadFailed(String error) {
    return 'Error al cargar los grupos: $error';
  }

  @override
  String get splitNoGroups => 'Aún no hay grupos';

  @override
  String splitMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String get splitSettled => 'Saldado';

  @override
  String splitOwed(String amount) {
    return 'Te deben $amount';
  }

  @override
  String splitYouOwe(String amount) {
    return 'Debes $amount';
  }

  @override
  String get guestSplitTagline => 'Aporta. Salda. Sigan siendo amigos.';

  @override
  String get guestSplitDescription =>
      'Crea grupos, divide cuentas y mira quién le debe a quién. Inicia sesión para sincronizarlo todo con tus amigos.';

  @override
  String get guestSplitCta => 'Inicia sesión para comenzar';

  @override
  String splitBlockUser(String username) {
    return 'Bloquear a $username';
  }

  @override
  String splitReportUser(String username) {
    return 'Reportar a $username';
  }

  @override
  String splitBlockTitle(String username) {
    return '¿Bloquear a $username?';
  }

  @override
  String splitBlockMessage(String username) {
    return 'No verás los mensajes ni la actividad de $username en los grupos compartidos, incluidas las actualizaciones de cuentas. Puedes desbloquear a esta persona en cualquier momento desde Ajustes.';
  }

  @override
  String get splitBlockAction => 'Bloquear';

  @override
  String splitBlockedSnack(String username) {
    return 'Bloqueaste a $username';
  }

  @override
  String splitGameScoreMessage(int score) {
    return '🎮 ¡Obtuve $score puntos en Whack-a-Debt!';
  }

  @override
  String splitGroupLoadFailed(String error) {
    return 'Error al cargar el grupo: $error';
  }

  @override
  String get splitGroupNotFound => 'Grupo no encontrado';

  @override
  String splitBillsLoadFailed(String error) {
    return 'Error al cargar las cuentas: $error';
  }

  @override
  String get balanceAllSettled => 'Todo saldado';

  @override
  String get balanceOwedToYou => 'Te deben';

  @override
  String get balanceYouOwe => 'Debes';

  @override
  String get billAdd => 'Añadir cuenta';

  @override
  String billLimitReachedPremium(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cuentas',
      one: '1 cuenta',
    );
    return 'Este grupo alcanzó su límite de $_temp0. Elimina una cuenta para añadir otra.';
  }

  @override
  String billTotal(String amount) {
    return 'Total $amount';
  }

  @override
  String get billPaidByYou => 'Pagado por ti';

  @override
  String billPaidByName(String name) {
    return 'Pagado por $name';
  }

  @override
  String get billAllConfirmed => 'Todo confirmado';

  @override
  String billDisputedReview(int count) {
    return '$count en disputa — toca para revisar';
  }

  @override
  String billWaitingOnYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count esperan tu confirmación',
      one: '1 espera tu confirmación',
    );
    return '$_temp0';
  }

  @override
  String get billWaitingPayments => 'Esperando pagos';

  @override
  String get billDisputed => 'En disputa';

  @override
  String get billMarkPaidAgain => 'Marcar de nuevo';

  @override
  String get billWaitingConfirmation => 'Esperando confirmación';

  @override
  String get billMarkPaid => 'Marcar pagado';

  @override
  String get activityFormerMemberCap => 'Un exmiembro';

  @override
  String get activityFormerMember => 'un exmiembro';

  @override
  String get activityABill => 'una cuenta';

  @override
  String get activitySomeone => 'alguien';

  @override
  String get activityFormerBeast => 'Antigua bestia';

  @override
  String activityBillAdded(String sender, String title) {
    return '$sender añadió “$title”';
  }

  @override
  String activityBillAddedAmount(String sender, String title, String amount) {
    return '$sender añadió “$title” — $amount';
  }

  @override
  String activityPaymentMarked(String sender) {
    return '$sender marcó su parte como pagada';
  }

  @override
  String activityPaymentConfirmedTarget(String sender, String target) {
    return '$sender confirmó el pago de $target';
  }

  @override
  String activityPaymentConfirmed(String sender) {
    return '$sender confirmó un pago';
  }

  @override
  String activityPaymentDisputedTarget(String sender, String target) {
    return '$sender disputó el pago de $target';
  }

  @override
  String activityPaymentDisputed(String sender) {
    return '$sender disputó un pago';
  }

  @override
  String activityMemberAdded(String sender, String target) {
    return '$sender añadió a $target al grupo';
  }

  @override
  String activityPoke(String article, String character) {
    return '¡$character dio un toque al grupo!';
  }

  @override
  String activityPhotoSent(String sender) {
    return '$sender envió una foto';
  }

  @override
  String get activityEmpty => 'Aún no hay actividad';

  @override
  String get photoExpiresIn3Days => 'Esta foto caducará en 3 días';

  @override
  String photoExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return 'Caduca en $_temp0';
  }

  @override
  String photoExpiresInHours(int count) {
    return 'Caduca en $count h';
  }

  @override
  String photoExpiresInMinutes(int count) {
    return 'Caduca en $count min';
  }

  @override
  String get photoExpired => 'Foto caducada';

  @override
  String get linkOpenTitle => '¿Abrir enlace?';

  @override
  String linkOpenMessage(String url) {
    return 'Estás a punto de salir de Salapify y abrir:\n\n$url';
  }

  @override
  String get commonOpen => 'Abrir';

  @override
  String get linkOpenFailed => 'No se pudo abrir este enlace.';

  @override
  String get chatNotifyAll => 'Notificar a todos los miembros';

  @override
  String get chatAddPhoto => 'Añadir foto';

  @override
  String get chatMessageHint => 'Escribe al grupo...';

  @override
  String get chatPokeGroup => 'Dar un toque al grupo';

  @override
  String get chatSendMessage => 'Enviar mensaje';

  @override
  String get reportTitle => 'Reportar usuario';

  @override
  String get reportReporting => 'Reportando a';

  @override
  String get reportWhatsGoingOn => '¿Qué está pasando?';

  @override
  String get reportBeSpecific =>
      'Sé lo más específico posible: explica claramente lo que ocurrió.';

  @override
  String get reportHint => 'Describe lo que ocurrió...';

  @override
  String get reportDescribeIssue => 'Describe el problema';

  @override
  String get reportSubmitted => 'Reporte enviado';

  @override
  String get reportSubmit => 'Enviar reporte';

  @override
  String get billEdit => 'Editar cuenta';

  @override
  String get billDetailsTitle => 'Detalles de la cuenta';

  @override
  String get billOnlyPayerEdit => 'Solo quien pagó puede editar esta cuenta.';

  @override
  String get billLockedBanner =>
      'El monto total y la división están bloqueados: alguien ya tiene actividad de pago en esta cuenta.';

  @override
  String get billSectionDetails => 'Detalles de la cuenta';

  @override
  String get billTitleHint => 'p. ej. Cena con amigos';

  @override
  String get billTitleLabel => 'Título';

  @override
  String get billTitleRequired => 'Ingresa un título';

  @override
  String get billTotalAmountLabel => 'Monto total';

  @override
  String billAmountTooLarge(String amount) {
    return 'El monto no puede superar $amount';
  }

  @override
  String get billLockedNote => 'Bloqueado: hay actividad de pago';

  @override
  String get billSectionSplit => 'División';

  @override
  String get billPaidByLabel => 'Pagado por';

  @override
  String get billSplitEqually => 'Por igual';

  @override
  String get billSplitCustom => 'Personalizada';

  @override
  String get billDelete => 'Eliminar cuenta';

  @override
  String get billDeleteTitle => '¿Eliminar esta cuenta?';

  @override
  String get billDeleteMessage => 'Esta acción no se puede deshacer.';

  @override
  String get billDeletedSnack =>
      'Cuenta eliminada. Puedes añadir una nueva cuando quieras.';

  @override
  String get billFormerMember => 'Exmiembro';

  @override
  String get billPaymentStatus => 'Estado de los pagos';

  @override
  String billAwaitingReview(int count) {
    return '$count por revisar';
  }

  @override
  String get billStatusUnpaid => 'Sin pagar';

  @override
  String get billStatusSaysPaid => 'Dice que pagó — revisar';

  @override
  String get billStatusConfirmed => 'Confirmado';

  @override
  String get billDecline => 'Rechazar';

  @override
  String notificationsLoadFailed(String error) {
    return 'Error al cargar las notificaciones: $error';
  }

  @override
  String get notificationsEmpty => 'Aún no hay notificaciones';

  @override
  String get notificationsEarlier => 'Anteriores';

  @override
  String notificationsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sin leer',
      one: '1 sin leer',
    );
    return '$_temp0';
  }

  @override
  String get notificationsAllCaughtUp => 'Estás al día';

  @override
  String get notificationsMarkAllRead => 'Marcar todo como leído';

  @override
  String get notificationDeletedUser => 'Usuario eliminado';

  @override
  String notificationAddedToGroup(String name, String group) {
    return '$name te añadió a “$group”';
  }

  @override
  String notificationBillAdded(String name, String title, String group) {
    return '$name añadió “$title” en $group';
  }

  @override
  String notificationPaymentMarked(String name, String group) {
    return '$name marcó su parte como pagada en $group';
  }

  @override
  String notificationPaymentConfirmed(String name, String group) {
    return '$name confirmó tu pago en $group';
  }

  @override
  String notificationPaymentDisputed(String name, String group) {
    return '$name disputó tu pago en $group';
  }

  @override
  String get timeJustNow => 'Ahora mismo';

  @override
  String timeMinutesAgo(int count) {
    return 'hace $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'hace $count h';
  }

  @override
  String timeDaysAgo(int count) {
    return 'hace $count d';
  }

  @override
  String get notificationGroupUnavailable =>
      'Este grupo ya no está disponible.';
}
