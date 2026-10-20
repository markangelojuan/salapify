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
}
