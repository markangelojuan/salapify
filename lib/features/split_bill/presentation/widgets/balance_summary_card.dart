import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill.dart';
import 'package:salapify/features/split_bill/domain/split_balance_calculator.dart';

class BalanceSummaryCard extends StatelessWidget {
  const BalanceSummaryCard({
    super.key,
    required this.bills,
    required this.currentUid,
    required this.currency,
  });

  final List<SplitBill> bills;
  final String? currentUid;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    if (currentUid == null) return const SizedBox.shrink();

    final balances = SplitBalanceCalculator.forUser(bills, currentUid!);
    final totalYouOwe = balances.youOwe.fold<double>(0, (a, b) => a + b.amount);
    final totalOwedToYou = balances.owedToYou.fold<double>(
      0,
      (a, b) => a + b.amount,
    );

    final settled = totalYouOwe == 0 && totalOwedToYou == 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
      child: settled
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.celebration_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'All settled up',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _BalanceItem(
                    icon: Icons.south_west_rounded,
                    label: 'Owed to you',
                    amount: currency.format(totalOwedToYou),
                    color: Colors.green[700]!,
                  ),
                ),
                Container(
                  width: 1,
                  height: 44,
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
                Expanded(
                  child: _BalanceItem(
                    icon: Icons.north_east_rounded,
                    label: 'You owe',
                    amount: currency.format(totalYouOwe),
                    color: Colors.red[600]!,
                  ),
                ),
              ],
            ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  const _BalanceItem({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}