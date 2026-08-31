import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';

class BudgetSummaryCard extends StatelessWidget {
  const BudgetSummaryCard({
    super.key,
    required this.totalSpent,
    required this.totalAllocated,
    required this.period,
    this.firstHalfEndDay = 15,
  });

  final double totalSpent;
  final double totalAllocated;
  final BudgetingPeriod period;
  final int firstHalfEndDay;

  String get _periodLabel {
    final now = DateTime.now();
    final monthName = _monthNames[now.month - 1];

    if (period == BudgetingPeriod.monthly) {
      return '$monthName ${now.year}';
    }

    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
    final isFirstHalf = now.day <= firstHalfEndDay;
    final rangeStart = isFirstHalf ? 1 : firstHalfEndDay + 1;
    final rangeEnd = isFirstHalf ? firstHalfEndDay : lastDayOfMonth;

    return '${isFirstHalf ? "1st" : "2nd"} Half · '
        '$monthName $rangeStart–$rangeEnd';
  }

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  double get _percentUsed {
    if (totalAllocated <= 0) return 0;

    final ratio = totalSpent / totalAllocated;
    return ratio.clamp(0, 1);
  }

  bool get _isOverBudget => totalSpent > totalAllocated;

  @override
  Widget build(BuildContext context) {
    final remaining = totalAllocated - totalSpent;
    final statusColor = _isOverBudget ? Colors.red : AppColors.primary;

    return Container(
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
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.08),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period label
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 12,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  _periodLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Chart + summary
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left half - Pie chart, centered within its own section
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            startDegreeOffset: -90,
                            sectionsSpace: 3,
                            centerSpaceRadius: 44,
                            sections: [
                              PieChartSectionData(
                                value: _percentUsed * 100,
                                color: statusColor,
                                showTitle: false,
                                radius: 16,
                              ),
                              PieChartSectionData(
                                value: (1 - _percentUsed) * 100,
                                color: AppColors.primary.withValues(
                                  alpha: 0.06,
                                ),
                                showTitle: false,
                                radius: 16,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(_percentUsed * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              'used',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textPrimary.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Right half - Financial summary
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isOverBudget ? 'Over budget' : 'Remaining',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      remaining.abs().toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: _isOverBudget
                            ? Colors.red
                            : Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _AmountRow(
                      label: 'Spent',
                      amount: totalSpent,
                    ),
                    const SizedBox(height: 4),
                    _AmountRow(
                      label: 'Allocated',
                      amount: totalAllocated,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _percentUsed,
              minHeight: 6,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation(statusColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.amount,
  });

  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary.withValues(alpha: 0.7),
          ),
        ),
        Text(
          amount.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}