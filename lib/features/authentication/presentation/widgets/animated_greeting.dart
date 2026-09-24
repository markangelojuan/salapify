import 'dart:async';
import 'package:flutter/material.dart';

enum GreetingMode { hello, welcome }

class AnimatedGreeting extends StatefulWidget {
  const AnimatedGreeting({
    super.key,
    this.mode = GreetingMode.hello,
    this.interval = const Duration(seconds: 2),
  });

  final GreetingMode mode;
  final Duration interval;

  static const Map<GreetingMode, List<String>> words = {
    GreetingMode.hello: [
      "Kumusta",  // Philippines
      "Hello",    // USA
      "Sawasdee", // Thailand
      "Nǐ hǎo",   // Taiwan
      "Ciao",     // Italy
      "Hola",     // Spain
    ],
    GreetingMode.welcome: [
      "Maligayang pagdating", // Philippines
      "Welcome",              // USA
      "Yindee",                // Thailand
      "Huānyíng",              // Taiwan
      "Benvenuto",             // Italy
      "Bienvenido",            // Spain
    ],
  };

  @override
  State<AnimatedGreeting> createState() => _AnimatedGreetingState();
}

class _AnimatedGreetingState extends State<AnimatedGreeting> {
  int _index = 0;
  Timer? _timer;

  List<String> get _words => AnimatedGreeting.words[widget.mode]!;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (_) {
      if (!mounted) return;
      setState(() {
        _index = (_index + 1) % _words.length;
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
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        // Fade-only crossfade, both children pinned left — no slide,
        // no stack-centering, no size animation.
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Align(
          key: ValueKey(_index),
          alignment: Alignment.centerLeft,
          child: Text(_words[_index]),
        ),
      ),
    );
  }
}