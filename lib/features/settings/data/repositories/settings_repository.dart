import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/domain/currency.dart';

part 'settings_repository.g.dart';

class SettingsRepository {
  static const _periodKey = 'budgeting_period';
  static const _firstHalfEndDayKey = 'first_half_end_day';
  static const _lastResetPeriodKeyKey = 'last_reset_period_key';
  static const _currencyKey = 'currency';
  static const _remindersEnabledKey = 'reminders_enabled';
  static const _lastRetentionCheckKey = 'last_retention_check';

  /// Guest / signed-out scope for the identity-namespaced keys below.
  static const _guestScope = '__guest__';

  String _scope(String? uid) => uid ?? _guestScope;


  Future<BudgetingPeriod> getLocalBudgetingPeriod(String? uid) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('$_periodKey:${_scope(uid)}');
    if (value == null) return BudgetingPeriod.monthly;
    return BudgetingPeriod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BudgetingPeriod.monthly,
    );
  }

  Future<void> setLocalBudgetingPeriod(
    BudgetingPeriod period,
    String? uid,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_periodKey:${_scope(uid)}', period.name);
  }

  Future<int> getLocalFirstHalfEndDay(String? uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_firstHalfEndDayKey:${_scope(uid)}') ?? 15;
  }

  Future<void> setLocalFirstHalfEndDay(int day, String? uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_firstHalfEndDayKey:${_scope(uid)}', day);
  }

  Future<String?> getLastResetPeriodKey(String? uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_lastResetPeriodKeyKey:${_scope(uid)}');
  }

  Future<void> setLastResetPeriodKey(String key, String? uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_lastResetPeriodKeyKey:${_scope(uid)}', key);
  }

  Future<AppCurrency> getLocalCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_currencyKey);
    if (value == null) return AppCurrency.php;
    return AppCurrency.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppCurrency.php,
    );
  }

  Future<void> setLocalCurrency(AppCurrency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency.name);
  }

  Future<bool> getLocalRemindersEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_remindersEnabledKey) ?? false;
  }

  Future<void> setLocalRemindersEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_remindersEnabledKey, enabled);
  }

  /// Last time the transaction-retention sweep ran
  Future<DateTime?> getLastRetentionCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt(_lastRetentionCheckKey);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> setLastRetentionCheck(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastRetentionCheckKey, time.millisecondsSinceEpoch);
  }

  /// Sign-out: deliberately leaves the identity-scoped keys (period,
  /// firstHalfEndDay, lastResetPeriodKey) untouched. They're this device's
  /// memory of a specific account/guest session, not this-session-only
  /// state — wiping them here is what caused false period-reset triggers
  /// (and the resulting isCompleted wipe) on relogin.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_currencyKey),
      prefs.remove(_remindersEnabledKey),
      prefs.remove(_lastRetentionCheckKey),
    ]);
  }

  /// Account deletion only — this uid is gone for good, purge its
  /// identity-scoped cache too (clearAll alone intentionally keeps it).
  Future<void> clearForUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove('$_periodKey:$uid'),
      prefs.remove('$_firstHalfEndDayKey:$uid'),
      prefs.remove('$_lastResetPeriodKeyKey:$uid'),
    ]);
  }
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository();
}