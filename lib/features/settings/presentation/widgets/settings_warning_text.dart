import 'package:salapify/features/settings/domain/settings_warning.dart';
import 'package:salapify/l10n/app_localizations.dart';

extension SettingsWarningText on SettingsWarning {
  String text(AppLocalizations l10n) => switch (this) {
    SettingsWarning.periodSyncFailed => l10n.settingsSyncFailedPeriod,
    SettingsWarning.genericSyncFailed => l10n.settingsSyncFailedGeneric,
    SettingsWarning.currencySyncFailed => l10n.settingsSyncFailedCurrency,
    SettingsWarning.notificationsDisabled => l10n.settingsNotificationsDisabled,
  };
}