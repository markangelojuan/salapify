import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/core/services/connectivity_service.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/budget/data/repositories/budget_repository.dart';
import 'package:salapify/features/budget/data/services/budget_sync_service.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/domain/period_key.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/settings/data/repositories/settings_repository.dart';
import 'package:salapify/features/transaction/data/repositories/transaction_repository.dart';
import 'package:salapify/features/transaction/data/services/transaction_sync_service.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';
import 'package:salapify/features/transaction/domain/transaction_totals_calculator.dart';
import 'package:salapify/features/transaction/presentation/controllers/transaction_controller.dart';

part 'budget_controller.g.dart';

@Riverpod(keepAlive: true)
Stream<List<BudgetCategory>> budgetCategories(Ref ref) {
  final repository = ref.watch(budgetRepositoryProvider);
  return repository.watchCategories();
}

@riverpod
Stream<bool> hasUnsyncedCategories(Ref ref) {
  final repository = ref.watch(budgetRepositoryProvider);
  return repository.watchHasUnsynced();
}

@Riverpod(keepAlive: true)
class PeriodResetGuard extends _$PeriodResetGuard {
  @override
  Future<void> build() async {
    final globalPeriod = await ref.watch(budgetingPeriodSettingProvider.future);
    final firstHalfEndDay = await ref.watch(
      firstHalfEndDaySettingProvider.future,
    );
    final settingsRepo = ref.read(settingsRepositoryProvider);

    final currentKey = computeCurrentPeriodKey(
      globalPeriod: globalPeriod,
      firstHalfEndDay: firstHalfEndDay,
      now: DateTime.now(),
    );

    final lastKey = await settingsRepo.getLastResetPeriodKey();

    if (lastKey != currentKey) {
      await ref.read(budgetRepositoryProvider).resetAllCompleted();
      await settingsRepo.setLastResetPeriodKey(currentKey);
    }
  }
}

@Riverpod(keepAlive: true)
class BudgetActions extends _$BudgetActions {
  @override
  FutureOr<void> build() {
    return null;
  }

  bool get _isOnline => ref.read(isOnlineProvider).value ?? true;

  Future<void> _syncIfSignedIn(BudgetCategory category) async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return; // guest — local only, nothing to sync
    if (!_isOnline) return; // offline — SyncTrigger picks it up on reconnect

    try {
      await ref.read(budgetSyncServiceProvider).pushCategory(uid, category);
    } catch (e) {
      _logIfRealError(e, context: 'syncIfSignedIn');
    }
  }

  void _logIfRealError(Object e, {required String context}) {
    final isOnline = ref.read(isOnlineProvider).value ?? true;
    if (!isOnline) {
      return; // expected — offline, will retry via pushUnsyncedCategories
    }
    // FirebaseCrashlytics.instance.recordError(e, StackTrace.current, reason: context);
  }

  Future<void> addCategory(BudgetCategory category) async {
    final result = await AsyncValue.guard(() async {
      await ref.read(budgetRepositoryProvider).addCategory(category);
      await _syncIfSignedIn(category);
    });
    state = result;
  }

  Future<void> updateCategory(BudgetCategory category) async {
    final result = await AsyncValue.guard(() async {
      final updated = category.copyWith(updatedAt: DateTime.now());
      await ref.read(budgetRepositoryProvider).updateCategory(updated);
      await _syncIfSignedIn(updated);
    });
    state = result;
  }

  Future<void> deleteCategory(BudgetCategory category) async {
    final result = await AsyncValue.guard(() async {
      await ref.read(appDatabaseProvider).transaction(() async {
        await ref
            .read(transactionRepositoryProvider)
            .softDeleteByCategoryId(category.id);
        await ref.read(budgetRepositoryProvider).deleteCategory(category.id);
      });

      final deleted = category.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
      );
      await _syncIfSignedIn(deleted); // already guarded above

      final uid = ref.read(currentUserProvider)?.uid;
      if (uid != null && _isOnline) {
        try {
          await ref
              .read(transactionSyncServiceProvider)
              .pushUnsyncedTransactions(uid);
        } catch (e) {
          _logIfRealError(e, context: 'deleteCategory.pushTransactions');
        }
      }
    });
    state = result;
  }

  Future<void> setCompleted(BudgetCategory category, bool isCompleted) async {
    final result = await AsyncValue.guard(() async {
      final globalPeriod =
          ref.read(budgetingPeriodSettingProvider).value ??
          BudgetingPeriod.monthly;
      final firstHalfEndDay =
          ref.read(firstHalfEndDaySettingProvider).value ?? 15;
      final now = DateTime.now();
      final periodKey = computeCurrentPeriodKey(
        globalPeriod: globalPeriod,
        firstHalfEndDay: firstHalfEndDay,
        now: now,
      );
      final autoFillId = 'autofill_${category.id}_$periodKey';
      final transactionRepo = ref.read(transactionRepositoryProvider);

      await ref.read(appDatabaseProvider).transaction(() async {
        await ref
            .read(budgetRepositoryProvider)
            .setCompleted(category.id, isCompleted);

        if (isCompleted) {
          final transactions = ref.read(transactionsProvider).value ?? [];
          final alreadySpent =
              TransactionTotalsCalculator.totalSpentForCategory(
                transactions: transactions,
                categoryId: category.id,
                globalPeriod: globalPeriod,
                firstHalfEndDay: firstHalfEndDay,
                excludeTransactionId: autoFillId,
              );
          final remaining = (category.amount - alreadySpent).clamp(
            0,
            double.infinity,
          );

          if (remaining > 0) {
            await transactionRepo.upsertTransaction(
              TransactionEntry(
                id: autoFillId,
                categoryId: category.id,
                amount: remaining.toDouble(),
                note: 'Remaining budget (auto)',
                date: now,
                createdAt: now,
              ),
            );
          }
        } else {
          await transactionRepo.deleteTransaction(autoFillId);
        }
      });

      final uid = ref.read(currentUserProvider)?.uid;
      if (uid == null || !_isOnline) return;
      try {
        await ref.read(budgetSyncServiceProvider).pushUnsyncedCategories(uid);
        await ref
            .read(transactionSyncServiceProvider)
            .pushUnsyncedTransactions(uid);
      } catch (e) {
        _logIfRealError(e, context: 'setCompleted');
      }
    });
    state = result;
  }

  Future<void> reorderCategories(List<String> orderedIdsInGroup) async {
    final result = await AsyncValue.guard(() async {
      await ref
          .read(budgetRepositoryProvider)
          .reorderCategories(orderedIdsInGroup);

      final uid = ref.read(currentUserProvider)?.uid;
      if (uid == null || !_isOnline) return;
      try {
        await ref.read(budgetSyncServiceProvider).pushUnsyncedCategories(uid);
      } catch (e) {
        _logIfRealError(e, context: 'reorderCategories');
      }
    });
    state = result;
  }

  /// Bulk-converts all active categories to match a new global budgeting
  /// period. Called from BudgetingPeriodSetting.set() before the period
  /// setting itself is persisted, so category data and period setting never
  /// briefly disagree from the UI's perspective.
  Future<void> convertCategoriesForPeriodChange(
    BudgetingPeriod newPeriod,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(budgetRepositoryProvider)
          .convertCategoriesToPeriod(newPeriod);

      final uid = ref.read(currentUserProvider)?.uid;
      if (uid == null || !_isOnline) return;

      try {
        await ref.read(budgetSyncServiceProvider).pushUnsyncedCategories(uid);
      } catch (e) {
        _logIfRealError(e, context: 'convertCategoriesForPeriodChange');
      }
    });
  }
}
