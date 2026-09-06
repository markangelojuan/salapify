import 'package:drift/drift.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';

extension TransactionRowMapper on TransactionRow {
  TransactionEntry toDomain() {
    return TransactionEntry(
      id: id,
      categoryId: categoryId,
      amount: amount,
      note: note,
      date: date,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
      isDeleted: isDeleted,
    );
  }
}

extension TransactionEntryCompanionMapper on TransactionEntry {
  TransactionsCompanion toCompanion() {
    return TransactionsCompanion.insert(
      id: id,
      categoryId: categoryId,
      amount: amount,
      note: Value(note),
      date: date,
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }
}