import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/domain/entities/budget_category_type.dart';
import 'package:salapify/features/budget/domain/entities/budget_frequency.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';

/// Completion status filter — single-select.
enum CompletionFilter { all, pending, completed }

/// Recurrence filter options. Which options are shown depends on the
/// user's global budgeting period (monthly vs bi-monthly) — see
/// [FrequencyFilterOptions.optionsFor].
enum FrequencyFilter { once, monthly, firstHalf, secondHalf }

extension FrequencyFilterOptions on FrequencyFilter {
  static List<FrequencyFilter> optionsFor(BudgetingPeriod period) {
    if (period == BudgetingPeriod.monthly) {
      return const [FrequencyFilter.once, FrequencyFilter.monthly];
    }
    return const [
      FrequencyFilter.once,
      FrequencyFilter.firstHalf,
      FrequencyFilter.secondHalf,
    ];
  }

  String get label {
    switch (this) {
      case FrequencyFilter.once:
        return 'One-time';
      case FrequencyFilter.monthly:
        return 'Recurring';
      case FrequencyFilter.firstHalf:
        return 'First Half';
      case FrequencyFilter.secondHalf:
        return 'Second Half';
    }
  }
}

/// Immutable, purely client-side filter state for the Budget tab.
/// Nothing here is persisted — it lives only in BudgetScreen's state and
/// resets whenever the screen is rebuilt fresh (e.g. app restart, or you
/// can choose to reset it on tab change).
class BudgetFilter {
  const BudgetFilter({
    this.completion = CompletionFilter.all,
    this.types = const {},
    this.frequencies = const {},
  });

  final CompletionFilter completion;
  final Set<BudgetCategoryType> types;
  final Set<FrequencyFilter> frequencies;

  static const empty = BudgetFilter();

  bool get isEmpty =>
      completion == CompletionFilter.all &&
      types.isEmpty &&
      frequencies.isEmpty;

  int get activeCount =>
      (completion != CompletionFilter.all ? 1 : 0) +
      types.length +
      frequencies.length;

  BudgetFilter copyWith({
    CompletionFilter? completion,
    Set<BudgetCategoryType>? types,
    Set<FrequencyFilter>? frequencies,
  }) {
    return BudgetFilter(
      completion: completion ?? this.completion,
      types: types ?? this.types,
      frequencies: frequencies ?? this.frequencies,
    );
  }
}

extension BudgetCategoryFilterMatch on BudgetCategory {
  bool matchesFrequencyFilter(FrequencyFilter filter) {
    switch (filter) {
      case FrequencyFilter.once:
        return frequency == BudgetFrequency.once;
      case FrequencyFilter.monthly:
        return frequency == BudgetFrequency.monthly;
      case FrequencyFilter.firstHalf:
        return frequency == BudgetFrequency.biMonthly &&
            (period == BudgetPeriod.firstHalf || period == BudgetPeriod.both);
      case FrequencyFilter.secondHalf:
        return frequency == BudgetFrequency.biMonthly &&
            (period == BudgetPeriod.secondHalf ||
                period == BudgetPeriod.both);
    }
  }

  bool matchesFilter(BudgetFilter filter) {
    if (filter.completion == CompletionFilter.completed && !isCompleted) {
      return false;
    }
    if (filter.completion == CompletionFilter.pending && isCompleted) {
      return false;
    }
    if (filter.types.isNotEmpty && !filter.types.contains(type)) {
      return false;
    }
    if (filter.frequencies.isNotEmpty &&
        !filter.frequencies.any(matchesFrequencyFilter)) {
      return false;
    }
    return true;
  }
}