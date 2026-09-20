import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/transaction/data/mappers/transaction_mapper.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';

part 'transaction_repository.g.dart';

class TransactionRepository {
  TransactionRepository(this._db);

  final AppDatabase _db;

  Stream<List<TransactionEntry>> watchTransactions() {
    return (_db.select(_db.transactions)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  Future<void> addTransaction(TransactionEntry transaction) async {
    await _db.into(_db.transactions).insert(transaction.toCompanion());
  }

  Future<void> updateTransaction(TransactionEntry transaction) async {
    await _db.update(_db.transactions).replace(transaction.toCompanion());
  }

  Future<void> deleteTransaction(String id) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  Future<void> upsertTransaction(TransactionEntry transaction) async {
    await _db
        .into(_db.transactions)
        .insert(transaction.toCompanion(), mode: InsertMode.insertOrReplace);
  }

  Stream<bool> watchHasUnsynced() {
    return (_db.select(_db.transactions)
          ..where((t) => t.isSynced.equals(false)))
        .watch()
        .map((rows) => rows.isNotEmpty);
  }

  Future<void> clearAllTransactions() async {
    await _db.delete(_db.transactions).go();
  }

  Future<void> softDeleteByCategoryId(String categoryId) async {
    await (_db.update(_db.transactions)..where(
          (t) => t.categoryId.equals(categoryId) & t.isDeleted.equals(false),
        ))
        .write(
          TransactionsCompanion(
            isDeleted: const Value(true),
            updatedAt: Value(DateTime.now()),
            isSynced: const Value(false),
          ),
        );
  }

  Future<List<String>> deleteStaleAutofillTransactions({
    required BudgetingPeriod globalPeriod,
    required int firstHalfEndDay,
    required DateTime now,
  }) async {
    final rows = await (_db.select(
      _db.transactions,
    )..where((t) => t.id.like('autofill_%') & t.isDeleted.equals(false))).get();

    bool inCurrentPeriod(DateTime date) {
      if (date.year != now.year || date.month != now.month) return false;
      if (globalPeriod == BudgetingPeriod.monthly) return true;
      final isCurrentFirstHalf = now.day <= firstHalfEndDay;
      final isDateFirstHalf = date.day <= firstHalfEndDay;
      return isCurrentFirstHalf == isDateFirstHalf;
    }

    final staleIds = rows
        .where((r) => !inCurrentPeriod(r.date))
        .map((r) => r.id)
        .toList();

    if (staleIds.isEmpty) return const [];

    await (_db.delete(
      _db.transactions,
    )..where((t) => t.id.isIn(staleIds))).go();

    return staleIds;
  }
}

@Riverpod(keepAlive: true)
TransactionRepository transactionRepository(Ref ref) {
  return TransactionRepository(ref.watch(appDatabaseProvider));
}
