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

  Future<BudgetingPeriod> getLocalBudgetingPeriod() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_periodKey);
    if (value == null) return BudgetingPeriod.monthly;
    return BudgetingPeriod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BudgetingPeriod.monthly,
    );
  }

  Future<void> setLocalBudgetingPeriod(BudgetingPeriod period) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_periodKey, period.name);
  }

  Future<int> getLocalFirstHalfEndDay() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_firstHalfEndDayKey) ?? 15;
  }

  Future<void> setLocalFirstHalfEndDay(int day) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_firstHalfEndDayKey, day);
  }

  Future<String?> getLastResetPeriodKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastResetPeriodKeyKey);
  }

  Future<void> setLastResetPeriodKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastResetPeriodKeyKey, key);
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
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository();
}
