import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salapify/features/settings/data/repositories/settings_repository.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/domain/currency.dart';

part 'settings_sync_service.g.dart';

class SettingsSyncService {
  SettingsSyncService(this._repository, this._firestore);

  final SettingsRepository _repository;
  final FirebaseFirestore _firestore;

  static const _firestoreTimeout = Duration(seconds: 8);

  static const _periodSyncedKey = 'budgeting_period_synced';
  static const _firstHalfEndDaySyncedKey = 'first_half_end_day_synced';

  static const _currencySyncedKey = 'currency_synced';

  Future<void> pushBudgetingPeriod(String uid, BudgetingPeriod period) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .set({'budgetingPeriod': period.name}, SetOptions(merge: true))
          .timeout(_firestoreTimeout);
      await _setBudgetingPeriodSynced(true);
    } catch (_) {
      await _setBudgetingPeriodSynced(false);
      rethrow;
    }
  }

  Future<void> pushFirstHalfEndDay(String uid, int day) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .set({'firstHalfEndDay': day}, SetOptions(merge: true))
          .timeout(_firestoreTimeout);
      await _setFirstHalfEndDaySynced(true);
    } catch (_) {
      await _setFirstHalfEndDaySynced(false);
      rethrow;
    }
  }

  /// Pulls the account's remote settings and applies them locally. Call on
  /// sign-in so a device shows the account's actual settings, not local
  /// defaults or leftover guest-mode values.
  Future<void> pullRemoteSettings(String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get()
        .timeout(_firestoreTimeout);
    final data = doc.data();
    if (data == null) return;

    final remotePeriodName = data['budgetingPeriod'] as String?;
    if (remotePeriodName != null) {
      final period = BudgetingPeriod.values.firstWhere(
        (e) => e.name == remotePeriodName,
        orElse: () => BudgetingPeriod.monthly,
      );
      await _repository.setLocalBudgetingPeriod(period);
      await _setBudgetingPeriodSynced(true);
    }

    final remoteDay = data['firstHalfEndDay'] as int?;
    if (remoteDay != null) {
      await _repository.setLocalFirstHalfEndDay(remoteDay);
      await _setFirstHalfEndDaySynced(true);
    }

    final remoteCurrencyName = data['currency'] as String?;
    if (remoteCurrencyName != null) {
      final currency = AppCurrency.values.firstWhere(
        (e) => e.name == remoteCurrencyName,
        orElse: () => AppCurrency.php,
      );
      await _repository.setLocalCurrency(currency);
      await _setCurrencySynced(true);
    }
  }

  /// Re-pushes whichever setting(s) failed to sync last time
  Future<void> retryPendingSettingsSync(String uid) async {
    if (!await isBudgetingPeriodSynced()) {
      try {
        await pushBudgetingPeriod(
          uid,
          await _repository.getLocalBudgetingPeriod(),
        );
      } catch (_) {}
    }
    if (!await isFirstHalfEndDaySynced()) {
      try {
        await pushFirstHalfEndDay(
          uid,
          await _repository.getLocalFirstHalfEndDay(),
        );
      } catch (_) {}
    }
    if (!await isCurrencySynced()) {
      try {
        await pushCurrency(uid, await _repository.getLocalCurrency());
      } catch (_) {}
    }
  }

  Future<bool> isBudgetingPeriodSynced() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_periodSyncedKey) ?? true;
  }

  Future<void> _setBudgetingPeriodSynced(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_periodSyncedKey, value);
  }

  Future<bool> isFirstHalfEndDaySynced() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstHalfEndDaySyncedKey) ?? true;
  }

  Future<void> _setFirstHalfEndDaySynced(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstHalfEndDaySyncedKey, value);
  }

  Future<void> pushLocalSettingsOnSignIn(String uid) async {
    try {
      await pushBudgetingPeriod(
        uid,
        await _repository.getLocalBudgetingPeriod(),
      );
    } catch (_) {}
    try {
      await pushFirstHalfEndDay(
        uid,
        await _repository.getLocalFirstHalfEndDay(),
      );
    } catch (_) {}
    try {
      await pushCurrency(uid, await _repository.getLocalCurrency());
    } catch (_) {}
  }

  Future<void> pushCurrency(String uid, AppCurrency currency) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .set({'currency': currency.name}, SetOptions(merge: true))
          .timeout(_firestoreTimeout);
      await _setCurrencySynced(true);
    } catch (_) {
      await _setCurrencySynced(false);
      rethrow;
    }
  }

  Future<bool> isCurrencySynced() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_currencySyncedKey) ?? true;
  }

  Future<void> _setCurrencySynced(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_currencySyncedKey, value);
  }
}

@Riverpod(keepAlive: true)
SettingsSyncService settingsSyncService(Ref ref) {
  return SettingsSyncService(
    ref.watch(settingsRepositoryProvider),
    FirebaseFirestore.instance,
  );
}
