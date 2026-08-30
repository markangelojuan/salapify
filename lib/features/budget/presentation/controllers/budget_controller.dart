import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/budget/data/repositories/budget_repository.dart';
import 'package:salapify/features/budget/data/services/budget_sync_service.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';

part 'budget_controller.g.dart';

@Riverpod(keepAlive: true)
Stream<List<BudgetCategory>> budgetCategories(Ref ref) {
  final repository = ref.watch(budgetRepositoryProvider);
  return repository.watchCategories();
}

@riverpod
class BudgetActions extends _$BudgetActions {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> _syncIfSignedIn(BudgetCategory category) async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return; // guest — local only, nothing to sync

    try {
      await ref.read(budgetSyncServiceProvider).pushCategory(uid, category);
    } catch (_) {
      // Offline or push failed — safe to ignore here. The category stays
      // isSynced = false locally and will be retried by
      // pushUnsyncedCategories on next app start / reconnect.
    }
  }

  Future<void> addCategory(BudgetCategory category) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(budgetRepositoryProvider).addCategory(category);
      await _syncIfSignedIn(category);
    });
  }

  Future<void> updateCategory(BudgetCategory category) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updated = category.copyWith(updatedAt: DateTime.now());
      await ref.read(budgetRepositoryProvider).updateCategory(updated);
      await _syncIfSignedIn(updated);
    });
  }

  Future<void> deleteCategory(BudgetCategory category) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(budgetRepositoryProvider).deleteCategory(category.id);
      // Soft-delete counts as an update — sync the isDeleted flag too.
      final deleted = category.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
      );
      await _syncIfSignedIn(deleted);
    });
  }
}