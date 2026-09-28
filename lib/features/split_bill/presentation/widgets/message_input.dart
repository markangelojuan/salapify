import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/split_bill/domain/utils/mention_utils.dart';
import 'package:salapify/features/split_bill/presentation/widgets/member_avatar.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onPoke,
    required this.onAddPhoto,
    this.maxCharacters,
    this.mentionCandidates = const {},
    this.onMentionPicked,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPoke;
  final VoidCallback onAddPhoto;
  final int? maxCharacters;

  /// userId -> member info. Already filtered by the parent (no self,
  /// no blocked users, current members only).
  final Map<String, GroupMemberInfo> mentionCandidates;
  final void Function(String userId, String username)? onMentionPicked;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  MentionQuery? _query;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant MessageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    final q = MentionUtils.activeQuery(widget.controller.value);
    if (q?.start != _query?.start || q?.query != _query?.query) {
      setState(() => _query = q);
    }
  }

  List<MapEntry<String, GroupMemberInfo>> get _matches {
    final q = _query;
    if (q == null) return const [];
    final needle = q.query.toLowerCase();
    final list = widget.mentionCandidates.entries
        .where((e) => e.value.username.toLowerCase().contains(needle))
        .toList();
    list.sort((a, b) {
      final an = a.value.username.toLowerCase();
      final bn = b.value.username.toLowerCase();
      final byIndex = an.indexOf(needle).compareTo(bn.indexOf(needle));
      return byIndex != 0 ? byIndex : an.compareTo(bn);
    });
    // "@everyone" always sits on top while the typed query is a prefix of it.
    if (widget.mentionCandidates.isNotEmpty &&
        MentionUtils.everyoneName.startsWith(needle)) {
      list.insert(
        0,
        const MapEntry(
          MentionUtils.everyoneId,
          GroupMemberInfo(username: MentionUtils.everyoneName),
        ),
      );
    }
    return list;
  }

  void _pick(String id, String username) {
    final q = _query;
    if (q == null) return;
    final c = widget.controller;
    final cursor = c.selection.baseOffset;
    if (cursor < q.start) return;

    final insert = '@$username ';
    final newText = c.text.replaceRange(q.start, cursor, insert);

    // Programmatic value changes bypass inputFormatters, so enforce the
    // character limit here.
    final max = widget.maxCharacters;
    if (max != null && newText.length > max) return;

    c.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: q.start + insert.length),
    );
    widget.onMentionPicked?.call(id, username);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final matches = _matches;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (matches.isNotEmpty)
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
            ),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: matches.length,
                itemBuilder: (_, i) {
                  final e = matches[i];
                  final isEveryone = e.key == MentionUtils.everyoneId;
                  return ListTile(
                    dense: true,
                    leading: isEveryone
                        ? CircleAvatar(
                            radius: 14,
                            backgroundColor: colors.primary.withValues(
                              alpha: 0.12,
                            ),
                            child: Icon(
                              Icons.groups_rounded,
                              size: 16,
                              color: colors.primary,
                            ),
                          )
                        : MemberAvatar(
                            avatarId: e.value.avatarId,
                            radius: 14,
                          ),
                    title: Text(e.value.username),
                    subtitle: isEveryone
                        ? const Text('Notify all members')
                        : null,
                    onTap: () => _pick(e.key, e.value.username),
                  );
                },
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.add_photo_alternate_rounded,
                  color: colors.primary,
                ),
                tooltip: 'Add photo',
                onPressed: widget.onAddPhoto,
              ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  inputFormatters: widget.maxCharacters != null
                      ? [LengthLimitingTextInputFormatter(widget.maxCharacters)]
                      : null,
                  style: TextStyle(fontSize: 14, color: colors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Message the group...',
                    hintStyle: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: colors.primary.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: colors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: colors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: colors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (_) => widget.onSend(),
                ),
              ),
              const SizedBox(width: 4),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                icon: Icon(Icons.back_hand_rounded, color: colors.primary),
                tooltip: 'Poke the group',
                onPressed: widget.onPoke,
              ),
              const SizedBox(width: 4),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: colors.primary),
                icon: Icon(Icons.send_rounded, color: colors.onPrimary),
                tooltip: 'Send message',
                onPressed: widget.onSend,
              ),
            ],
          ),
        ),
      ],
    );
  }
}