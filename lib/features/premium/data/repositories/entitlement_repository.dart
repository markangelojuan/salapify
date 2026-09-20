import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';

part 'entitlement_repository.g.dart';

const _localRowId = 'local';

class EntitlementRepository {
  EntitlementRepository(this._db);
  final AppDatabase _db;

  Stream<UserEntitlementRow> watch() {
    final query = _db.select(_db.userEntitlement)
      ..where((t) => t.id.equals(_localRowId));
    return query.watchSingleOrNull().map(
      (row) => row ?? const UserEntitlementRow(id: _localRowId, isPremium: false),
    );
  }

  Future<void> setPremium({
    required bool isPremium,
    DateTime? premiumSince,
    String? productId,
  }) async {
    await _db.into(_db.userEntitlement).insertOnConflictUpdate(
      UserEntitlementCompanion(
        id: const Value(_localRowId),
        isPremium: Value(isPremium),
        premiumSince: Value(premiumSince),
        premiumProductId: Value(productId),
        lastSyncedAt: Value(DateTime.now()),
      ),
    );
  }
}

@Riverpod(keepAlive: true)
EntitlementRepository entitlementRepository(Ref ref) {
  return EntitlementRepository(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
Stream<bool> isPremium(Ref ref) {
  return ref
      .watch(entitlementRepositoryProvider)
      .watch()
      .map((row) => row.isPremium);
}