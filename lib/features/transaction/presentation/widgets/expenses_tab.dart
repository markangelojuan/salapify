import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/presentation/controllers/budget_controller.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';
import 'package:salapify/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:salapify/features/transaction/presentation/widgets/expense_row.dart';
import 'package:salapify/router/routes.dart';
import 'package:lottie/lottie.dart';

class ExpensesTab extends ConsumerWidget {
  const ExpensesTab({super.key});

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';

    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final sameYear = date.year == now.year;
    return sameYear
        ? '${monthNames[date.month - 1]} ${date.day}'
        : '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  Map<String, List<TransactionEntry>> _groupByDate(
    List<TransactionEntry> transactions,
  ) {
    final grouped = <String, List<TransactionEntry>>{};
    for (final t in transactions) {
      final key = '${t.date.year}-${t.date.month}-${t.date.day}';
      grouped.putIfAbsent(key, () => []).add(t);
    }
    return grouped;
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this expense?'),
        content: const Text(
          'It will no longer count toward your spending totals.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(transactionActionsProvider.notifier).deleteTransaction(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final categoriesAsync = ref.watch(budgetCategoriesProvider);

    return transactionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Failed to load expenses: $err')),
      data: (transactions) {
        if (transactions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
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
                    'No expenses yet',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final categories = categoriesAsync.value ?? <BudgetCategory>[];
        final categoryById = {for (final c in categories) c.id: c};

        final grouped = _groupByDate(transactions);
        final sortedKeys = grouped.keys.toList()
          ..sort((a, b) {
            final da = grouped[a]!.first.date;
            final db = grouped[b]!.first.date;
            return db.compareTo(da);
          });

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          itemCount: sortedKeys.length,
          itemBuilder: (context, index) {
            final key = sortedKeys[index];
            final dayTransactions = grouped[key]!
              ..sort((a, b) => b.date.compareTo(a.date));
            final label = _dateLabel(dayTransactions.first.date);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                ...dayTransactions.map(
                  (t) => ExpenseRow(
                    transaction: t,
                    category: categoryById[t.categoryId],
                    onTap: () =>
                        context.pushNamed(AppRoutes.expenseForm.name, extra: t),
                    onDelete: () => _confirmDelete(context, ref, t.id),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
