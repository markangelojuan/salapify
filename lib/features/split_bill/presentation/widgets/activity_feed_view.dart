import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/split_bill/domain/entities/activity_entry.dart';
import 'package:salapify/features/split_bill/presentation/widgets/member_avatar.dart';
import 'package:salapify/features/authentication/domain/entities/avatar_option.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    required this.blockedUserIds,
    required this.onAvatarLongPress,
  });

  final List<ActivityEntry> activity;
  final String? currentUid;
  final Map<String, String> names;
  final Map<String, GroupMemberInfo> members;
  final ScrollController scrollController;
  final bool loadingMore;
  final NumberFormat currency;
  final Set<String> blockedUserIds;
  final void Function(Offset position, String userId, String username) onAvatarLongPress;

  String _senderName(ActivityEntry entry) =>
      names[entry.senderId] ?? 'A former member';

  String? _targetName(String? targetId) =>
      targetId != null ? (names[targetId] ?? 'a former member') : null;

  String _label(ActivityEntry entry) {
    final senderName = _senderName(entry);
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
          final targetName = _targetName(targetId);
          return targetName != null
              ? '$senderName confirmed $targetName\'s payment'
              : '$senderName confirmed a payment';
        }
      case ActivityType.paymentDisputed:
        {
          final targetId = entry.metadata?['targetUserId'] as String?;
          final targetName = _targetName(targetId);
          return targetName != null
              ? '$senderName disputed $targetName\'s payment'
              : '$senderName disputed a payment';
        }
      case ActivityType.memberAdded:
        final targetId = entry.metadata?['targetUserId'] as String?;
        final targetName = _targetName(targetId) ?? 'someone';
        return '$senderName added $targetName to the group';
      case ActivityType.poke:
        final character =
            avatarById(members[entry.senderId]?.avatarId)?.name ?? 'Someone';
        final article = 'AEIOU'.contains(character[0]) ? 'An' : 'A';
        return '$article $character poked the group!';
      case ActivityType.photo:
        return '$senderName sent a photo';
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
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final visibleActivity = activity
        .where((e) => !blockedUserIds.contains(e.senderId))
        .toList();

    if (visibleActivity.isEmpty) {
      return Center(
        child: Text(
          'No activity yet',
          style: TextStyle(fontSize: 12, color: colors.textSecondary),
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
        final isMessage =
            entry.type == ActivityType.message ||
            entry.type == ActivityType.photo;

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

        final senderName = _senderName(entry);

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
                      onLongPress: (pos) => onAvatarLongPress(pos, entry.senderId, senderName),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Container(
                    padding: entry.type == ActivityType.photo
                        ? const EdgeInsets.all(2)
                        : const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isMine
                          ? colors.primary.withValues(alpha: 0.15)
                          : colors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isMine)
                          Padding(
                            padding: entry.type == ActivityType.photo
                                ? const EdgeInsets.only(
                                    left: 8,
                                    top: 6,
                                    bottom: 6,
                                  )
                                : EdgeInsets.zero,
                            child: Text(
                              senderName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        if (entry.type == ActivityType.photo)
                          _ActivityPhoto(
                            url: entry.metadata?['photoUrl'] as String?,
                            expiresAt: DateTime.tryParse(
                              entry.metadata?['expiresAt'] as String? ?? '',
                            ),
                            isUploading: entry.isUploading,
                            uploadFailed: entry.uploadFailed,
                          )
                        else
                          Text(
                            _label(entry),
                            style: TextStyle(
                              fontSize: 15,
                              color: colors.textPrimary,
                            ),
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

  (IconData, Color) _iconAndColor(AppColorsExt colors) {
    switch (type) {
      case ActivityType.billAdded:
        return (Icons.receipt_long_rounded, colors.primary);
      case ActivityType.paymentMarked:
        return (Icons.hourglass_top_rounded, colors.warning);
      case ActivityType.paymentConfirmed:
        return (Icons.check_circle_rounded, colors.primary);
      case ActivityType.paymentDisputed:
        return (Icons.error_rounded, colors.error);
      case ActivityType.memberAdded:
        return (Icons.person_add_rounded, colors.primary);
      case ActivityType.poke:
        return (
          Icons.back_hand_rounded,
          const Color.fromARGB(255, 43, 27, 185),
        );
      case ActivityType.message:
        return (Icons.chat_bubble_rounded, colors.primary);
      case ActivityType.photo:
        return (Icons.image_rounded, colors.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final (icon, color) = _iconAndColor(colors);
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
                color: colors.textSecondary,
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
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colors.textSecondary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityPhoto extends StatelessWidget {
  const _ActivityPhoto({
    required this.url,
    required this.expiresAt,
    this.isUploading = false,
    this.uploadFailed = false,
  });

  final String? url;
  final DateTime? expiresAt;
  final bool isUploading;
  final bool uploadFailed;

  bool get _isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    // Optimistic placeholder — shown immediately on send, before the
    // upload + Firestore write complete.
    if (isUploading || uploadFailed) {
      return Container(
        width: 220,
        height: 220,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.border.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colors.border.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        child: uploadFailed
            ? Icon(Icons.error_outline_rounded, color: colors.error, size: 32)
            : SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.primary,
                ),
              ),
      );
    }

    if (url == null || _isExpired) {
      return Container(
        width: 220,
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.border.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          'Photo expired',
          style: TextStyle(color: colors.textSecondary, fontSize: 13),
        ),
      );
    }
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (_) => _PhotoViewerDialog(url: url!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CachedNetworkImage(
              imageUrl: url!,
              width: 220,
              height: 220,
              fit: BoxFit.cover,
              memCacheWidth: 220, // decode at display size, not full res
              placeholder: (context, url) => const SizedBox(
                width: 220,
                height: 220,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (context, url, error) => const SizedBox(
                width: 220,
                height: 220,
                child: Center(child: Icon(Icons.broken_image_rounded)),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: Colors.black.withValues(alpha: 0.45),
              child: const Text(
                'This photo will expire in 3 days',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoViewerDialog extends StatelessWidget {
  const _PhotoViewerDialog({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
