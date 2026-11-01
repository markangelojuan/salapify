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

  /// Firestore write/delete batches are capped at 500 operations.
  static const _batchSize = 500;

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

  /// Pushes [transactions] to Firestore in batches of up to 500 writes each.
  ///
  /// Each batch is committed as a single network round-trip, then every row
  /// in that batch is marked `isSynced: true` locally in one bulk update.
  Future<void> _pushInBatches(
    String uid,
    List<TransactionEntry> transactions,
  ) async {
    for (var i = 0; i < transactions.length; i += _batchSize) {
      final end = (i + _batchSize > transactions.length)
          ? transactions.length
          : i + _batchSize;
      final chunk = transactions.sublist(i, end);

      final batch = _firestore.batch();
      for (final transaction in chunk) {
        batch.set(
          _remoteCollection(uid).doc(transaction.id),
          _toFirestoreMap(transaction),
        );
      }
      await batch.commit().timeout(_firestoreTimeout);

      final ids = chunk.map((t) => t.id).toList();
      await (_db.update(_db.transactions)..where((t) => t.id.isIn(ids))).write(
        const TransactionsCompanion(isSynced: Value(true)),
      );
    }
  }

  /// Pushes all locally unsynced transactions.
  Future<void> pushUnsyncedTransactions(String uid) async {
    final unsynced = await (_db.select(
      _db.transactions,
    )..where((t) => t.isSynced.equals(false))).get();

    if (unsynced.isEmpty) return;

    await _pushInBatches(uid, unsynced.map((row) => row.toDomain()).toList());
  }

  /// One-time migration: pushes ALL local transactions (guest data) to Firestore.
  Future<void> migrateGuestDataToAccount(String uid) async {
    final allLocal = await _db.select(_db.transactions).get();

    if (allLocal.isEmpty) return;

    await _pushInBatches(uid, allLocal.map((row) => row.toDomain()).toList());
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

  Future<void> deleteTransactionRemote(String uid, String id) async {
    await _remoteCollection(uid).doc(id).delete().timeout(_firestoreTimeout);
  }

  Future<void> purgeStaleTransactions(String uid, DateTime cutoff) async {
    final staleRows =
        await (_db.select(_db.transactions)..where(
              (t) =>
                  t.date.isSmallerThanValue(cutoff) &
                  t.isDeleted.equals(false) &
                  t.isSynced.equals(true),
            ))
            .get();

    if (staleRows.isEmpty) return;

    for (var i = 0; i < staleRows.length; i += _batchSize) {
      final end = (i + _batchSize > staleRows.length)
          ? staleRows.length
          : i + _batchSize;
      final chunk = staleRows.sublist(i, end);
      final ids = chunk.map((row) => row.id).toList();

      final batch = _firestore.batch();
      for (final id in ids) {
        batch.delete(_remoteCollection(uid).doc(id));
      }
      await batch.commit().timeout(_firestoreTimeout);

      await (_db.delete(_db.transactions)..where((t) => t.id.isIn(ids))).go();
    }
  }

  Future<void> deleteAllRemoteTransactions(String uid) async {
    final collection = _remoteCollection(uid);

    while (true) {
      final snap = await collection
          .limit(_batchSize)
          .get()
          .timeout(_firestoreTimeout);
      if (snap.docs.isEmpty) break;

      final batch = _firestore.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit().timeout(_firestoreTimeout);

      if (snap.docs.length < _batchSize) break;
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
