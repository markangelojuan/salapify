import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/transaction/domain/entities/income_source.dart';

class IncomeTotalsCalculator {
  static double totalRecurring({
    required List<IncomeSource> sources,
    required BudgetingPeriod globalPeriod,
    required int firstHalfEndDay,
  }) {
    final now = DateTime.now();
    return sources
        .where(
          (s) => s.isActiveFor(
            globalPeriod: globalPeriod,
            firstHalfEndDay: firstHalfEndDay,
            now: now,
          ),
        )
        .fold(0.0, (sum, s) => sum + s.amount);
  }
}