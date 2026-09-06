import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/features/transaction/data/mappers/transaction_mapper.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';

part 'transaction_sync_service.g.dart';

class TransactionSyncService {
  TransactionSyncService(this._db, this._firestore);

  final AppDatabase _db;
  final FirebaseFirestore _firestore;

  static const _firestoreTimeout = Duration(seconds: 8);

  CollectionReference<Map<String, dynamic>> _remoteCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('transactions');
  }

  Map<String, dynamic> _toFirestoreMap(TransactionEntry transaction) {
    return {
      'categoryId': transaction.categoryId,
      'amount': transaction.amount,
      'note': transaction.note,
      'date': Timestamp.fromDate(transaction.date),
      'createdAt': Timestamp.fromDate(transaction.createdAt),
      'updatedAt': transaction.updatedAt != null
          ? Timestamp.fromDate(transaction.updatedAt!)
          : null,
      'isDeleted': transaction.isDeleted,
    };
  }

  TransactionEntry _fromFirestoreDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return TransactionEntry(
      id: doc.id,
      categoryId: data['categoryId'] as String,
      amount: (data['amount'] as num).toDouble(),
      note: data['note'] as String?,
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isSynced: true,
      isDeleted: data['isDeleted'] as bool? ?? false,
    );
  }

  /// Pushes a single transaction to Firestore, then marks it synced locally.
  Future<void> pushTransaction(String uid, TransactionEntry transaction) async {
    await _remoteCollection(uid)
        .doc(transaction.id)
        .set(_toFirestoreMap(transaction))
        .timeout(_firestoreTimeout);

    await (_db.update(_db.transactions)
          ..where((t) => t.id.equals(transaction.id)))
        .write(const TransactionsCompanion(isSynced: Value(true)));
  }

  /// Pushes all locally unsynced transactions.
  Future<void> pushUnsyncedTransactions(String uid) async {
    final unsynced = await (_db.select(
      _db.transactions,
    )..where((t) => t.isSynced.equals(false))).get();

    for (final row in unsynced) {
      await pushTransaction(uid, row.toDomain());
    }
  }

  /// One-time migration: pushes ALL local transactions (guest data) to Firestore.
  Future<void> migrateGuestDataToAccount(String uid) async {
    final allLocal = await _db.select(_db.transactions).get();

    for (final row in allLocal) {
      await pushTransaction(uid, row.toDomain());
    }
  }

  /// Pulls remote transactions and merges into local using last-write-wins.
  Future<void> pullRemoteTransactions(String uid) async {
    final remoteSnapshot = await _remoteCollection(
      uid,
    ).get().timeout(_firestoreTimeout);
    final localRows = await _db.select(_db.transactions).get();
    final localById = {for (final row in localRows) row.id: row};

    for (final doc in remoteSnapshot.docs) {
      final remote = _fromFirestoreDoc(doc);
      final local = localById[remote.id];

      if (local == null) {
        await _db
            .into(_db.transactions)
            .insert(remote.toCompanion(), mode: InsertMode.insertOrReplace);
        continue;
      }

      final remoteTimestamp = remote.updatedAt ?? remote.createdAt;
      final localTimestamp = local.updatedAt ?? local.createdAt;

      if (remoteTimestamp.isAfter(localTimestamp)) {
        await _db.update(_db.transactions).replace(remote.toCompanion());
      }
    }
  }
}

@Riverpod(keepAlive: true)
TransactionSyncService transactionSyncService(Ref ref) {
  return TransactionSyncService(
    ref.watch(appDatabaseProvider),
    FirebaseFirestore.instance,
  );
}