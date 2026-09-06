import 'package:drift/drift.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/features/transaction/domain/entities/income_source.dart';

extension IncomeSourceMapper on IncomeSourceRow {
  IncomeSource toDomain() {
    return IncomeSource(
      id: id,
      source: source,
      amount: amount,
      isRecurring: isRecurring,
      recurringDay: recurringDay,
      date: date,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
      isDeleted: isDeleted,
    );
  }
}

extension IncomeSourceCompanionMapper on IncomeSource {
  IncomeSourcesCompanion toCompanion() {
    return IncomeSourcesCompanion.insert(
      id: id,
      source: source,
      amount: amount,
      isRecurring: Value(isRecurring),
      recurringDay: Value(recurringDay),
      date: date,
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }
}