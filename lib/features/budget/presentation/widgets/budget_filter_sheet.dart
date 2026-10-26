import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/budget/domain/entities/budget_category_type.dart';
import 'package:salapify/features/budget/domain/entities/budget_filter.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/l10n/app_localizations.dart';
import 'package:salapify/features/budget/presentation/widgets/frequency_filter_text.dart';

Future<BudgetFilter?> showBudgetFilterSheet(
  BuildContext context, {
  required BudgetFilter current,
  required BudgetingPeriod globalPeriod,
}) {
  return showModalBottomSheet<BudgetFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) =>
        _BudgetFilterSheet(initial: current, globalPeriod: globalPeriod),
  );
}

class _BudgetFilterSheet extends StatefulWidget {
  const _BudgetFilterSheet({required this.initial, required this.globalPeriod});

  final BudgetFilter initial;
  final BudgetingPeriod globalPeriod;

  @override
  State<_BudgetFilterSheet> createState() => _BudgetFilterSheetState();
}

class _BudgetFilterSheetState extends State<_BudgetFilterSheet> {
  late CompletionFilter _completion = widget.initial.completion;
  late Set<BudgetCategoryType> _types = {...widget.initial.types};
  late Set<FrequencyFilter> _frequencies = {...widget.initial.frequencies};

  int get _activeCount =>
      (_completion != CompletionFilter.all ? 1 : 0) +
      _types.length +
      _frequencies.length;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final frequencyOptions = FrequencyFilterOptions.optionsFor(
      widget.globalPeriod,
    );

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 4),
              child: Row(
                children: [
                  Text(
                    l10n.budgetFilterTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  if (_activeCount > 0)
                    TextButton(
                      onPressed: () => setState(() {
                        _completion = CompletionFilter.all;
                        _types = {};
                        _frequencies = {};
                      }),
                      child: Text(l10n.commonClearAll),
                    ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FilterGroupLabel(l10n.budgetFilterStatus),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final option in CompletionFilter.values)
                          _FilterChip(
                            label: switch (option) {
                              CompletionFilter.all => l10n.budgetFilterAll,
                              CompletionFilter.pending =>
                                l10n.budgetFilterPending,
                              CompletionFilter.completed =>
                                l10n.budgetFilterCompleted,
                            },
                            selected: _completion == option,
                            onTap: () => setState(() => _completion = option),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _FilterGroupLabel(l10n.budgetFilterType),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final type in BudgetCategoryType.values)
                          _FilterChip(
                            label: type == BudgetCategoryType.fixed
                                ? l10n.budgetTypeFixed
                                : l10n.budgetTypeVariable,
                            selected: _types.contains(type),
                            onTap: () => setState(() {
                              if (!_types.remove(type)) _types.add(type);
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _FilterGroupLabel(l10n.budgetFilterRecurrence),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final option in frequencyOptions)
                          _FilterChip(
                            label: option.localizedLabel(l10n),
                            selected: _frequencies.contains(option),
                            onTap: () => setState(() {
                              if (!_frequencies.remove(option)) {
                                _frequencies.add(option);
                              }
                            }),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.textPrimary,
                    foregroundColor: colors.background,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(
                    context,
                    BudgetFilter(
                      completion: _completion,
                      types: _types,
                      frequencies: _frequencies,
                    ),
                  ),
                  child: Text(
                    _activeCount > 0
                        ? l10n.commonApplyCount(_activeCount)
                        : l10n.commonApply,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterGroupLabel extends StatelessWidget {
  const _FilterGroupLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.6,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: selected ? Colors.white : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
