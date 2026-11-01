import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/notification/data/providers/notification_providers.dart';
import 'package:salapify/features/notification/domain/entities/notification_entry.dart';
import 'package:salapify/features/notification/presentation/controllers/notification_controller.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';
import 'package:salapify/core/localization/locale_text.dart';
import 'package:salapify/l10n/app_localizations.dart';
import 'package:salapify/router/routes.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final notificationsAsync = ref.watch(notificationsProvider);

    return SafeArea(
      child: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text(l10n.notificationsLoadFailed('$err'))),
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyState();
          }

          final unreadCount = items.where((n) => !n.read).length;
          final sections = _groupByDate(items, l10n);

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(notificationsProvider),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  sliver: SliverToBoxAdapter(
                    child: _HeaderCard(unreadCount: unreadCount),
                  ),
                ),
                for (final section in sections) ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        section.label.toUpperCaseL(context),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.builder(
                      itemCount: section.items.length,
                      itemBuilder: (context, i) =>
                          _NotificationTile(entry: section.items[i]),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
      ),
    );
  }

  List<_Section> _groupByDate(
    List<NotificationEntry> items,
    AppLocalizations l10n,
  ) {
    final now = DateTime.now();
    final today = <NotificationEntry>[];
    final yesterday = <NotificationEntry>[];
    final earlier = <NotificationEntry>[];

    for (final n in items) {
      final d = n.createdAt;
      final diff = DateTime(
        now.year,
        now.month,
        now.day,
      ).difference(DateTime(d.year, d.month, d.day)).inDays;
      if (diff == 0) {
        today.add(n);
      } else if (diff == 1) {
        yesterday.add(n);
      } else {
        earlier.add(n);
      }
    }

    return [
      if (today.isNotEmpty) _Section(l10n.dateToday, today),
      if (yesterday.isNotEmpty) _Section(l10n.dateYesterday, yesterday),
      if (earlier.isNotEmpty) _Section(l10n.notificationsEarlier, earlier),
    ];
  }
}

class _Section {
  const _Section(this.label, this.items);
  final String label;
  final List<NotificationEntry> items;
}

/// Gradient summary card, same recipe as [CashFlowSummaryStrip]: soft tinted
/// background + border, sits above the grouped notification feed.
class _HeaderCard extends ConsumerWidget {
  const _HeaderCard({required this.unreadCount});

  final int unreadCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.notifications_rounded,
              size: 20,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.navNotifications,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  unreadCount > 0
                      ? l10n.notificationsUnread(unreadCount)
                      : l10n.notificationsAllCaughtUp,
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          if (unreadCount > 0)
            TextButton(
              onPressed: () => ref
                  .read(notificationControllerProvider.notifier)
                  .markAllRead(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: colors.primary,
              ),
              child: Text(
                l10n.notificationsMarkAllRead,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColorsExt>()!;

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
              l10n.notificationsEmpty,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.entry});

  final NotificationEntry entry;

  (IconData, Color Function(AppColorsExt)) get _iconAndColorResolver {
    switch (entry.type) {
      case NotificationType.addedToGroup:
        return (Icons.group_add_rounded, (c) => c.primary);
      case NotificationType.billAdded:
        return (Icons.receipt_long_rounded, (c) => c.primary);
      case NotificationType.paymentMarked:
        return (Icons.hourglass_top_rounded, (c) => c.warning);
      case NotificationType.paymentConfirmed:
        return (Icons.check_circle_rounded, (c) => c.primary);
      case NotificationType.paymentDisputed:
        return (Icons.error_rounded, (c) => c.error);
    }
  }

  String _senderDisplayName(AppLocalizations l10n) =>
      entry.senderName.trim().isEmpty
      ? l10n.notificationDeletedUser
      : entry.senderName;

  String _label(AppLocalizations l10n) {
    final name = _senderDisplayName(l10n);
    final group = entry.groupName;
    switch (entry.type) {
      case NotificationType.addedToGroup:
        return l10n.notificationAddedToGroup(name, group);
      case NotificationType.billAdded:
        final title = '${entry.metadata?['billTitle'] ?? l10n.activityABill}';
        return l10n.notificationBillAdded(name, title, group);
      case NotificationType.paymentMarked:
        return l10n.notificationPaymentMarked(name, group);
      case NotificationType.paymentConfirmed:
        return l10n.notificationPaymentConfirmed(name, group);
      case NotificationType.paymentDisputed:
        return l10n.notificationPaymentDisputed(name, group);
    }
  }

  String _timeAgo(DateTime dt, AppLocalizations l10n) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return l10n.timeJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    return l10n.timeDaysAgo(diff.inDays);
  }

  Future<void> _handleTap(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    ref.read(notificationControllerProvider.notifier).markRead(entry.id);

    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    SplitGroup? group;
    try {
      group = await ref
          .read(splitBillRepositoryProvider)
          .getGroup(entry.groupId);
    } catch (_) {
      group = null;
    }

    if (!context.mounted) return;

    final stillMember =
        group != null && group.memberIds.contains(currentUser.uid);

    if (!stillMember) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.notificationGroupUnavailable)),
      );
      return;
    }

    context.pushNamed(
      AppRoutes.splitGroupDetail.name,
      pathParameters: {'groupId': entry.groupId},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final (icon, resolveColor) = _iconAndColorResolver;
    final color = resolveColor(colors);

    return InkWell(
      onTap: () => _handleTap(context, ref),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: entry.read ? null : colors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: entry.read
                ? colors.border
                : colors.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!entry.read)
              Container(
                width: 3,
                height: 34,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.12),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _label(l10n),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: entry.read
                          ? FontWeight.w500
                          : FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _timeAgo(entry.createdAt, l10n),
                    style: TextStyle(fontSize: 11, color: colors.textSecondary),
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
