import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/features/budget/data/mappers/budget_category_mapper.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/domain/entities/budget_category_type.dart';
import 'package:salapify/features/budget/domain/entities/budget_frequency.dart';
import 'package:flutter/foundation.dart';

part 'budget_sync_service.g.dart';

class BudgetSyncService {
  BudgetSyncService(this._db, this._firestore);

  final AppDatabase _db;
  final FirebaseFirestore _firestore;

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
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isSynced: true, // came from remote, so it's synced by definition
      isDeleted: data['isDeleted'] as bool? ?? false,
    );
  }

  /// Pushes a single category to Firestore, then marks it synced locally.
  /// Call this after every local write (add/update/delete) when signed in.
  Future<void> pushCategory(String uid, BudgetCategory category) async {
    await _remoteCollection(
      uid,
    ).doc(category.id).set(_toFirestoreMap(category));

    await (_db.update(_db.budgetCategories)
          ..where((t) => t.id.equals(category.id)))
        .write(const BudgetCategoriesCompanion(isSynced: Value(true)));
  }

  /// Pushes all locally unsynced categories. Call on app start and whenever
  /// connectivity is restored, to catch up on writes that failed while offline.
  Future<void> pushUnsyncedCategories(String uid) async {
    final unsynced = await (_db.select(
      _db.budgetCategories,
    )..where((t) => t.isSynced.equals(false))).get();

    for (final row in unsynced) {
      await pushCategory(uid, row.toDomain());
    }
  }

  /// One-time migration: pushes ALL local categories (guest data) to Firestore
  /// under the newly created/signed-into uid. Duplicate names (if the account
  /// already has a matching category) are allowed through intentionally —
  /// the user can review and delete whichever one is wrong from the UI.
  /// Must run BEFORE pullRemoteCategories, or an empty remote collection
  /// would wipe local guest data on pull.
  Future<void> migrateGuestDataToAccount(String uid) async {
    final allLocal = await _db.select(_db.budgetCategories).get();

    for (final row in allLocal) {
      await pushCategory(uid, row.toDomain());
    }
  }

  /// Pulls remote categories and merges into local using last-write-wins
  /// (by updatedAt, falling back to createdAt if updatedAt is null).
  /// Call after sign-in (after migration, if any) and periodically after.
  Future<void> pullRemoteCategories(String uid) async {
    final remoteSnapshot = await _remoteCollection(uid).get();
    final localRows = await _db.select(_db.budgetCategories).get();
    final localById = {for (final row in localRows) row.id: row};

    for (final doc in remoteSnapshot.docs) {
      final remote = _fromFirestoreDoc(doc);
      final local = localById[remote.id];

      if (local == null) {
        // Exists remotely but not locally (e.g. another device created it) — insert.
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
      // else: local is newer or equal — keep local, it'll get pushed by
      // pushUnsyncedCategories if it hasn't been synced yet.
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
