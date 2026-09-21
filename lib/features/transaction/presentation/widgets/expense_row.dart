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
                      _TruncatedNote(
                        text: transaction.note!,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
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

/// Single-line note that ellipsizes when it doesn't fit its row, and only
/// then becomes long-pressable to reveal the full text via a tooltip.
class _TruncatedNote extends StatelessWidget {
  const _TruncatedNote({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);

        final isTruncated = painter.didExceedMaxLines;

        final textWidget = Text(
          text,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );

        if (!isTruncated) return textWidget;

        return Tooltip(
          message: text,
          triggerMode: TooltipTriggerMode.longPress,
          preferBelow: false,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colors.textPrimary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colors.textPrimary.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          textStyle: TextStyle(
            color: colors.background,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          child: textWidget,
        );
      },
    );
  }
}