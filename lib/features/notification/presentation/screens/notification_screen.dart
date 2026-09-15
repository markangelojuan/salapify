import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/notification/data/providers/notification_providers.dart';
import 'package:salapify/features/notification/domain/entities/notification_entry.dart';
import 'package:salapify/features/notification/presentation/controllers/notification_controller.dart';
import 'package:salapify/router/routes.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final notificationsAsync = ref.watch(notificationsProvider);

    return SafeArea(
      child: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text('Failed to load notifications: $err')),
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyState();
          }

          final unreadCount = items.where((n) => !n.read).length;
          final sections = _groupByDate(items);

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
                        section.label.toUpperCase(),
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

  List<_Section> _groupByDate(List<NotificationEntry> items) {
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
      if (today.isNotEmpty) _Section('Today', today),
      if (yesterday.isNotEmpty) _Section('Yesterday', yesterday),
      if (earlier.isNotEmpty) _Section('Earlier', earlier),
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
                  'Notifications',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  unreadCount > 0
                      ? '$unreadCount unread'
                      : 'You\'re all caught up',
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
              child: const Text(
                'Mark all read',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
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
              'No notifications yet',
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

  String get _label {
    switch (entry.type) {
      case NotificationType.addedToGroup:
        return '${entry.senderName} added you to "${entry.groupName}"';
      case NotificationType.billAdded:
        final title = entry.metadata?['billTitle'] ?? 'a bill';
        return '${entry.senderName} added "$title" in ${entry.groupName}';
      case NotificationType.paymentMarked:
        return '${entry.senderName} marked their share as paid in ${entry.groupName}';
      case NotificationType.paymentConfirmed:
        return '${entry.senderName} confirmed your payment in ${entry.groupName}';
      case NotificationType.paymentDisputed:
        return '${entry.senderName} disputed your payment in ${entry.groupName}';
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final (icon, resolveColor) = _iconAndColorResolver;
    final color = resolveColor(colors);

    return InkWell(
      onTap: () {
        ref.read(notificationControllerProvider.notifier).markRead(entry.id);
        context.pushNamed(
          AppRoutes.splitGroupDetail.name,
          pathParameters: {'groupId': entry.groupId},
        );
      },
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
                    _label,
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
                    _timeAgo(entry.createdAt),
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
