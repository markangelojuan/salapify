import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';
import 'package:salapify/features/split_bill/domain/split_balance_calculator.dart';
import 'package:salapify/features/split_bill/presentation/controllers/split_bill_controller.dart';
import 'package:salapify/router/routes.dart';

class SplitBillsScreen extends ConsumerWidget {
  const SplitBillsScreen({super.key});

  Future<void> _confirmLeaveOrDelete(
    BuildContext context,
    WidgetRef ref,
    SplitGroup group,
    bool isCreator,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isCreator ? 'Delete this group?' : 'Leave this group?'),
        content: Text(
          isCreator
              ? 'This deletes "${group.name}" and its bills for everyone.'
              : 'You\'ll no longer see "${group.name}" or its bills.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(isCreator ? 'Delete' : 'Leave'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final notifier = ref.read(splitBillControllerProvider.notifier);
    if (isCreator) {
      await notifier.deleteGroup(group.id);
    } else {
      await notifier.leaveGroup(group.id);
    }

    final error = ref.read(splitBillControllerProvider).error;
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $error')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(splitGroupsProvider);
    final currentUid = ref.watch(currentUserProvider)?.uid;

    return SafeArea(
      child: groupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load groups: $err')),
        data: (groups) {
          if (groups.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 40),
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
                      'No groups yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }


          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              final isCreator = group.createdBy == currentUid;
              final unreadCount = currentUid != null
                  ? (group.unreadCounts[currentUid] ?? 0)
                  : 0;
              return _GroupRow(
                group: group,
                isCreator: isCreator,
                currentUid: currentUid,
                unreadCount: unreadCount,
                onTap: () => context.pushNamed(
                  AppRoutes.splitGroupDetail.name,
                  pathParameters: {'groupId': group.id},
                ),
                onEdit: () =>
                    context.pushNamed(AppRoutes.groupForm.name, extra: group),
                onDismiss: () =>
                    _confirmLeaveOrDelete(context, ref, group, isCreator),
              );
            },
          );
        },
      ),
    );
  }
}

class _GroupRow extends ConsumerWidget {
  const _GroupRow({
    required this.group,
    required this.isCreator,
    required this.currentUid,
    required this.unreadCount,
    required this.onTap,
    required this.onEdit,
    required this.onDismiss,
  });

  final SplitGroup group;
  final bool isCreator;
  final String? currentUid;
  final int unreadCount;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(splitBillsProvider(group.id));
    final hasUnread = unreadCount > 0;

    return Dismissible(
      key: ValueKey(group.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDismiss();
        return false; // repository stream removes it from the list
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          isCreator ? Icons.delete_outline_rounded : Icons.logout_rounded,
          color: Colors.white,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                        child: Text(
                          group.name.isNotEmpty
                              ? group.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (hasUnread)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: _UnreadBadge(count: unreadCount),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: TextStyle(
                            fontWeight: hasUnread
                                ? FontWeight.w800
                                : FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _Pill(
                              label:
                                  '${group.memberIds.length} member${group.memberIds.length == 1 ? '' : 's'}',
                              color: AppColors.primary,
                            ),
                            if (billsAsync.hasValue && currentUid != null)
                              _BalancePill(
                                bills: billsAsync.value!,
                                currentUid: currentUid!,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isCreator)
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                      ),
                      onPressed: onEdit,
                    )
                  else
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textPrimary.withValues(alpha: 0.3),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 9 ? '9+' : '$count';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red[600],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Neutral info pill (member count), matching the app's chip language.
class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Balance-state pill for a single group — mirrors the color language of
/// SplitGroupDetailScreen's _BalanceSummary (green = owed to you, red = you
/// owe) so the list and detail screens read as the same system.
class _BalancePill extends StatelessWidget {
  const _BalancePill({required this.bills, required this.currentUid});

  final List<SplitBill> bills;
  final String currentUid;

  @override
  Widget build(BuildContext context) {
    final balances = SplitBalanceCalculator.forUser(bills, currentUid);
    final youOwe = balances.youOwe.fold<double>(0, (a, b) => a + b.amount);
    final owedToYou = balances.owedToYou.fold<double>(
      0,
      (a, b) => a + b.amount,
    );
    final net = owedToYou - youOwe;

    if (net == 0) {
      return _Pill(label: 'Settled', color: Colors.green[700]!);
    }
    final isPositive = net > 0;
    final label = isPositive
        ? 'Owed ₱${net.toStringAsFixed(0)}'
        : 'You owe ₱${net.abs().toStringAsFixed(0)}';
    return _Pill(
      label: label,
      color: isPositive ? Colors.green[700]! : Colors.red[600]!,
    );
  }
}