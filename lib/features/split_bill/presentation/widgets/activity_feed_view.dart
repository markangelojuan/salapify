import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/split_bill/domain/entities/activity_entry.dart';
import 'package:salapify/features/split_bill/domain/utils/link_utils.dart';
import 'package:salapify/features/split_bill/domain/utils/mention_utils.dart';
import 'package:salapify/features/split_bill/presentation/widgets/member_avatar.dart';
import 'package:salapify/features/authentication/domain/entities/avatar_option.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:salapify/l10n/app_localizations.dart';
import 'package:salapify/features/authentication/presentation/widgets/avatar_name_text.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final void Function(Offset position, String userId, String username)
  onAvatarLongPress;

  String _senderName(ActivityEntry entry, AppLocalizations l10n) =>
      names[entry.senderId] ?? l10n.activityFormerMemberCap;

  String? _targetName(String? targetId, AppLocalizations l10n) =>
      targetId != null ? (names[targetId] ?? l10n.activityFormerMember) : null;

  String _label(ActivityEntry entry, AppLocalizations l10n) {
    final senderName = _senderName(entry, l10n);
    switch (entry.type) {
      case ActivityType.message:
        return entry.text ?? '';
      case ActivityType.billAdded:
        final title = '${entry.metadata?['billTitle'] ?? l10n.activityABill}';
        final amount = entry.metadata?['amount'];
        final amountValue = amount is num
            ? amount
            : num.tryParse(amount?.toString() ?? '');
        return amountValue != null
            ? l10n.activityBillAddedAmount(
                senderName,
                title,
                currency.format(amountValue),
              )
            : l10n.activityBillAdded(senderName, title);
      case ActivityType.paymentMarked:
        return l10n.activityPaymentMarked(senderName);
      case ActivityType.paymentConfirmed:
        {
          final targetId = entry.metadata?['targetUserId'] as String?;
          final targetName = _targetName(targetId, l10n);
          return targetName != null
              ? l10n.activityPaymentConfirmedTarget(senderName, targetName)
              : l10n.activityPaymentConfirmed(senderName);
        }
      case ActivityType.paymentDisputed:
        {
          final targetId = entry.metadata?['targetUserId'] as String?;
          final targetName = _targetName(targetId, l10n);
          return targetName != null
              ? l10n.activityPaymentDisputedTarget(senderName, targetName)
              : l10n.activityPaymentDisputed(senderName);
        }
      case ActivityType.memberAdded:
        final targetId = entry.metadata?['targetUserId'] as String?;
        final targetName = _targetName(targetId, l10n) ?? l10n.activitySomeone;
        return l10n.activityMemberAdded(senderName, targetName);
      case ActivityType.poke:
        final character =
            avatarById(
              members[entry.senderId]?.avatarId,
            )?.localizedName(l10n) ??
            l10n.activityFormerBeast;
        final article = 'AEIOU'.contains(character[0]) ? 'An' : 'A';
        return l10n.activityPoke(article, character);
      case ActivityType.photo:
        return l10n.activityPhotoSent(senderName);
    }
  }

  /// Chat message body. Renders mention ranges (bold, tinted) and tappable
  /// links. Falls back to plain text when there is nothing to decorate.
  Widget _messageText(ActivityEntry entry, AppColorsExt colors) {
    final text = entry.text ?? '';
    final ranges = <(int, int, String)>[];
    final raw = entry.metadata?['mentions'];
    if (raw is List) {
      for (final m in raw) {
        if (m is! Map) continue;
        final s = (m['start'] as num?)?.toInt();
        final e = (m['end'] as num?)?.toInt();
        final id = m['userId'];
        if (s == null || e == null || id is! String) continue;
        if (s < 0 || e > text.length || s >= e) continue;
        // former member -> plain text ("@everyone" is always valid)
        if (id != MentionUtils.everyoneId && !members.containsKey(id)) continue;
        ranges.add((s, e, id));
      }
      ranges.sort((a, b) => a.$1.compareTo(b.$1));
    }

    if (ranges.isEmpty && !LinkUtils.hasUrl(text)) {
      return Text(
        text,
        style: TextStyle(fontSize: 15, color: colors.textPrimary),
      );
    }
    return _MessageRichText(
      text: text,
      mentions: ranges,
      currentUid: currentUid,
      colors: colors,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _dayLabel(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) return l10n.dateToday;
    if (target == yesterday) return l10n.dateYesterday;
    // Only show year if it's not the current year.
    return target.year == now.year
        ? l10n.dateMonthDay(target)
        : l10n.dateMonthDayYear(target);
  }

  List<Object> _buildDisplayItems(List<ActivityEntry> source) {
    final ascending = <Object>[];
    for (var i = source.length - 1; i >= 0; i--) {
      final entry = source[i];
      final prev = i + 1 < source.length ? source[i + 1] : null;
      if (prev == null || !_isSameDay(entry.createdAt, prev.createdAt)) {
        ascending.add(entry.createdAt);
      }
      ascending.add(entry);
    }
    return ascending.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final visibleActivity = activity
        .where((e) => !blockedUserIds.contains(e.senderId))
        .toList();

    if (visibleActivity.isEmpty) {
      return Center(
        child: Text(
          l10n.activityEmpty,
          style: TextStyle(fontSize: 12, color: colors.textSecondary),
        ),
      );
    }

    final displayItems = _buildDisplayItems(visibleActivity);

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
          return _DayDivider(label: _dayLabel(item, l10n));
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
                label: _label(entry, l10n),
              ),
            ),
          );
        }

        final senderName = _senderName(entry, l10n);
        final isCurrentMember = members.containsKey(entry.senderId);

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
                      onLongPress: isCurrentMember
                          ? (pos) => onAvatarLongPress(
                              pos,
                              entry.senderId,
                              senderName,
                            )
                          : null,
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
                          _messageText(entry, colors),
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

  String _expiryLabel(AppLocalizations l10n) {
    final exp = expiresAt;
    if (exp == null) return l10n.photoExpiresIn3Days;
    final mins = exp.difference(DateTime.now()).inMinutes;
    if (mins >= 1440) return l10n.photoExpiresInDays((mins / 1440).ceil());
    if (mins >= 60) return l10n.photoExpiresInHours(mins ~/ 60);
    return l10n.photoExpiresInMinutes(mins < 1 ? 1 : mins);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          l10n.photoExpired,
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
              child: Text(
                _expiryLabel(l10n),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 10),
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

/// Message body with mention spans and tappable links. Stateful only so the
/// tap recognizers can be disposed.
class _MessageRichText extends StatefulWidget {
  const _MessageRichText({
    required this.text,
    required this.mentions,
    required this.currentUid,
    required this.colors,
  });

  final String text;
  final List<(int, int, String)> mentions;
  final String? currentUid;
  final AppColorsExt colors;

  @override
  State<_MessageRichText> createState() => _MessageRichTextState();
}

class _MessageRichTextState extends State<_MessageRichText> {
  final _recognizers = <TapGestureRecognizer>[];

  void _clearRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _clearRecognizers();
    super.dispose();
  }

  Future<void> _open(String url) async {
    final uri = LinkUtils.toUri(url);
    if (uri == null) {
      _showOpenError();
      return;
    }

    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        final c = Theme.of(ctx).extension<AppColorsExt>()!;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(l10n.linkOpenTitle),
          content: Text(
            l10n.linkOpenMessage('$uri'),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: c.textPrimary,
                side: BorderSide(color: c.border),
                shape: const StadiumBorder(),
              ),
              child: Text(l10n.commonCancel),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: OutlinedButton.styleFrom(
                foregroundColor: c.primary,
                side: BorderSide(color: c.primary),
                shape: const StadiumBorder(),
              ),
              child: Text(l10n.commonOpen),
            ),
          ],
        );
      },
    );
    if (go != true || !mounted) return;

    var ok = false;
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok) _showOpenError();
  }

  void _showOpenError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).linkOpenFailed)),
    );
  }

  void _addPlain(List<InlineSpan> spans, String segment) {
    var cursor = 0;
    for (final r in LinkUtils.ranges(segment)) {
      final s = r['start'] as int;
      final e = r['end'] as int;
      if (s > cursor) spans.add(TextSpan(text: segment.substring(cursor, s)));
      final url = segment.substring(s, e);
      final rec = TapGestureRecognizer()..onTap = () => _open(url);
      _recognizers.add(rec);
      spans.add(
        TextSpan(
          text: url,
          recognizer: rec,
          style: TextStyle(
            color: widget.colors.primary,
            decoration: TextDecoration.underline,
            decorationColor: widget.colors.primary,
          ),
        ),
      );
      cursor = e;
    }
    if (cursor < segment.length) {
      spans.add(TextSpan(text: segment.substring(cursor)));
    }
  }

  @override
  Widget build(BuildContext context) {
    _clearRecognizers();
    final colors = widget.colors;
    final text = widget.text;
    final spans = <InlineSpan>[];
    var cursor = 0;

    for (final r in widget.mentions) {
      if (r.$1 < cursor) continue; // skip overlapping ranges
      if (r.$1 > cursor) _addPlain(spans, text.substring(cursor, r.$1));
      spans.add(
        TextSpan(
          text: text.substring(r.$1, r.$2),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: colors.primary,
            backgroundColor:
                (r.$3 == widget.currentUid || r.$3 == MentionUtils.everyoneId)
                ? colors.primary.withValues(alpha: 0.15)
                : null,
          ),
        ),
      );
      cursor = r.$2;
    }
    if (cursor < text.length) _addPlain(spans, text.substring(cursor));

    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 15, color: colors.textPrimary),
        children: spans,
      ),
    );
  }
}
