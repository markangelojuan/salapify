import 'package:salapify/features/settings/domain/budgeting_period.dart';

String computeCurrentPeriodKey({
  required BudgetingPeriod globalPeriod,
  required int firstHalfEndDay,
  required DateTime now,
}) {
  final monthPart = '${now.year}-${now.month.toString().padLeft(2, '0')}';
  if (globalPeriod == BudgetingPeriod.monthly) {
    return 'monthly-$monthPart';
  }
  final half = now.day <= firstHalfEndDay ? 'H1' : 'H2';
  return 'biMonthly-$monthPart-$half';
}
