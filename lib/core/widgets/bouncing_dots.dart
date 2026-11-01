import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Three dots that hop in a staggered wave (typing-indicator style).
///
/// Shared by [CommonButton] and the global loading overlay.
class BouncingDots extends StatefulWidget {
  const BouncingDots({super.key, required this.color, this.dotSize = 8});

  final Color color;
  final double dotSize;

  @override
  State<BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<BouncingDots>
    with SingleTickerProviderStateMixin {
  static const int _dotCount = 3;
  static const double _jumpHeight = 7;

  // Delay between one dot starting its hop and the next (fraction of cycle).
  static const double _stagger = 0.15;

  // Portion of the cycle a single dot spends in the air; the rest is rest time.
  static const double _hopSpan = 0.4;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _offsetFor(int index, double t) {
    final local = (t - index * _stagger) % 1.0;
    if (local >= _hopSpan) return 0;
    // Half a sine wave: smooth up, smooth down.
    return -math.sin(local / _hopSpan * math.pi) * _jumpHeight;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_dotCount, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Transform.translate(
                  offset: Offset(0, _offsetFor(i, _controller.value)),
                  child: Container(
                    width: widget.dotSize,
                    height: widget.dotSize,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}