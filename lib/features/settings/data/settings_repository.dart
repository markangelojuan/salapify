import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';

part 'settings_repository.g.dart';

class SettingsRepository {
  SettingsRepository(this._firestore);

  final FirebaseFirestore _firestore;
  static const _periodKey = 'budgeting_period';
  static const _firstHalfEndDayKey = 'first_half_end_day';

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

  Future<void> pushBudgetingPeriod(String uid, BudgetingPeriod period) async {
    await _firestore.collection('users').doc(uid).set(
      {'budgetingPeriod': period.name},
      SetOptions(merge: true),
    );
  }

  Future<int> getLocalFirstHalfEndDay() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_firstHalfEndDayKey) ?? 15;
  }

  Future<void> setLocalFirstHalfEndDay(int day) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_firstHalfEndDayKey, day);
  }

  Future<void> pushFirstHalfEndDay(String uid, int day) async {
    await _firestore.collection('users').doc(uid).set(
      {'firstHalfEndDay': day},
      SetOptions(merge: true),
    );
  }
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(FirebaseFirestore.instance);
}