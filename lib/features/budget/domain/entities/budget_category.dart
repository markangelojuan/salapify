import 'package:salapify/features/budget/domain/entities/budget_category_type.dart';
import 'package:salapify/features/budget/domain/entities/budget_frequency.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';

class BudgetCategory {
  const BudgetCategory({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.frequency,
    this.period,
    required this.iconName,
    this.sortOrder = 0,
    required this.createdAt,
    this.updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
    this.isCompleted = false
  });

  final String id;
  final String name;
  final BudgetCategoryType type;
  final double amount;
  final BudgetFrequency frequency;
  final BudgetPeriod? period;
  final String iconName;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool isDeleted;
  final bool isCompleted;

  BudgetCategory copyWith({
    String? name,
    BudgetCategoryType? type,
    double? amount,
    BudgetFrequency? frequency,
    BudgetPeriod? period,
    String? iconName,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
    bool? isCompleted
  }) {
    return BudgetCategory(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      period: period ?? this.period,
      iconName: iconName ?? this.iconName,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      isCompleted: isCompleted ?? this.isCompleted
    );
  }
}

/// Derived activity status for a category — whether it should currently
/// count toward totals / render as active, based on frequency and dates.
extension BudgetCategoryActivity on BudgetCategory {
  bool isActiveFor({
    required BudgetingPeriod globalPeriod,
    required int firstHalfEndDay,
    required DateTime now,
  }) {
    // Recurring categories (monthly / biMonthly) never expire.
    if (frequency != BudgetFrequency.once) return true;

    if (globalPeriod == BudgetingPeriod.monthly) {
      return createdAt.year == now.year && createdAt.month == now.month;
    }

    // biMonthly
    if (createdAt.year != now.year || createdAt.month != now.month) {
      return false;
    }
    final createdHalf = createdAt.day <= firstHalfEndDay
        ? BudgetPeriod.firstHalf
        : BudgetPeriod.secondHalf;
    final nowHalf = now.day <= firstHalfEndDay
        ? BudgetPeriod.firstHalf
        : BudgetPeriod.secondHalf;
    return createdHalf == nowHalf;
  }

  bool matchesCurrentHalf({
    required int firstHalfEndDay,
    required DateTime now,
  }) {
    if (frequency != BudgetFrequency.biMonthly) {
      return true;
    } // once/monthly always current
    if (period == null || period == BudgetPeriod.both) return true;
    final nowHalf = now.day <= firstHalfEndDay
        ? BudgetPeriod.firstHalf
        : BudgetPeriod.secondHalf;
    return period == nowHalf;
  }
}
