import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/authentication/presentation/controllers/app_user_controller.dart';
import 'package:salapify/features/settings/data/repositories/settings_repository.dart';
import 'package:salapify/features/settings/data/services/settings_sync_service.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/domain/currency.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';

part 'preferences_controller.g.dart';

/// Commits the first-time preferences (budgeting period, first-half end day,
/// currency) and flags the user's profile as onboarded.
@riverpod
class PreferencesController extends _$PreferencesController {
  @override
  FutureOr<void> build() => null;

  Future<void> complete({
    required BudgetingPeriod period,
    required int firstHalfEndDay,
    required AppCurrency currency,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authRepositoryProvider).currentUser!.uid;

      // 1. Day BEFORE period: BudgetingPeriodSetting.set() reads the day to
      //    compute lastResetPeriodKey.
      await ref
          .read(firstHalfEndDaySettingProvider.notifier)
          .set(firstHalfEndDay);
      _throwIfError(firstHalfEndDaySettingProvider);

      // 2. Period. Only go through set() when it actually changes (it runs
      //    the category conversion behind the loading overlay). If it's
      //    unchanged we still need it in Firestore, so push it directly.
      final localPeriod = await ref
          .read(settingsRepositoryProvider)
          .getLocalBudgetingPeriod(uid);
      if (localPeriod != period) {
        await ref.read(budgetingPeriodSettingProvider.notifier).set(period);
        _throwIfError(budgetingPeriodSettingProvider);
      } else {
        try {
          await ref
              .read(settingsSyncServiceProvider)
              .pushBudgetingPeriod(uid, period);
        } catch (_) {
          // Sync flag is left "unsynced"; retryPendingSettingsSync handles it.
        }
      }

      // 3. Currency.
      await ref.read(currencySettingProvider.notifier).set(currency);
      _throwIfError(currencySettingProvider);

      // 4. Only after local writes succeeded, mark setup complete.
      await ref.read(userRepositoryProvider).markPreferencesCompleted(uid);

      // Router listens to currentAppUserProvider and will redirect to /home.
      ref.invalidate(currentAppUserProvider);
      await ref.read(currentAppUserProvider.future);
    });
  }

  /// "Use defaults": commits whatever is currently stored locally
  /// (monthly / day 15 / PHP for a brand-new install).
  Future<void> skip() async {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    final repo = ref.read(settingsRepositoryProvider);
    await complete(
      period: await repo.getLocalBudgetingPeriod(uid),
      firstHalfEndDay: await repo.getLocalFirstHalfEndDay(uid),
      currency: await repo.getLocalCurrency(),
    );
  }

  /// The settings notifiers swallow failures into their own AsyncError state
  /// instead of throwing, so surface them here so `guard` can catch them.
  void _throwIfError(ProviderListenable<AsyncValue<Object?>> provider) {
    final value = ref.read(provider);
    if (value.hasError) throw value.error!;
  }
}