import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/split_bill/domain/entities/activity_entry.dart';
import 'package:salapify/features/split_bill/presentation/widgets/member_avatar.dart';
import 'package:intl/intl.dart';

class ActivityFeedView extends StatelessWidget {
  const ActivityFeedView({
    super.key,
    required this.activity,
    required this.currentUid,
    required this.names,
    required this.members,
    required this.scrollController,
    required this.loadingMore,
    required this.currency,
  });

  final List<ActivityEntry> activity;
  final String? currentUid;
  final Map<String, String> names;
  final Map<String, GroupMemberInfo> members;
  final ScrollController scrollController;
  final bool loadingMore;
  final NumberFormat currency;

  String _label(ActivityEntry entry) {
    final senderName = names[entry.senderId] ?? '...';
    switch (entry.type) {
      case ActivityType.message:
        return entry.text ?? '';
      case ActivityType.billAdded:
        final title = entry.metadata?['billTitle'] ?? 'a bill';
        final amount = entry.metadata?['amount'];
        final amountValue = amount is num
            ? amount
            : num.tryParse(amount?.toString() ?? '');
        return '$senderName added "$title"'
            '${amountValue != null ? ' — ${currency.format(amountValue)}' : ''}';
      case ActivityType.paymentMarked:
        return '$senderName marked their share as paid';
      case ActivityType.paymentConfirmed:
        {
          final targetId = entry.metadata?['targetUserId'] as String?;
          final targetName = targetId != null
              ? (names[targetId] ?? '...')
              : null;
          return targetName != null
              ? '$senderName confirmed $targetName\'s payment'
              : '$senderName confirmed a payment';
        }
      case ActivityType.paymentDisputed:
        {
          final targetId = entry.metadata?['targetUserId'] as String?;
          final targetName = targetId != null
              ? (names[targetId] ?? '...')
              : null;
          return targetName != null
              ? '$senderName disputed $targetName\'s payment'
              : '$senderName disputed a payment';
        }
      case ActivityType.memberAdded:
        final targetId = entry.metadata?['targetUserId'] as String?;
        final targetName = targetId != null
            ? (names[targetId] ?? '...')
            : 'someone';
        return '$senderName added $targetName to the group';
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _dayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) return 'Today';
    if (target == yesterday) return 'Yesterday';
    // Only show year if it's not the current year.
    return DateFormat(
      target.year == now.year ? 'MMM d' : 'MMM d, yyyy',
    ).format(target);
  }

  List<Object> _buildDisplayItems() {
    // Walk oldest -> newest so each divider lands before that day's first
    // message, then reverse once at the end for the reverse:true list.
    final ascending = <Object>[];
    for (var i = activity.length - 1; i >= 0; i--) {
      final entry = activity[i];
      final prev = i + 1 < activity.length ? activity[i + 1] : null;
      if (prev == null || !_isSameDay(entry.createdAt, prev.createdAt)) {
        ascending.add(entry.createdAt);
      }
      ascending.add(entry);
    }
    return ascending.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (activity.isEmpty) {
      return Center(
        child: Text(
          'No activity yet',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    final displayItems = _buildDisplayItems();

    return ListView.builder(
      reverse: true,
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: displayItems.length + (loadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (loadingMore && index == displayItems.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final item = displayItems[index];

        if (item is DateTime) {
          return _DayDivider(label: _dayLabel(item));
        }

        final entry = item as ActivityEntry;
        final isMine = entry.senderId == currentUid;
        final isMessage = entry.type == ActivityType.message;

        if (!isMessage) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Center(
              child: _SystemActivityPill(
                type: entry.type,
                label: _label(entry),
              ),
            ),
          );
        }

        final senderName = names[entry.senderId] ?? '...';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Align(
            alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMine) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: MemberAvatar(
                      avatarId: members[entry.senderId]?.avatarId,
                      radius: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isMine
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isMine)
                          Text(
                            senderName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        Text(
                          _label(entry),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Icon-badged pill for non-message activity (bill added, payment
/// marked/confirmed/disputed), replacing bare centered gray text with the
/// app's chip/pill language so system events read as distinct events.
class _SystemActivityPill extends StatelessWidget {
  const _SystemActivityPill({required this.type, required this.label});

  final ActivityType type;
  final String label;

  (IconData, Color) get _iconAndColor {
    switch (type) {
      case ActivityType.billAdded:
        return (Icons.receipt_long_rounded, AppColors.primary);
      case ActivityType.paymentMarked:
        return (Icons.hourglass_top_rounded, Colors.orange[700]!);
      case ActivityType.paymentConfirmed:
        return (Icons.check_circle_rounded, Colors.green[700]!);
      case ActivityType.paymentDisputed:
        return (Icons.error_rounded, Colors.red[600]!);
      case ActivityType.memberAdded:
        return (Icons.person_add_rounded, AppColors.primary);
      case ActivityType.message:
        return (Icons.chat_bubble_rounded, AppColors.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _iconAndColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayDivider extends StatelessWidget {
  const _DayDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
