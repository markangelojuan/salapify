import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/features/budget/data/mappers/budget_category_mapper.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';

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

  Future<void> addCategory(BudgetCategory category) async {
    final exists = await nameExists(category.name);
    if (exists) {
      throw StateError('Category name "${category.name}" already exists');
    }
    await _db.into(_db.budgetCategories).insert(category.toCompanion());
  }

  Future<void> updateCategory(BudgetCategory category) async {
    final exists = await nameExists(category.name, excludingId: category.id);
    if (exists) {
      throw StateError('Category name "${category.name}" already exists');
    }
    await _db.update(_db.budgetCategories).replace(category.toCompanion());
  }

  Future<void> deleteCategory(String id) async {
    await (_db.update(_db.budgetCategories)..where((t) => t.id.equals(id)))
        .write(const BudgetCategoriesCompanion(isDeleted: Value(true)));
  }

  Future<void> clearAllCategories() async {
    await _db.delete(_db.budgetCategories).go();
  }
}

@Riverpod(keepAlive: true)
BudgetRepository budgetRepository(Ref ref) {
  return BudgetRepository(ref.watch(appDatabaseProvider));
}
