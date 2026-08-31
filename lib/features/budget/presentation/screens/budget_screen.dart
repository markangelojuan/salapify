import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/services/connectivity_service.dart';
import 'package:salapify/features/budget/domain/budget_totals_calculator.dart';
import 'package:salapify/features/budget/presentation/controllers/budget_controller.dart';
import 'package:salapify/features/budget/presentation/widgets/budget_summary_card.dart';
import 'package:salapify/features/budget/presentation/widgets/category_card.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/router/routes.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(budgetCategoriesProvider);
    final globalPeriod =
        ref.watch(budgetingPeriodSettingProvider).value ?? BudgetingPeriod.monthly;
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

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              if (hasUnsynced)
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    color: isOnline
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context).colorScheme.errorContainer,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    child: Text(
                      isOnline ? 'Syncing changes…' : 'Offline — changes saved locally',
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
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
              if (categories.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('No categories yet. Tap + to add one.'),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = categories[index];
                        return CategoryCard(
                          category: category,
                          onTap: () => context.pushNamed(
                            AppRoutes.categoryForm.name,
                            extra: category,
                          ),
                        );
                      },
                      childCount: categories.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }
}