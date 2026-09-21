import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/services/connectivity_service.dart';
import 'package:salapify/core/widgets/global_loading.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/budget/presentation/controllers/budget_controller.dart';
import 'package:salapify/features/settings/data/repositories/settings_repository.dart';
import 'package:salapify/features/settings/data/services/settings_sync_service.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/domain/period_key.dart';
import 'package:salapify/features/settings/domain/currency.dart';
import 'package:salapify/core/services/push_notification_service.dart';

part 'settings_controller.g.dart';

@Riverpod(keepAlive: true)
class SettingsSyncWarning extends _$SettingsSyncWarning {
  @override
  String? build() => null;

  void set(String? message) => state = message;
}

@Riverpod(keepAlive: true)
class BudgetingPeriodSetting extends _$BudgetingPeriodSetting {
  @override
  Future<BudgetingPeriod> build() {
    return ref.watch(settingsRepositoryProvider).getLocalBudgetingPeriod();
  }

  bool get _isOnline => ref.read(isOnlineProvider).value ?? true;

  Future<void> set(BudgetingPeriod period) async {
    final previous = state;
    // ignore: invalid_use_of_internal_member
    state = const AsyncLoading<BudgetingPeriod>().copyWithPrevious(
      previous,
      isRefresh: true,
    );

    try {
      // Only the local migration sits behind the blocking overlay. The
      // Firestore push further down stays outside it, so a slow network can
      // never keep the whole app frozen.
      await ref.read(globalLoadingProvider.notifier).run(
        'Converting your categories…',
        () async {
          await ref
              .read(budgetActionsProvider.notifier)
              .convertCategoriesForPeriodChange(period);

          final repository = ref.read(settingsRepositoryProvider);
          await repository.setLocalBudgetingPeriod(period);

          final firstHalfEndDay =
              ref.read(firstHalfEndDaySettingProvider).value ?? 15;
          final newKey = computeCurrentPeriodKey(
            globalPeriod: period,
            firstHalfEndDay: firstHalfEndDay,
            now: DateTime.now(),
          );
          await repository.setLastResetPeriodKey(newKey);
        },
      );

      state = AsyncData(period);

      final uid = ref.read(currentUserProvider)?.uid;
      if (uid == null || !_isOnline)
        return; // guest, or offline — synced on reconnect

      try {
        await ref
            .read(settingsSyncServiceProvider)
            .pushBudgetingPeriod(uid, period);
      } catch (e) {
        _warnIfRealError(
          e,
          fallback:
              "Budgeting period saved on this device, but couldn't sync to your account.",
        );
      }
    } catch (e, st) {
      // ignore: invalid_use_of_internal_member
      state = AsyncError<BudgetingPeriod>(e, st).copyWithPrevious(previous);
    }
  }

  void _warnIfRealError(Object e, {required String fallback}) {
    if (!_isOnline || e is TimeoutException) return;
    // Online but still failed - a real error
    ref.read(settingsSyncWarningProvider.notifier).set(fallback);
  }
}

@Riverpod(keepAlive: true)
class FirstHalfEndDaySetting extends _$FirstHalfEndDaySetting {
  @override
  Future<int> build() {
    return ref.watch(settingsRepositoryProvider).getLocalFirstHalfEndDay();
  }

  bool get _isOnline => ref.read(isOnlineProvider).value ?? true;

  Future<void> set(int day) async {
    final previous = state;
    state = AsyncData(day);
    final repository = ref.read(settingsRepositoryProvider);

    try {
      await repository.setLocalFirstHalfEndDay(day);
    } catch (e, st) {
      // ignore: invalid_use_of_internal_member
      state = AsyncError<int>(e, st).copyWithPrevious(previous);
      return;
    }

    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null || !_isOnline) return;

    try {
      await ref.read(settingsSyncServiceProvider).pushFirstHalfEndDay(uid, day);
    } catch (e) {
      _warnIfRealError(
        e,
        fallback:
            "Setting saved on this device, but couldn't sync to your account.",
      );
    }
  }

  void _warnIfRealError(Object e, {required String fallback}) {
    if (!_isOnline || e is TimeoutException) return;
    ref.read(settingsSyncWarningProvider.notifier).set(fallback);
  }
}

@Riverpod(keepAlive: true)
class CurrencySetting extends _$CurrencySetting {
  @override
  Future<AppCurrency> build() {
    return ref.watch(settingsRepositoryProvider).getLocalCurrency();
  }

  bool get _isOnline => ref.read(isOnlineProvider).value ?? true;

  Future<void> set(AppCurrency currency) async {
    final previous = state;
    state = AsyncData(currency);
    final repository = ref.read(settingsRepositoryProvider);

    try {
      await repository.setLocalCurrency(currency);
    } catch (e, st) {
      // ignore: invalid_use_of_internal_member
      state = AsyncError<AppCurrency>(e, st).copyWithPrevious(previous);
      return;
    }

    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null || !_isOnline) return;

    try {
      await ref.read(settingsSyncServiceProvider).pushCurrency(uid, currency);
    } catch (e) {
      _warnIfRealError(
        e,
        fallback:
            "Currency saved on this device, but couldn't sync to your account.",
      );
    }
  }

  void _warnIfRealError(Object e, {required String fallback}) {
    if (!_isOnline || e is TimeoutException) return;
    ref.read(settingsSyncWarningProvider.notifier).set(fallback);
  }
}

@Riverpod(keepAlive: true)
class ReminderNotificationsSetting extends _$ReminderNotificationsSetting {
  @override
  Future<bool> build() {
    return ref.watch(settingsRepositoryProvider).getLocalRemindersEnabled();
  }

  Future<void> set(bool enabled) async {
    final previous = state;
    final pushService = ref.read(pushNotificationServiceProvider);

    if (enabled) {
      final granted = await pushService.requestLocalNotificationPermission();
      if (!granted) {
        // Leave the switch as it was; don't persist "enabled" if the
        // user denied the OS prompt.
        state = previous;
        return;
      }
    }

    state = AsyncData(enabled);

    try {
      await ref
          .read(settingsRepositoryProvider)
          .setLocalRemindersEnabled(enabled);

      if (enabled) {
        await pushService.scheduleMonthlyReminders();
      } else {
        await pushService.cancelMonthlyReminders();
      }
    } catch (e, st) {
      // ignore: invalid_use_of_internal_member
      state = AsyncError<bool>(e, st).copyWithPrevious(previous);
    }
  }
}
