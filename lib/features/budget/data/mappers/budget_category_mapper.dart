import 'package:drift/drift.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/domain/entities/budget_category_type.dart';
import 'package:salapify/features/budget/domain/entities/budget_frequency.dart';

extension BudgetCategoryMapper on BudgetCategoryRow {
  BudgetCategory toDomain() {
    return BudgetCategory(
      id: id,
      name: name,
      type: BudgetCategoryType.fromString(type),
      amount: amount,
      frequency: BudgetFrequency.fromString(frequency),
      period: period != null ? BudgetPeriod.fromString(period!) : null,
      iconName: iconName,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
      isDeleted: isDeleted,
    );
  }
}

extension BudgetCategoryCompanionMapper on BudgetCategory {
  BudgetCategoriesCompanion toCompanion() {
    return BudgetCategoriesCompanion.insert(
      id: id,
      name: name,
      type: type.name,
      amount: amount,
      frequency: frequency.name,
      period: Value(period?.name),
      iconName: iconName,
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }
}