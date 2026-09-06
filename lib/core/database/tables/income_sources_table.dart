import 'package:drift/drift.dart';

@DataClassName('IncomeSourceRow')
class IncomeSources extends Table {
  TextColumn get id => text()();
  TextColumn get source => text().withLength(min: 1, max: 50)();
  RealColumn get amount => real()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  IntColumn get recurringDay => integer().nullable()(); // 1–31, set only when isRecurring
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}