import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/settings/data/settings_repository.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';

part 'settings_controller.g.dart';

@Riverpod(keepAlive: true)
class BudgetingPeriodSetting extends _$BudgetingPeriodSetting {
  @override
  Future<BudgetingPeriod> build() {
    return ref.watch(settingsRepositoryProvider).getLocalBudgetingPeriod();
  }

  Future<void> set(BudgetingPeriod period) async {
    state = AsyncData(period);
    final repository = ref.read(settingsRepositoryProvider);
    await repository.setLocalBudgetingPeriod(period);

    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return; // guest — local only

    try {
      await repository.pushBudgetingPeriod(uid, period);
    } catch (_) {
      // Offline — local value already saved; no retry queue for this
      // single setting, user can just re-toggle later if needed.
    }
  }
}

@Riverpod(keepAlive: true)
class FirstHalfEndDaySetting extends _$FirstHalfEndDaySetting {
  @override
  Future<int> build() {
    return ref.watch(settingsRepositoryProvider).getLocalFirstHalfEndDay();
  }

  Future<void> set(int day) async {
    state = AsyncData(day);
    final repository = ref.read(settingsRepositoryProvider);
    await repository.setLocalFirstHalfEndDay(day);

    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;

    try {
      await repository.pushFirstHalfEndDay(uid, day);
    } catch (_) {
      // Same as above — no retry queue, safe to re-set later.
    }
  }
}