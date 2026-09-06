import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

/// Three-way cash flow summary (Income / Spent / Savings) for the current
/// period. Sits above the Expenses/Income tabs since it's cross-cutting,
/// not specific to either tab.
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.10),
            AppColors.primary.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              label: 'Income',
              amount: income,
              color: Colors.green[700]!,
            ),
          ),
          _VerticalDivider(colorScheme: colorScheme),
          Expanded(
            child: _SummaryItem(
              label: 'Spent',
              amount: spent,
              color: Colors.red[600]!,
            ),
          ),
          _VerticalDivider(colorScheme: colorScheme),
          Expanded(
            child: _SummaryItem(
              label: 'Savings',
              amount: savings,
              color: Colors.blue[400]!,
            ),
          ),
        ],
      ),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }
}