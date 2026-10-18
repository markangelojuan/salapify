import 'package:flutter/foundation.dart';

void dlog(String tag, String msg) {
  if (!kDebugMode) return;
  final t = DateTime.now();
  debugPrint(
    '[${t.minute}:${t.second.toString().padLeft(2, '0')}.'
    '${t.millisecond.toString().padLeft(3, '0')}] [$tag] $msg',
  );
}