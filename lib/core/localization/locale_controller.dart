import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salapify/core/services/push_notification_service.dart';
import 'package:salapify/features/settings/data/repositories/settings_repository.dart';

/// Null state = follow the device language (falls back to English if the
/// device language isn't supported).
class LocaleController extends Notifier<Locale?> {
  LocaleController(this._initial);

  final Locale? _initial;

  static const prefsKey = 'app_locale';

  @override
  Locale? build() => _initial;

  Future<void> set(Locale? locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(prefsKey);
    } else {
      await prefs.setString(prefsKey, encode(locale));
    }
    await _rescheduleReminders();
  }

  /// "zh_Hant_TW" style tags, so Traditional Chinese works later without
  /// changing the storage format.
  static String encode(Locale l) => [
    l.languageCode,
    if (l.scriptCode != null) l.scriptCode!,
    if (l.countryCode != null) l.countryCode!,
  ].join('_');

  static Locale? parse(String? tag) {
    if (tag == null || tag.isEmpty) return null;
    final p = tag.split('_');
    return switch (p.length) {
      1 => Locale(p[0]),
      2 => Locale(p[0], p[1]),
      _ => Locale.fromSubtags(
        languageCode: p[0],
        scriptCode: p[1],
        countryCode: p[2],
      ),
    };
  }

  Future<void> _rescheduleReminders() async {
    try {
      final enabled = await ref
          .read(settingsRepositoryProvider)
          .getLocalRemindersEnabled();
      if (!enabled) return;

      final push = ref.read(pushNotificationServiceProvider);
      if (!await push.hasNotificationPermission()) return;
      await push.scheduleMonthlyReminders();
    } catch (_) {
      // Non-critical: reminders get rescheduled on next app start anyway.
    }
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(
  () => LocaleController(null),
);
