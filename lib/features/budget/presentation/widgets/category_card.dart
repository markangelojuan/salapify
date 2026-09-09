import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/domain/entities/budget_category_type.dart';
import 'package:salapify/features/budget/domain/entities/budget_frequency.dart';
import 'package:salapify/features/budget/presentation/constants/category_icons.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/transaction/domain/transaction_totals_calculator.dart';
import 'package:salapify/features/transaction/presentation/controllers/transaction_controller.dart';

class CategoryCard extends ConsumerWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.onToggleComplete,
  });

  final BudgetCategory category;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggleComplete;

  bool get _isFixed => category.type == BudgetCategoryType.fixed;

  Color get _accentColor => _isFixed ? Colors.blue : Colors.orange;

  String get _frequencyLabel {
    switch (category.frequency) {
      case BudgetFrequency.monthly:
        return 'Monthly';
      case BudgetFrequency.biMonthly:
        return _periodLabel;
      case BudgetFrequency.once:
        return 'One-time';
    }
  }

  String get _periodLabel {
    switch (category.period) {
      case BudgetPeriod.firstHalf:
        return '1st half';
      case BudgetPeriod.secondHalf:
        return '2nd half';
      case BudgetPeriod.both:
        return 'Bi-monthly';
      case null:
        return 'Bi-monthly';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalPeriod =
        ref.watch(budgetingPeriodSettingProvider).value ??
        BudgetingPeriod.monthly;
    final firstHalfEndDay =
        ref.watch(firstHalfEndDaySettingProvider).value ?? 15;
    final transactions = ref.watch(transactionsProvider).value ?? [];

    final spent = TransactionTotalsCalculator.totalSpentForCategory(
      transactions: transactions,
      categoryId: category.id,
      globalPeriod: globalPeriod,
      firstHalfEndDay: firstHalfEndDay,
    );
    final progress = category.amount > 0
        ? (spent / category.amount).clamp(0.0, 1.0)
        : 0.0;
    final isOver = spent > category.amount;
    final progressColor = isOver
        ? Colors.red
        : (progress >= 0.8 ? Colors.orange : AppColors.primary);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.textScalerOf(
          context,
        ).clamp(maxScaleFactor: 1.15),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.15,
                      ),
                      child: Icon(
                        CategoryIcons.iconFor(category.iconName),
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const Spacer(),
                    _TypeChip(
                      label: _isFixed ? 'Fixed' : 'Variable',
                      color: _accentColor,
                    ),
                    const SizedBox(width: 8),
                    _BigCheckbox(
                      checked: category.isCompleted,
                      onTap: () => onToggleComplete(!category.isCompleted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),

                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${spent.toStringAsFixed(0)} / ${category.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isOver ? Colors.red : null,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: AppColors.border.withValues(alpha: 0.4),
                    valueColor: AlwaysStoppedAnimation(progressColor),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.event_repeat_rounded,
                      size: 12,
                      color: AppColors.textPrimary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _frequencyLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textPrimary.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// _BigCheckbox and _TypeChip unchanged from before
class _BigCheckbox extends StatelessWidget {
  const _BigCheckbox({required this.checked, required this.onTap});

  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: checked ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: checked
                ? AppColors.primary
                : AppColors.textPrimary.withValues(alpha: 0.22),
            width: 1.6,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: checked
              ? const Icon(
                  Icons.check_rounded,
                  key: ValueKey('checked'),
                  size: 15,
                  color: Colors.white,
                )
              : const SizedBox.shrink(key: ValueKey('unchecked')),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
