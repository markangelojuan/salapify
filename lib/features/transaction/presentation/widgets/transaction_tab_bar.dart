import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

/// Modern pill-style TabBar — rounded track with a sliding filled
/// indicator, matching the pill/chip language used across Budget and
/// Settings (e.g. CategoryCard's checkbox, Settings' day selector).
class TransactionTabBar extends StatelessWidget {
  const TransactionTabBar({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(
          22,
        ), // was 14 — full stadium for height 44
      ),
      child: TabBar(
        controller: controller,
        splashBorderRadius: BorderRadius.circular(10),
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        tabs: const [
          Tab(text: 'Expenses'),
          Tab(text: 'Income'),
        ],
      ),
    );
  }
}
