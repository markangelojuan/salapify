import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/tables/budget_categories_table.dart';
import 'package:salapify/core/database/tables/income_sources_table.dart';
import 'package:salapify/core/database/tables/transactions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [BudgetCategories, IncomeSources, Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'salapify.sqlite'));
      return NativeDatabase.createInBackground(
        file,
        setup: (db) => db.execute('PRAGMA foreign_keys = ON;'),
      );
    });
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}