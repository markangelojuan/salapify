import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmAndSetPeriod(
    BuildContext context,
    WidgetRef ref,
    BudgetingPeriod newPeriod,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change Budgeting Period'),
        content: const Text(
          'Existing categories will be converted to match the new period '
          '(amounts stay the same). Categories set for a specific half will '
          'now count toward the full month, or vice versa — you may want to '
          'review and consolidate any duplicates afterward. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(budgetingPeriodSettingProvider.notifier).set(newPeriod);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodAsync = ref.watch(budgetingPeriodSettingProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<String?>(settingsSyncWarningProvider, (previous, next) {
      if (next != null) {
        CommonSnackbar.showWarning(context, next);
        ref.read(settingsSyncWarningProvider.notifier).set(null);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: periodAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text('Failed to load settings: $err')),
        data: (period) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _SectionHeader(
              icon: Icons.calendar_today_rounded,
              title: 'Budgeting Period',
            ),
            _SelectableOptionTile(
              label: 'Monthly',
              subtitle: 'Track budgets once per month',
              selected: period == BudgetingPeriod.monthly,
              onTap: () => _confirmAndSetPeriod(
                context,
                ref,
                BudgetingPeriod.monthly,
              ),
            ),
            Divider(
              height: 1,
              indent: 20,
              endIndent: 20,
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            _SelectableOptionTile(
              label: 'Bi-Monthly',
              subtitle: 'Split the month into two halves',
              selected: period == BudgetingPeriod.biMonthly,
              onTap: () => _confirmAndSetPeriod(
                context,
                ref,
                BudgetingPeriod.biMonthly,
              ),
            ),
            if (period == BudgetingPeriod.biMonthly) ...[
              Divider(
                height: 32,
                thickness: 6,
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
              ),
              _SectionHeader(
                icon: Icons.event_repeat_rounded,
                title: 'First Half Ends On',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                child: Consumer(
                  builder: (context, ref, _) {
                    final dayAsync = ref.watch(firstHalfEndDaySettingProvider);
                    return dayAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Text('Error: $e'),
                      data: (day) => _DaySelector(
                        selectedDay: day,
                        onChanged: (v) => ref
                            .read(firstHalfEndDaySettingProvider.notifier)
                            .set(v),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Small section label with a leading icon, sitting directly on the
/// scaffold background rather than inside a card.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.2,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// A tappable row with a label/subtitle and a check-style indicator,
/// separated from siblings by thin Dividers instead of card borders.
class _SelectableOptionTile extends StatelessWidget {
  const _SelectableOptionTile({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : colorScheme.onSurface.withValues(alpha: 0.25),
                  width: 1.6,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        key: ValueKey('checked'),
                        size: 16,
                        color: Colors.white,
                      )
                    : const SizedBox.shrink(key: ValueKey('unchecked')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontally scrollable day-picker (1-28) styled as pill chips.
class _DaySelector extends StatelessWidget {
  const _DaySelector({required this.selectedDay, required this.onChanged});

  final int selectedDay;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 28,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = index + 1;
          final selected = day == selectedDay;
          return GestureDetector(
            onTap: () => onChanged(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                borderRadius: BorderRadius.circular(12),
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