import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum BackgroundVariant { signIn, signUp }

class BackgroundDecoration extends StatelessWidget {
  final Color color;
  final BackgroundVariant variant;

  const BackgroundDecoration({
    super.key,
    required this.color,
    this.variant = BackgroundVariant.signIn,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == BackgroundVariant.signUp) {
      return Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: _blob(280, color.withOpacity(0.09)),
          ),
          Positioned(
            bottom: -180,
            right: -60,
            child: _blob(650, color.withOpacity(0.09)),
          ),
        ],
      );
    }

    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -60,
          child: _blob(280, color.withOpacity(0.09)),
        ),
        Positioned(
          bottom: -80,
          right: -60,
          child: _blob(230, color.withOpacity(0.17)),
        ),
      ],
    );
  }

  Widget _blob(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scaleXY(end: 1.08, duration: 4.seconds, curve: Curves.easeInOut)
          .moveY(end: -12, duration: 4.seconds, curve: Curves.easeInOut);
}