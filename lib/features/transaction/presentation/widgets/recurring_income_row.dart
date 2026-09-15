import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/transaction/domain/entities/income_source.dart';

class RecurringIncomeRow extends StatelessWidget {
  const RecurringIncomeRow({
    super.key,
    required this.source,
    required this.onTap,
    required this.onDelete,
  });

  final IncomeSource source;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  String get _frequencyLabel {
    if (!source.isRecurring) return 'One-time';
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final effectiveDay = (source.recurringDay ?? 1).clamp(1, daysInMonth);
    final isClamped = effectiveDay != source.recurringDay;
    return isClamped
        ? 'Every month on day ${source.recurringDay} (${_ordinal(effectiveDay)} this month)'
        : 'Every month on day ${source.recurringDay}';
  }

  String _ordinal(int day) {
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Dismissible(
      key: ValueKey(source.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false; // removal happens via the stream after soft-delete
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.source,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _frequencyLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '+${source.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
