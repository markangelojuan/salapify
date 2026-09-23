import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/transaction/domain/entities/income_period.dart';

class IncomeSource {
  const IncomeSource({
    required this.id,
    required this.source,
    required this.amount,
    required this.isRecurring,
    this.recurringDay,
    this.period = IncomePeriod.both,
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
  final int? recurringDay; // cosmetic label only, never used for counting
  final IncomePeriod
  period; // currently always 'both' — reserved for a future advanced option
  final DateTime date;
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
    IncomePeriod? period,
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
      recurringDay: clearRecurringDay
          ? null
          : (recurringDay ?? this.recurringDay),
      period: period ?? this.period,
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
    if (!isRecurring) {
      // One-time: counted for the whole month it happened in, both halves
      // if biMonthly. Naturally stops counting once the month changes —
      // no explicit "reset" needed since it's checked against the current
      // year/month every time.
      return date.year == now.year && date.month == now.month;
    }

    // Recurring: counted every period regardless of recurringDay.
    // `period` stays as a hook for a possible future "1st/2nd half only"
    // option, but every entry defaults to `both`, so today this is
    // effectively unconditional — matching monthly behavior exactly.
    if (globalPeriod == BudgetingPeriod.monthly) return true;

    final inFirstHalf = now.day <= firstHalfEndDay;
    if (period == IncomePeriod.both) return true;
    if (period == IncomePeriod.firstHalf) return inFirstHalf;
    return !inFirstHalf; // secondHalf
  }
}
