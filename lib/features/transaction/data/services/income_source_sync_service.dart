import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/features/transaction/data/mappers/income_source_mapper.dart';
import 'package:salapify/features/transaction/domain/entities/income_source.dart';

part 'income_source_sync_service.g.dart';

class IncomeSourceSyncService {
  IncomeSourceSyncService(this._db, this._firestore);

  final AppDatabase _db;
  final FirebaseFirestore _firestore;

  static const _firestoreTimeout = Duration(seconds: 8);

  CollectionReference<Map<String, dynamic>> _remoteCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('incomeSources');
  }

  Map<String, dynamic> _toFirestoreMap(IncomeSource source) {
    return {
      'source': source.source,
      'amount': source.amount,
      'isRecurring': source.isRecurring,
      'recurringDay': source.recurringDay,
      'date': Timestamp.fromDate(source.date),
      'createdAt': Timestamp.fromDate(source.createdAt),
      'updatedAt': source.updatedAt != null
          ? Timestamp.fromDate(source.updatedAt!)
          : null,
      'isDeleted': source.isDeleted,
    };
  }

  IncomeSource _fromFirestoreDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return IncomeSource(
      id: doc.id,
      source: data['source'] as String,
      amount: (data['amount'] as num).toDouble(),
      isRecurring: data['isRecurring'] as bool? ?? false,
      recurringDay: data['recurringDay'] as int?,
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isSynced: true,
      isDeleted: data['isDeleted'] as bool? ?? false,
    );
  }

  /// Pushes a single income source to Firestore, then marks it synced locally.
  Future<void> pushSource(String uid, IncomeSource source) async {
    await _remoteCollection(uid)
        .doc(source.id)
        .set(_toFirestoreMap(source))
        .timeout(_firestoreTimeout);

    await (_db.update(_db.incomeSources)..where((t) => t.id.equals(source.id)))
        .write(const IncomeSourcesCompanion(isSynced: Value(true)));
  }

  /// Pushes all locally unsynced income sources.
  Future<void> pushUnsyncedSources(String uid) async {
    final unsynced = await (_db.select(
      _db.incomeSources,
    )..where((t) => t.isSynced.equals(false))).get();

    for (final row in unsynced) {
      await pushSource(uid, row.toDomain());
    }
  }

  /// One-time migration: pushes ALL local income sources (guest data) to Firestore.
  Future<void> migrateGuestDataToAccount(String uid) async {
    final allLocal = await _db.select(_db.incomeSources).get();

    for (final row in allLocal) {
      await pushSource(uid, row.toDomain());
    }
  }

  /// Pulls remote income sources and merges into local using last-write-wins.
  Future<void> pullRemoteSources(String uid) async {
    final remoteSnapshot = await _remoteCollection(
      uid,
    ).get().timeout(_firestoreTimeout);
    final localRows = await _db.select(_db.incomeSources).get();
    final localById = {for (final row in localRows) row.id: row};

    for (final doc in remoteSnapshot.docs) {
      final remote = _fromFirestoreDoc(doc);
      final local = localById[remote.id];

      if (local == null) {
        await _db
            .into(_db.incomeSources)
            .insert(remote.toCompanion(), mode: InsertMode.insertOrReplace);
        continue;
      }

      final remoteTimestamp = remote.updatedAt ?? remote.createdAt;
      final localTimestamp = local.updatedAt ?? local.createdAt;

      if (remoteTimestamp.isAfter(localTimestamp)) {
        await _db.update(_db.incomeSources).replace(remote.toCompanion());
      }
    }
  }
}

@Riverpod(keepAlive: true)
IncomeSourceSyncService incomeSourceSyncService(Ref ref) {
  return IncomeSourceSyncService(
    ref.watch(appDatabaseProvider),
    FirebaseFirestore.instance,
  );
}