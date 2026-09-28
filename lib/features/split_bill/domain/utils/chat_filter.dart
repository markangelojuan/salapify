class ChatFilter {
  // Keep this short and deliberate — mild profanity + slurs only.
  static final _badWords = <String>{
    // English
    'fuck', 'shit', 'bitch', 'asshole', 'bastard', 'dick', 'piss',
    'nigga', 'nigger', 'fuck you', 'fuckyou', 'niggas'

    // Filipino/Tagalog
    'gago',
    'putangina',
    'putang ina',
    'tangina',
    'tang ina',
    'siraulo',
    'bobo',
    'tang ina mo',
    'putangina mo',
    'putanginamo',
    'tanginamo',
    'putang ina mo',

    // Thai (romanized)
    'khuay',
    'hia',

    // Mandarin/Hokkien (romanized — common in Taiwan)
    'tamade', 'kanasai', 'sibei',

    // Italian
    'cazzo', 'stronzo', 'vaffanculo',

    // Spanish
    'puta', 'mierda', 'cabron',
  };

  static final _pattern = RegExp(
    r'\b(' +
        (_badWords.toList()..sort((a, b) => b.length.compareTo(a.length)))
            .map(RegExp.escape)
            .join('|') +
        r')\b',
    caseSensitive: false,
  );

  static String mask(String text) {
    return text.replaceAllMapped(_pattern, (m) => '*' * m[0]!.length);
  }

  static bool containsBadWord(String text) => _pattern.hasMatch(text);
}