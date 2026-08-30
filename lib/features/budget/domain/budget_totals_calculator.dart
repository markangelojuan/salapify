import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/domain/entities/budget_frequency.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';

class BudgetTotalsCalculator {
  BudgetTotalsCalculator._();

  static double totalAllocated({
    required List<BudgetCategory> categories,
    required BudgetingPeriod globalPeriod,
    int firstHalfEndDay = 15,
    DateTime? now,
  }) {
    final active = categories.where((c) => !c.isDeleted);

    if (globalPeriod == BudgetingPeriod.monthly) {
      return active.fold(0.0, (sum, c) => sum + c.amount);
    }

    final today = now ?? DateTime.now();
    final currentHalf = today.day <= firstHalfEndDay
        ? BudgetPeriod.firstHalf
        : BudgetPeriod.secondHalf;

    return active.fold(0.0, (sum, c) {
      if (c.frequency == BudgetFrequency.once) return sum + c.amount;
      if (c.period == BudgetPeriod.both) return sum + c.amount;
      if (c.period == currentHalf) return sum + c.amount;
      return sum;
    });
  }
}