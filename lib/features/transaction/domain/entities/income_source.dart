import 'package:salapify/features/settings/domain/budgeting_period.dart';

class IncomeSource {
  const IncomeSource({
    required this.id,
    required this.source,
    required this.amount,
    required this.isRecurring,
    this.recurringDay,
    required this.date,
    required this.createdAt,
    this.updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
  });

  final String id;
  final String source;
  final double amount;
  final bool isRecurring;
  final int? recurringDay; // 1–31, set only when isRecurring
  final DateTime date; // one-time: date it was added. recurring: informational only.
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool isDeleted;

  IncomeSource copyWith({
    String? source,
    double? amount,
    bool? isRecurring,
    int? recurringDay,
    bool clearRecurringDay = false,
    DateTime? date,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return IncomeSource(
      id: id,
      source: source ?? this.source,
      amount: amount ?? this.amount,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringDay:
          clearRecurringDay ? null : (recurringDay ?? this.recurringDay),
      date: date ?? this.date,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

bool isActiveFor({
  required BudgetingPeriod globalPeriod,
  required int firstHalfEndDay,
  required DateTime now,
}) {
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  final isMonthly = globalPeriod == BudgetingPeriod.monthly;
  final inFirstHalf = now.day <= firstHalfEndDay;

  final periodStartDay = isMonthly ? 1 : (inFirstHalf ? 1 : firstHalfEndDay + 1);
  final periodEndDay = isMonthly ? daysInMonth : (inFirstHalf ? firstHalfEndDay : daysInMonth);

  if (isRecurring) {
    final day = (recurringDay ?? 1).clamp(1, daysInMonth);
    return day >= periodStartDay && day <= periodEndDay;
  }

  return date.year == now.year &&
      date.month == now.month &&
      date.day >= periodStartDay &&
      date.day <= periodEndDay;
}
}