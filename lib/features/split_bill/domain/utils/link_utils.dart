class LinkUtils {
  static final _urlRe = RegExp(
    r'(?:https?:\/\/|www\.)[^\s<>]+',
    caseSensitive: false,
  );

  static const _trailing = '.,;:!?)]}\'"';

  /// Ranges of URLs in [text] as `{start, end}` maps (same shape as mention
  /// ranges, so they can be passed to `MentionUtils.maskOutside`).
  static List<Map<String, dynamic>> ranges(String text) {
    final out = <Map<String, dynamic>>[];
    for (final m in _urlRe.allMatches(text)) {
      var end = m.end;
      while (end > m.start && _trailing.contains(text[end - 1])) {
        end--;
      }
      final url = text.substring(m.start, end);
      if (url.toLowerCase() == 'www.' || url.toLowerCase().endsWith('://')) {
        continue;
      }
      out.add({'start': m.start, 'end': end});
    }
    return out;
  }

  static bool hasUrl(String text) => ranges(text).isNotEmpty;

  /// Normalizes "www.x.com" to a launchable https URI. Only http/https
  /// are ever returned.
  static Uri? toUri(String url) {
    final withScheme = url.toLowerCase().startsWith('http')
        ? url
        : 'https://$url';
    final uri = Uri.tryParse(withScheme);
    if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https')) {
      return null;
    }
    if (uri.host.isEmpty) return null;
    return uri;
  }
}