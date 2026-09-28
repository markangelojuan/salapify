import 'package:flutter/widgets.dart';
import 'package:salapify/features/split_bill/domain/utils/chat_filter.dart';

class MentionQuery {
  const MentionQuery(this.start, this.query);
  final int start; // index of the '@'
  final String query;
}

class MentionUtils {
  /// Pseudo user id stored in `metadata.mentions` for "@everyone".
  /// Real ids are Firebase uids, so this can't collide.
  static const everyoneId = '__everyone__';
  static const everyoneName = 'everyone';

  static final _activeRe = RegExp(r'(^|\s)@([^\s@]*)$');
  static final _ws = RegExp(r'\s');
  static final _wordChar = RegExp(r'[\p{L}\p{N}_]', unicode: true);

  /// Active "@query" immediately before the cursor, or null.
  static MentionQuery? activeQuery(TextEditingValue v) {
    final sel = v.selection;
    if (!sel.isValid || !sel.isCollapsed) return null;
    final before = v.text.substring(0, sel.baseOffset);
    final m = _activeRe.firstMatch(before);
    if (m == null) return null;
    final q = m.group(2)!;
    return MentionQuery(sel.baseOffset - q.length - 1, q);
  }

  /// Resolve at send time: find "@username" for each picked user in the
  /// FINAL (already trimmed) text. Deleted/edited mentions simply don't match.
  static List<Map<String, dynamic>> resolve(
    String text,
    Map<String, String> picked, // userId -> username
  ) {
    final ranges = <Map<String, dynamic>>[];
    bool overlaps(int s, int e) => ranges.any(
      (r) => s < (r['end'] as int) && e > (r['start'] as int),
    );

    final entries = picked.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length)); // longest first
    for (final e in entries) {
      final token = '@${e.value}';
      var from = 0;
      while (true) {
        final i = text.indexOf(token, from);
        if (i < 0) break;
        final end = i + token.length;
        final okBefore = i == 0 || _ws.hasMatch(text[i - 1]);
        final okAfter = end == text.length || !_wordChar.hasMatch(text[end]);
        if (okBefore && okAfter && !overlaps(i, end)) {
          ranges.add({'userId': e.key, 'start': i, 'end': end});
        }
        from = end;
      }
    }
    ranges.sort((a, b) => (a['start'] as int).compareTo(b['start'] as int));
    return ranges;
  }

  /// Profanity-mask everything except protected ranges (mentions/links).
  /// Length-preserving, so offsets stay valid. Ranges must be sorted by
  /// start; overlapping or out-of-bounds ranges are skipped safely.
  static String maskOutside(String text, List<Map<String, dynamic>> ranges) {
    final buf = StringBuffer();
    var cursor = 0;
    for (final r in ranges) {
      final s = r['start'] as int;
      final e = r['end'] as int;
      if (s < cursor || e > text.length || s >= e) continue; // guard
      buf.write(ChatFilter.mask(text.substring(cursor, s)));
      buf.write(text.substring(s, e));
      cursor = e;
    }
    buf.write(ChatFilter.mask(text.substring(cursor)));
    return buf.toString();
  }
}