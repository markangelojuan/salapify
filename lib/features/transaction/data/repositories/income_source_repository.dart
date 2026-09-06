import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/features/transaction/data/mappers/income_source_mapper.dart';
import 'package:salapify/features/transaction/domain/entities/income_source.dart';

part 'income_source_repository.g.dart';

class IncomeSourceRepository {
  IncomeSourceRepository(this._db);

  final AppDatabase _db;

  Stream<List<IncomeSource>> watchSources() {
    return (_db.select(_db.incomeSources)
          ..where((t) => t.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  Future<void> addSource(IncomeSource source) async {
    await _db.into(_db.incomeSources).insert(source.toCompanion());
  }

  Future<void> updateSource(IncomeSource source) async {
    await _db.update(_db.incomeSources).replace(source.toCompanion());
  }

  /// Soft-deletes and marks unsynced, mirroring budget category deletes.
  Future<void> deleteSource(String id) async {
    await (_db.update(
      _db.incomeSources,
    )..where((t) => t.id.equals(id))).write(
      IncomeSourcesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  Stream<bool> watchHasUnsynced() {
    return (_db.select(_db.incomeSources)
          ..where((t) => t.isSynced.equals(false)))
        .watch()
        .map((rows) => rows.isNotEmpty);
  }

  Future<void> clearAllSources() async {
  await _db.delete(_db.incomeSources).go();
}
}

@Riverpod(keepAlive: true)
IncomeSourceRepository incomeSourceRepository(Ref ref) {
  return IncomeSourceRepository(ref.watch(appDatabaseProvider));
}