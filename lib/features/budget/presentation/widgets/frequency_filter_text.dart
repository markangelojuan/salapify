import 'package:salapify/features/budget/domain/entities/budget_filter.dart';
import 'package:salapify/l10n/app_localizations.dart';

extension FrequencyFilterText on FrequencyFilter {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
    FrequencyFilter.once => l10n.budgetFreqOnce,
    FrequencyFilter.monthly => l10n.budgetFreqRecurring,
    FrequencyFilter.firstHalf => l10n.budgetFreqFirstHalf,
    FrequencyFilter.secondHalf => l10n.budgetFreqSecondHalf,
  };
}