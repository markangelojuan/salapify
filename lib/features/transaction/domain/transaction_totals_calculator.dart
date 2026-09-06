import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';

class TransactionTotalsCalculator {
  static double totalSpent({
    required List<TransactionEntry> transactions,
    required BudgetingPeriod globalPeriod,
    required int firstHalfEndDay,
  }) {
    final now = DateTime.now();
    return transactions
        .where(
          (t) =>
              !t.isDeleted &&
              _isInCurrentPeriod(
                date: t.date,
                globalPeriod: globalPeriod,
                firstHalfEndDay: firstHalfEndDay,
                now: now,
              ),
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double totalSpentForCategory({
    required List<TransactionEntry> transactions,
    required String categoryId,
    required BudgetingPeriod globalPeriod,
    required int firstHalfEndDay,
    String? excludeTransactionId,
  }) {
    final now = DateTime.now();
    return transactions
        .where(
          (t) =>
              !t.isDeleted &&
              t.categoryId == categoryId &&
              t.id != excludeTransactionId &&
              _isInCurrentPeriod(
                date: t.date,
                globalPeriod: globalPeriod,
                firstHalfEndDay: firstHalfEndDay,
                now: now,
              ),
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static bool _isInCurrentPeriod({
    required DateTime date,
    required BudgetingPeriod globalPeriod,
    required int firstHalfEndDay,
    required DateTime now,
  }) {
    if (date.year != now.year || date.month != now.month) return false;
    if (globalPeriod == BudgetingPeriod.monthly) return true;

    final isCurrentFirstHalf = now.day <= firstHalfEndDay;
    final isDateFirstHalf = date.day <= firstHalfEndDay;
    return isCurrentFirstHalf == isDateFirstHalf;
  }
}
