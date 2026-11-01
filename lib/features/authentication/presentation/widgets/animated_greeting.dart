import 'dart:async';
import 'package:flutter/material.dart';

enum GreetingMode {
  hello('Hello'),
  welcome('Welcome');

  const GreetingMode(this.semanticLabel);

  /// Fixed label read by screen readers instead of the rotating text.
  final String semanticLabel;
}

/// A single greeting word plus the hints Flutter needs to render it correctly.
class Greeting {
  const Greeting(this.text, {this.locale});

  final String text;

  /// Only set where glyph shape depends on locale (e.g. Traditional Chinese).
  final Locale? locale;
}

class AnimatedGreeting extends StatefulWidget {
  const AnimatedGreeting({
    super.key,
    this.mode = GreetingMode.hello,
    this.interval = const Duration(seconds: 2),
  });

  final GreetingMode mode;
  final Duration interval;

  static const Locale _zhTW = Locale('zh', 'TW');

  static const Map<GreetingMode, List<Greeting>> words = {
    GreetingMode.hello: [
      Greeting('Hello'), // English
      Greeting('Kumusta'), // Filipino
      Greeting('Ciao'), // Italian
      Greeting('नमस्ते'), // Hindi / Nepali
      Greeting('Halo'), // Indonesian
      Greeting('สวัสดี'), // Thai
      Greeting('Merhaba'), // Turkish
      Greeting('হ্যালো'), // Bengali
      Greeting('Cześć'), // Polish
      Greeting('你好', locale: _zhTW), // Chinese (Taiwan / Hong Kong)
      Greeting('Hola'), // Spanish
      Greeting('Hallo'), // Dutch
      Greeting('Helo'), // Malay
    ],
    GreetingMode.welcome: [
      Greeting('Maligayang pagdating'), // Filipino
      Greeting('Welcome'), // English
      Greeting('ยินดีต้อนรับ'), // Thai
      Greeting('Benvenuto'), // Italian
      Greeting('Selamat datang'), // Indonesian / Malay
      Greeting('Hoş geldiniz'), // Turkish
      Greeting('স্বাগতম'), // Bengali
      Greeting('Bienvenido'), // Spanish
      Greeting('स्वागत है'), // Hindi
      Greeting('Welkom'), // Dutch
      Greeting('स्वागत छ'), // Nepali
      Greeting('Witamy'), // Polish
      Greeting('歡迎', locale: _zhTW), // Chinese (Taiwan / Hong Kong)
    ],
  };

  @override
  State<AnimatedGreeting> createState() => _AnimatedGreetingState();
}

class _AnimatedGreetingState extends State<AnimatedGreeting> {
  int _index = 0;
  Timer? _timer;

  List<Greeting> get _greetings => AnimatedGreeting.words[widget.mode]!;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant AnimatedGreeting oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) {
      // Lists can have different lengths, so never keep a stale index.
      _index = 0;
    }
    if (oldWidget.interval != widget.interval) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) {
      if (!mounted) return;
      // Respect the system "reduce motion" / remove animations setting.
      if (MediaQuery.disableAnimationsOf(context)) return;
      setState(() {
        _index = (_index + 1) % _greetings.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _greetings[_index];

    // Lock line height to the inherited title style so scripts with tall
    // marks (Thai, Bengali, Hindi) can't change the header's height.
    final strut = StrutStyle.fromTextStyle(
      DefaultTextStyle.of(context).style,
      forceStrutHeight: true,
    );

    return Semantics(
      label: widget.mode.semanticLabel,
      excludeSemantics: true,
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          // Fade-only crossfade, both children pinned left. No slide,
          // no stack-centering, no size animation.
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none, // don't clip tall glyph marks
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: FittedBox(
            key: ValueKey('${widget.mode.name}-$_index'),
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              greeting.text,
              locale: greeting.locale,
              maxLines: 1,
              strutStyle: strut,
            ),
          ),
        ),
      ),
    );
  }
}