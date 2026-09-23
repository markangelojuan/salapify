import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/features/budget/data/mappers/budget_category_mapper.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/domain/entities/budget_category_type.dart';
import 'package:salapify/features/budget/domain/entities/budget_frequency.dart';

part 'budget_sync_service.g.dart';

class BudgetSyncService {
  BudgetSyncService(this._db, this._firestore);

  final AppDatabase _db;
  final FirebaseFirestore _firestore;

  // offline persistence otherwise queues the write and leaves this Future
  // pending until reconnect, blocking any await'ing caller indefinitely.
  static const _firestoreTimeout = Duration(seconds: 8);

  /// Firestore write batches are capped at 500 operations.
  static const _batchSize = 500;

  CollectionReference<Map<String, dynamic>> _remoteCollection(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('budgetCategories');
  }

  Map<String, dynamic> _toFirestoreMap(BudgetCategory category) {
    return {
      'name': category.name,
      'type': category.type.name,
      'amount': category.amount,
      'frequency': category.frequency.name,
      'period': category.period?.name,
      'iconName': category.iconName,
      'sortOrder': category.sortOrder,
      'isCompleted': category.isCompleted,
      'createdAt': Timestamp.fromDate(category.createdAt),
      'updatedAt': category.updatedAt != null
          ? Timestamp.fromDate(category.updatedAt!)
          : null,
      'isDeleted': category.isDeleted,
    };
  }

  BudgetCategory _fromFirestoreDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return BudgetCategory(
      id: doc.id,
      name: data['name'] as String,
      type: BudgetCategoryType.fromString(data['type'] as String),
      amount: (data['amount'] as num).toDouble(),
      frequency: BudgetFrequency.fromString(data['frequency'] as String),
      period: data['period'] != null
          ? BudgetPeriod.fromString(data['period'] as String)
          : null,
      iconName: data['iconName'] as String,
      sortOrder: data['sortOrder'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isSynced: true,
      isDeleted: data['isDeleted'] as bool? ?? false,
      isCompleted: data['isCompleted'] as bool? ?? false,
    );
  }

  /// Pushes a single category to Firestore, then marks it synced locally.
  ///
  /// Used for one-off pushes right after a local add/update, where a batch
  /// would be overkill (it's already a single round-trip).
  Future<void> pushCategory(String uid, BudgetCategory category) async {
    await _remoteCollection(uid)
        .doc(category.id)
        .set(_toFirestoreMap(category))
        .timeout(_firestoreTimeout);

    await (_db.update(_db.budgetCategories)
          ..where((t) => t.id.equals(category.id)))
        .write(const BudgetCategoriesCompanion(isSynced: Value(true)));
  }

  /// Pushes [categories] to Firestore in batches of up to 500 writes each.
  /// Each batch is committed as a single network round-trip, then every row
  /// in that batch is marked `isSynced: true` locally in one bulk update.
  Future<void> _pushInBatches(
    String uid,
    List<BudgetCategory> categories,
  ) async {
    for (var i = 0; i < categories.length; i += _batchSize) {
      final end = (i + _batchSize > categories.length)
          ? categories.length
          : i + _batchSize;
      final chunk = categories.sublist(i, end);

      final batch = _firestore.batch();
      for (final category in chunk) {
        batch.set(
          _remoteCollection(uid).doc(category.id),
          _toFirestoreMap(category),
        );
      }
      await batch.commit().timeout(_firestoreTimeout);

      final ids = chunk.map((c) => c.id).toList();
      await (_db.update(_db.budgetCategories)..where((t) => t.id.isIn(ids)))
          .write(const BudgetCategoriesCompanion(isSynced: Value(true)));
    }
  }

  /// Pushes all locally unsynced categories.
  Future<void> pushUnsyncedCategories(String uid) async {
    final unsynced = await (_db.select(
      _db.budgetCategories,
    )..where((t) => t.isSynced.equals(false))).get();

    if (unsynced.isEmpty) return;

    await _pushInBatches(uid, unsynced.map((row) => row.toDomain()).toList());
  }

  /// One-time migration: pushes ALL local categories (guest data) to Firestore.
  Future<void> migrateGuestDataToAccount(String uid) async {
    final allLocal = await _db.select(_db.budgetCategories).get();

    if (allLocal.isEmpty) return;

    await _pushInBatches(uid, allLocal.map((row) => row.toDomain()).toList());
  }

  /// Pulls remote categories and merges into local using last-write-wins.
  Future<void> pullRemoteCategories(String uid) async {
    final remoteSnapshot = await _remoteCollection(
      uid,
    ).get().timeout(_firestoreTimeout);
    final localRows = await _db.select(_db.budgetCategories).get();
    final localById = {for (final row in localRows) row.id: row};

    for (final doc in remoteSnapshot.docs) {
      final remote = _fromFirestoreDoc(doc);
      final local = localById[remote.id];

      if (local == null) {
        await _db
            .into(_db.budgetCategories)
            .insert(remote.toCompanion(), mode: InsertMode.insertOrReplace);
        continue;
      }

      final remoteTimestamp = remote.updatedAt ?? remote.createdAt;
      final localTimestamp = local.updatedAt ?? local.createdAt;

      if (remoteTimestamp.isAfter(localTimestamp)) {
        await _db.update(_db.budgetCategories).replace(remote.toCompanion());
      }
    }
  }


  Future<void> deleteAllRemoteCategories(String uid) async {
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
BudgetSyncService budgetSyncService(Ref ref) {
  return BudgetSyncService(
    ref.watch(appDatabaseProvider),
    FirebaseFirestore.instance,
  );
}
