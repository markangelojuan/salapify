import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

class BudgetSummaryCard extends StatelessWidget {
  const BudgetSummaryCard({
    super.key,
    required this.totalSpent,
    required this.totalAllocated,
  });

  final double totalSpent;
  final double totalAllocated;

  double get _percentUsed {
    if (totalAllocated <= 0) return 0;
    final ratio = totalSpent / totalAllocated;
    return ratio.clamp(0, 1);
  }

  bool get _isOverBudget => totalSpent > totalAllocated;

  @override
  Widget build(BuildContext context) {
    final remaining = totalAllocated - totalSpent;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      sectionsSpace: 0,
                      centerSpaceRadius: 32,
                      sections: [
                        PieChartSectionData(
                          value: _percentUsed * 100,
                          color: _isOverBudget ? Colors.red : AppColors.primary,
                          showTitle: false,
                          radius: 14,
                        ),
                        PieChartSectionData(
                          value: (1 - _percentUsed) * 100,
                          color: AppColors.background,
                          showTitle: false,
                          radius: 14,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(_percentUsed * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AmountRow(label: 'Spent', amount: totalSpent),
                  const SizedBox(height: 6),
                  _AmountRow(label: 'Allocated', amount: totalAllocated),
                  const SizedBox(height: 6),
                  _AmountRow(
                    label: _isOverBudget ? 'Over by' : 'Remaining',
                    amount: remaining.abs(),
                    valueColor: _isOverBudget ? Colors.red : Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.amount,
    this.valueColor,
  });

  final String label;
  final double amount;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.textPrimary)),
        Text(
          amount.toStringAsFixed(2),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}