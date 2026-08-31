import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/domain/entities/budget_category_type.dart';
import 'package:salapify/features/budget/domain/entities/budget_frequency.dart';
import 'package:salapify/features/budget/presentation/constants/category_icons.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final BudgetCategory category;
  final VoidCallback onTap;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isChecked = false;

  BudgetCategory get category => widget.category;

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
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        AppColors.primary.withValues(alpha: 0.15),
                    child: Icon(
                      CategoryIcons.iconFor(category.iconName),
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  _TypeChip(
                    label: _isFixed ? 'Fixed' : 'Flexible',
                    color: _accentColor,
                  ),
                  const SizedBox(width: 8),
                  _BigCheckbox(
                    checked: _isChecked,
                    onTap: () => setState(() => _isChecked = !_isChecked),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                category.amount.toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.event_repeat_rounded,
                    size: 13,
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
    );
  }
}

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
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}