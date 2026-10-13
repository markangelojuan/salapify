import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/settings/domain/currency.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';

class CashFlowSummaryStrip extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final currency =
        ref.watch(currencySettingProvider).value ?? AppCurrency.php;

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
                "Your expected income and savings this month. No history kept.",
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
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
            border: Border.all(color: colors.primary.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: 'Income',
                  amount: income,
                  color: colors.primary,
                  currency: currency,
                ),
              ),
              _VerticalDivider(color: colors.border),
              Expanded(
                child: _SummaryItem(
                  label: 'Spent',
                  amount: spent,
                  color: colors.error,
                  currency: currency,
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
                  currency: currency,
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
    required this.currency,
  });

  final String label;
  final double amount;
  final Color color;
  final AppCurrency currency;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    return Padding(
      // Keeps text away from the dividers.
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: colors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              currency.formatCompactWithSymbol(amount),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: color);
  }
}