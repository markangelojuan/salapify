import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/localization/locale_controller.dart';
import 'package:salapify/l10n/app_localizations.dart';

/// For code that has no BuildContext (controllers, services).
AppLocalizations currentL10n(Ref ref) {
  final saved = ref.read(localeControllerProvider);
  final locale =
      saved ??
      basicLocaleListResolution(
        WidgetsBinding.instance.platformDispatcher.locales,
        AppLocalizations.supportedLocales,
      );
  return lookupAppLocalizations(locale);
}