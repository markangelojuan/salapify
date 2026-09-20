import 'package:drift/drift.dart';

@DataClassName('UserEntitlementRow')
class UserEntitlement extends Table {

  TextColumn get id => text()();
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();
  DateTimeColumn get premiumSince => dateTime().nullable()();
  TextColumn get premiumProductId => text().nullable()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}