import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

/// Horizontally scrollable day-picker (1-28) styled as pill chips.
class DaySelector extends StatelessWidget {
  const DaySelector({
    super.key,
    required this.selectedDay,
    required this.onChanged,
  });

  final int selectedDay;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 28,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = index + 1;
          final selected = day == selectedDay;
          return GestureDetector(
            onTap: () => onChanged(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                '$day',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: selected ? Colors.white : colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}