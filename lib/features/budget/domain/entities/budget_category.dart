import 'package:salapify/features/budget/domain/entities/budget_category_type.dart';
import 'package:salapify/features/budget/domain/entities/budget_frequency.dart';

class BudgetCategory {
  const BudgetCategory({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.frequency,
    this.period,
    required this.iconName,
    required this.createdAt,
    this.updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
  });

  final String id;
  final String name;
  final BudgetCategoryType type;
  final double amount;
  final BudgetFrequency frequency;
  final BudgetPeriod? period;
  final String iconName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool isDeleted;

  BudgetCategory copyWith({
    String? name,
    BudgetCategoryType? type,
    double? amount,
    BudgetFrequency? frequency,
    BudgetPeriod? period,
    String? iconName,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return BudgetCategory(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      period: period ?? this.period,
      iconName: iconName ?? this.iconName,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}