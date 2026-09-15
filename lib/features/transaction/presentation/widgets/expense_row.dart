import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/presentation/constants/category_icons.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';

class ExpenseRow extends StatelessWidget {
  const ExpenseRow({
    super.key,
    required this.transaction,
    required this.category,
    required this.onTap,
    required this.onDelete,
  });

  final TransactionEntry transaction;

  /// Null if the category was hard-deleted or not found (shouldn't
  /// normally happen since categories are soft-deleted, but guarded here).
  final BudgetCategory? category;

  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false; // we handle removal via the stream, not the dismiss animation
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: colors.error.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline_rounded, color: colors.onPrimary),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category != null
                      ? CategoryIcons.iconFor(category!.iconName)
                      : Icons.help_outline_rounded,
                  size: 18,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category?.name ?? 'Deleted category',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: colors.textPrimary,
                      ),
                    ),
                    if (transaction.note != null &&
                        transaction.note!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        transaction.note!,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                '-${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: colors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
