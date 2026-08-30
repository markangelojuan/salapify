import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: BudgetSummaryCard(
                      totalSpent: totalSpent,
                      totalAllocated: totalAllocated,
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
                    sliver: SliverList.separated(
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryCard(
                          category: category,
                          onTap: () => context.pushNamed(
                            AppRoutes.categoryForm.name,
                            extra: category,
                          ),
                        );
                      },
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.pushNamed(AppRoutes.categoryForm.name),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}