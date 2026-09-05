import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/services/connectivity_service.dart';
import 'package:salapify/features/budget/domain/budget_totals_calculator.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/presentation/controllers/budget_controller.dart';
import 'package:salapify/features/budget/presentation/widgets/budget_summary_card.dart';
import 'package:salapify/features/budget/presentation/widgets/category_card.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/router/routes.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resetGuard = ref.watch(periodResetGuardProvider);
    if (resetGuard.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final categoriesAsync = ref.watch(budgetCategoriesProvider);
    final globalPeriod =
        ref.watch(budgetingPeriodSettingProvider).value ??
        BudgetingPeriod.monthly;
    final firstHalfEndDay =
        ref.watch(firstHalfEndDaySettingProvider).value ?? 15;
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final hasUnsynced = ref.watch(hasUnsyncedCategoriesProvider).value ?? false;

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Failed to load categories: $err')),
      data: (categories) {
        final totalAllocated = BudgetTotalsCalculator.totalAllocated(
          categories: categories,
          globalPeriod: globalPeriod,
          firstHalfEndDay: firstHalfEndDay,
        );
        const totalSpent = 0.0; // TODO: wire up once transactions exist

        final grouped = _groupCategories(
          categories: categories,
          globalPeriod: globalPeriod,
          firstHalfEndDay: firstHalfEndDay,
          now: DateTime.now(),
        );

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              // if (hasUnsynced)
              //   SliverToBoxAdapter(
              //     child: Container(
              //       width: double.infinity,
              //       color: isOnline
              //           ? Theme.of(context).colorScheme.secondaryContainer
              //           : Theme.of(context).colorScheme.errorContainer,
              //       padding: const EdgeInsets.symmetric(
              //         vertical: 6,
              //         horizontal: 16,
              //       ),
              //       child: Text(
              //         isOnline
              //             ? 'Syncing changes…'
              //             : 'Offline — changes saved locally',
              //         style: Theme.of(context).textTheme.labelSmall,
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //   ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: BudgetSummaryCard(
                    totalSpent: totalSpent,
                    totalAllocated: totalAllocated,
                    period: globalPeriod,
                    firstHalfEndDay: firstHalfEndDay,
                  ),
                ),
              ),
              if (grouped.current.isEmpty && grouped.other.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('No categories yet. Tap + to add one.'),
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

  _GroupedCategories _groupCategories({
    required List<BudgetCategory> categories,
    required BudgetingPeriod globalPeriod,
    required int firstHalfEndDay,
    required DateTime now,
  }) {
    final active = categories.where(
      (c) =>
          !c.isDeleted &&
          c.isActiveFor(
            globalPeriod: globalPeriod,
            firstHalfEndDay: firstHalfEndDay,
            now: now,
          ),
    );

    int cardComparator(BudgetCategory a, BudgetCategory b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return a.sortOrder.compareTo(b.sortOrder);
    }

    if (globalPeriod == BudgetingPeriod.monthly) {
      final sorted = active.toList()..sort(cardComparator);
      return _GroupedCategories(current: sorted, other: const []);
    }

    final current = <BudgetCategory>[];
    final other = <BudgetCategory>[];

    for (final c in active) {
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
  final List<BudgetCategory> other; // empty when globalPeriod is monthly
}

/// One reorderable group of category cards (either "current half" or
/// "other half").
class _ReorderableCategoryGrid extends ConsumerWidget {
  const _ReorderableCategoryGrid({
    super.key,
    required this.categories,
    required this.dimmed,
  });

  final List<BudgetCategory> categories;
  final bool dimmed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  .setCompleted(category.id, value),
            ),
          ),
        )
        .toList();

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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.15,
          ),
          children: reorderedChildren,
        );
      },
      children: children,
    );
  }
}
