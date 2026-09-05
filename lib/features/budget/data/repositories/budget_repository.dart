import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/features/budget/data/mappers/budget_category_mapper.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/domain/entities/budget_frequency.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';

part 'budget_repository.g.dart';

class BudgetRepository {
  BudgetRepository(this._db);

  final AppDatabase _db;

  Stream<List<BudgetCategory>> watchCategories() {
    return (_db.select(_db.budgetCategories)
          ..where((t) => t.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  Future<bool> nameExists(String name, {String? excludingId}) async {
    final query = _db.select(_db.budgetCategories)
      ..where((t) => t.name.equals(name) & t.isDeleted.equals(false));
    final rows = await query.get();
    if (excludingId == null) return rows.isNotEmpty;
    return rows.any((r) => r.id != excludingId);
  }

  Future<int> _maxSortOrder() async {
    final query = _db.selectOnly(_db.budgetCategories)
      ..addColumns([_db.budgetCategories.sortOrder.max()])
      ..where(_db.budgetCategories.isDeleted.equals(false));
    final row = await query.getSingleOrNull();
    return row?.read(_db.budgetCategories.sortOrder.max()) ?? 0;
  }

  Future<void> addCategory(BudgetCategory category) async {
    final maxOrder = await _maxSortOrder();
    await _db
        .into(_db.budgetCategories)
        .insert(category.copyWith(sortOrder: maxOrder + 1).toCompanion());
  }

  Future<void> updateCategory(BudgetCategory category) async {
    await _db.update(_db.budgetCategories).replace(category.toCompanion());
  }

  /// Soft-deletes and marks the row unsynced so `pushUnsyncedCategories`
  /// will pick up the deletion on the next retry
  Future<void> deleteCategory(String id) async {
    await (_db.update(
      _db.budgetCategories,
    )..where((t) => t.id.equals(id))).write(
      BudgetCategoriesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  Future<void> clearAllCategories() async {
    await _db.delete(_db.budgetCategories).go();
  }

  Future<void> setCompleted(String id, bool isCompleted) async {
    await (_db.update(
      _db.budgetCategories,
    )..where((t) => t.id.equals(id))).write(
      BudgetCategoriesCompanion(
        isCompleted: Value(isCompleted),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  Future<void> resetAllCompleted() async {
    await (_db.update(
          _db.budgetCategories,
        )..where((t) => t.isDeleted.equals(false) & t.isCompleted.equals(true)))
        .write(
          BudgetCategoriesCompanion(
            isCompleted: const Value(false),
            updatedAt: Value(DateTime.now()),
            isSynced: const Value(false),
          ),
        );
  }

  Future<void> reorderCategories(List<String> orderedIdsInGroup) async {
    await _db.transaction(() async {
      for (var i = 0; i < orderedIdsInGroup.length; i++) {
        await (_db.update(
          _db.budgetCategories,
        )..where((t) => t.id.equals(orderedIdsInGroup[i]))).write(
          BudgetCategoriesCompanion(
            sortOrder: Value(i),
            isSynced: const Value(false),
          ),
        );
      }
    });
  }

  // Converts all active (non-deleted) categories to match [newPeriod].
  //
  // - `once`- frequency categories are left untouched
  // - monthly -> biMonthly: frequency becomes `biMonthly`, period becomes
  //   `both halves`
  // - biMonthly -> monthly: frequency becomes `monthly`, period is cleared
  //   (monthly totals ignore period entirely).
  //
  // Every converted row is marked `isSynced: false` so the existing
  // `pushUnsyncedCategories` retry mechanism (see BudgetSyncService) picks
  // them up on the next sync pass

  Future<void> convertCategoriesToPeriod(BudgetingPeriod newPeriod) async {
    final targetFrequency = newPeriod == BudgetingPeriod.monthly
        ? BudgetFrequency.monthly
        : BudgetFrequency.biMonthly;
    final targetPeriod = newPeriod == BudgetingPeriod.biMonthly
        ? BudgetPeriod.both
        : null;

    await _db.transaction(() async {
      final rows = await (_db.select(
        _db.budgetCategories,
      )..where((t) => t.isDeleted.equals(false))).get();

      final now = DateTime.now();

      for (final row in rows) {
        final currentFrequency = BudgetFrequency.fromString(row.frequency);
        if (currentFrequency == BudgetFrequency.once) continue;

        await (_db.update(
          _db.budgetCategories,
        )..where((t) => t.id.equals(row.id))).write(
          BudgetCategoriesCompanion(
            frequency: Value(targetFrequency.name),
            period: Value(targetPeriod?.name),
            updatedAt: Value(now),
            isSynced: const Value(false),
          ),
        );
      }
    });
  }

  Stream<bool> watchHasUnsynced() {
    return (_db.select(_db.budgetCategories)
          ..where((t) => t.isSynced.equals(false)))
        .watch()
        .map((rows) => rows.isNotEmpty);
  }
}

@Riverpod(keepAlive: true)
BudgetRepository budgetRepository(Ref ref) {
  return BudgetRepository(ref.watch(appDatabaseProvider));
}
