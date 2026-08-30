import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        title: const Text('Change Budgeting Period'),
        content: const Text(
          'Your existing categories\' amounts will NOT be automatically '
          'adjusted. Please review and update them yourself after switching. '
          'Continue?',
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

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: periodAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load settings: $err')),
        data: (period) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Budgeting Period',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            RadioListTile<BudgetingPeriod>(
              title: const Text('Monthly'),
              value: BudgetingPeriod.monthly,
              groupValue: period,
              onChanged: (v) {
                if (v != null && v != period) {
                  _confirmAndSetPeriod(context, ref, v);
                }
              },
            ),
            RadioListTile<BudgetingPeriod>(
              title: const Text('Bi-Monthly'),
              value: BudgetingPeriod.biMonthly,
              groupValue: period,
              onChanged: (v) {
                if (v != null && v != period) {
                  _confirmAndSetPeriod(context, ref, v);
                }
              },
            ),
            if (period == BudgetingPeriod.biMonthly) ...[
              const SizedBox(height: 16),
              const Text(
                'First Half Ends On',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Consumer(
                builder: (context, ref, _) {
                  final dayAsync = ref.watch(firstHalfEndDaySettingProvider);
                  return dayAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('Error: $e'),
                    data: (day) => DropdownButton<int>(
                      value: day,
                      items: List.generate(28, (i) => i + 1)
                          .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text('Day $d'),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          ref
                              .read(firstHalfEndDaySettingProvider.notifier)
                              .set(v);
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}