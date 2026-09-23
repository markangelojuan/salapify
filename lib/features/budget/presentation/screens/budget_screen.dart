import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/budget/domain/budget_totals_calculator.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/presentation/controllers/budget_controller.dart';
import 'package:salapify/features/budget/domain/entities/budget_filter.dart';
import 'package:salapify/features/budget/presentation/widgets/budget_filter_sheet.dart';
import 'package:salapify/features/budget/presentation/widgets/budget_summary_card.dart';
import 'package:salapify/features/budget/presentation/widgets/category_card.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/transaction/domain/transaction_totals_calculator.dart';
import 'package:salapify/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/router/routes.dart';
import 'package:lottie/lottie.dart';
import 'package:salapify/core/layout/breakpoints.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  // client state only
  BudgetFilter _filter = BudgetFilter.empty;

  Future<void> _openFilterSheet(BudgetingPeriod globalPeriod) async {
    final result = await showBudgetFilterSheet(
      context,
      current: _filter,
      globalPeriod: globalPeriod,
    );
    if (result != null) {
      setState(() => _filter = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(budgetActionsProvider, (previous, next) {
      if (next.hasError) {
        CommonSnackbar.showError(context, next.error!);
      }
    });
    final resetGuard = ref.watch(periodResetGuardProvider);
    ref.listen<AsyncValue<void>>(periodResetGuardProvider, (previous, next) {
      if (next.hasError) {
        CommonSnackbar.showError(context, next.error!);
      }
    });
    if (resetGuard.isLoading && !resetGuard.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    final categoriesAsync = ref.watch(budgetCategoriesProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final globalPeriod =
        ref.watch(budgetingPeriodSettingProvider).value ??
        BudgetingPeriod.monthly;
    final firstHalfEndDay =
        ref.watch(firstHalfEndDaySettingProvider).value ?? 15;

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Failed to load categories: $err')),
      data: (categories) {
        // Totals are ALWAYS computed from the unfiltered category/transaction
        // lists — the filter only affects which cards are shown below.
        final totalAllocated = BudgetTotalsCalculator.totalAllocated(
          categories: categories,
          globalPeriod: globalPeriod,
          firstHalfEndDay: firstHalfEndDay,
        );
        final totalSpent = TransactionTotalsCalculator.totalSpent(
          transactions: transactionsAsync.value ?? [],
          globalPeriod: globalPeriod,
          firstHalfEndDay: firstHalfEndDay,
        );

        final now = DateTime.now();
        final activeCategories = categories
            .where(
              (c) =>
                  !c.isDeleted &&
                  c.isActiveFor(
                    globalPeriod: globalPeriod,
                    firstHalfEndDay: firstHalfEndDay,
                    now: now,
                  ),
            )
            .toList();

        final filteredCategories = activeCategories
            .where((c) => c.matchesFilter(_filter))
            .toList();

        final grouped = _groupCategories(
          categories: filteredCategories,
          globalPeriod: globalPeriod,
          firstHalfEndDay: firstHalfEndDay,
          now: now,
        );

        final hasAnyCategories = activeCategories.isNotEmpty;
        final hasFilteredResults =
            grouped.current.isNotEmpty || grouped.other.isNotEmpty;

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: SizedBox(
                        width: double.infinity,
                        child: BudgetSummaryCard(
                          totalSpent: totalSpent,
                          totalAllocated: totalAllocated,
                          period: globalPeriod,
                          firstHalfEndDay: firstHalfEndDay,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (hasAnyCategories)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FilterBar(
                          activeCount: _filter.activeCount,
                          onTap: () => _openFilterSheet(globalPeriod),
                        ),
                        if (!_filter.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'Clear filters to reorder categories',
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.45),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              if (!hasAnyCategories)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Transform.translate(
                    offset: const Offset(0, -60),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/lottie/sleeping_squirrel.json',
                            width: 180,
                            height: 180,
                          ),
                          Text(
                            'No categories yet',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (!hasFilteredResults)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _FilteredEmptyState(
                    onClearFilters: () =>
                        setState(() => _filter = BudgetFilter.empty),
                  ),
                )
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: _ReorderableCategoryGrid(
                      key: const ValueKey('current-grid'),
                      categories: grouped.current,
                      dimmed: false,
                      reorderEnabled: _filter.isEmpty,
                    ),
                  ),
                ),
                if (grouped.other.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          _ReorderableCategoryGrid(
                            key: ValueKey(
                              'other-${grouped.other.map((c) => c.id).join()}',
                            ),
                            categories: grouped.other,
                            dimmed: true,
                            reorderEnabled: _filter.isEmpty,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }

  /// Splits an already-filtered list of active categories into the current
  /// half/period and "other" (opposite bi-monthly half), same grouping
  /// logic as before — the filter is applied upstream in [build].
  _GroupedCategories _groupCategories({
    required List<BudgetCategory> categories,
    required BudgetingPeriod globalPeriod,
    required int firstHalfEndDay,
    required DateTime now,
  }) {
    int cardComparator(BudgetCategory a, BudgetCategory b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return a.sortOrder.compareTo(b.sortOrder);
    }

    if (globalPeriod == BudgetingPeriod.monthly) {
      final sorted = categories.toList()..sort(cardComparator);
      return _GroupedCategories(current: sorted, other: const []);
    }

    final current = <BudgetCategory>[];
    final other = <BudgetCategory>[];

    for (final c in categories) {
      if (c.matchesCurrentHalf(firstHalfEndDay: firstHalfEndDay, now: now)) {
        current.add(c);
      } else {
        other.add(c);
      }
    }

    current.sort(cardComparator);
    other.sort(cardComparator);

    return _GroupedCategories(current: current, other: other);
  }
}

class _GroupedCategories {
  const _GroupedCategories({required this.current, required this.other});
  final List<BudgetCategory> current;
  final List<BudgetCategory> other;
}

/// Compact pill trigger that opens the filter sheet, with a badge showing
/// how many filters are currently active.
class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.activeCount, required this.onTap});

  final int activeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final active = activeCount > 0;

    return Row(
      children: [
        Icon(Icons.category_rounded, size: 15, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          'ALLOCATIONS',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.6,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: active
                  ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune_rounded,
                  size: 15,
                  color: active
                      ? AppColors.primary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  active ? 'Filters ($activeCount)' : 'Filter',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    color: active
                        ? AppColors.primary
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Shown when categories exist but none match the active filter
class _FilteredEmptyState extends StatelessWidget {
  const _FilteredEmptyState({required this.onClearFilters});

  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Transform.translate(
      offset: const Offset(0, -40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_off_rounded,
              size: 40,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No categories match your filters',
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onClearFilters,
              child: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReorderableCategoryGrid extends ConsumerWidget {
  const _ReorderableCategoryGrid({
    super.key,
    required this.categories,
    required this.dimmed,
    this.reorderEnabled = true,
  });

  final List<BudgetCategory> categories;
  final bool dimmed;

  final bool reorderEnabled;

  double _mainAxisExtentFor(BuildContext context) {

  return 170;
}

  int _crossAxisCountFor(BuildContext context) {
    if (context.isExpanded) return 4;
    if (context.isMedium) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: _crossAxisCountFor(context),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      mainAxisExtent: _mainAxisExtentFor(context),
    );

    final children = categories
        .map(
          (category) => Opacity(
            key: Key(category.id),
            opacity: dimmed ? 0.5 : 1.0,
            child: CategoryCard(
              category: category,
              onTap: () => context.pushNamed(
                AppRoutes.categoryForm.name,
                extra: category,
              ),
              onToggleComplete: (value) => ref
                  .read(budgetActionsProvider.notifier)
                  .setCompleted(category, value),
            ),
          ),
        )
        .toList();

    if (!reorderEnabled) {
      return GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: gridDelegate,
        children: children,
      );
    }

    return ReorderableBuilder(
      onReorder: (ReorderedListFunction reorderedListFunction) {
        final reordered =
            reorderedListFunction(categories) as List<BudgetCategory>;
        ref
            .read(budgetActionsProvider.notifier)
            .reorderCategories(reordered.map((c) => c.id).toList());
      },
      dragChildBoxDecoration: const BoxDecoration(),
      builder: (reorderedChildren) {
        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: gridDelegate,
          children: reorderedChildren,
        );
      },
      children: children,
    );
  }
}
