import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:salapify/features/transaction/presentation/controllers/income_source_controller.dart';
import 'package:salapify/router/routes.dart';
import 'package:salapify/features/transaction/presentation/widgets/recurring_income_row.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';

class IncomeTab extends ConsumerWidget {
  const IncomeTab({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove this income entry?'),
        content: const Text(
          'It will no longer be counted toward total money.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(incomeSourceActionsProvider.notifier).deleteSource(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(incomeSourceActionsProvider, (previous, next) {
    if (next.hasError) {
      CommonSnackbar.showError(context, next.error!);
    }
  });
    final sourcesAsync = ref.watch(incomeSourcesProvider);

    return sourcesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Failed to load income: $err')),
      data: (sources) {
        if (sources.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/lottie/sleeping_squirrel.json',
                    width: 180,
                    height: 180,
                  ),
                  Text(
                    'No income entries yet',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          children: [
            Text(
              'Income',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            ...sources.map(
              (source) => RecurringIncomeRow(
                source: source,
                onTap: () => context.pushNamed(
                  AppRoutes.incomeForm.name,
                  extra: source,
                ),
                onDelete: () => _confirmDelete(context, ref, source.id),
              ),
            ),
          ],
        );
      },
    );
  }
}