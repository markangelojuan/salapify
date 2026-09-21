import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';


class CashFlowSummaryStrip extends StatelessWidget {
  const CashFlowSummaryStrip({
    super.key,
    required this.income,
    required this.spent,
    required this.savings,
  });

  final double income;
  final double spent;
  final double savings;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 12,
                color: colors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Resets each period. No history is stored.',
                style: TextStyle(
                  fontSize: 11,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.primary.withValues(alpha: 0.10),
                colors.primary.withValues(alpha: 0.02),
              ],
            ),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: 'Income',
                  amount: income,
                  color: colors.primary,
                ),
              ),
              _VerticalDivider(color: colors.border),
              Expanded(
                child: _SummaryItem(
                  label: 'Spent',
                  amount: spent,
                  color: colors.error,
                ),
              ),
              _VerticalDivider(color: colors.border),
              Expanded(
                child: _SummaryItem(
                  label: 'Savings',
                  amount: savings,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF7EB6E8)
                      : const Color(0xFF3D7EBF),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          amount.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: color,
    );
  }
}