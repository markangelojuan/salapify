import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const primary = const Color(0xFF3E6B4A);
  static const background = Color(0xFFECE9E9);

  // Background gradient (experiment) — warm coral-orange fading to gold,
  // smoother pairing with FFC000 than the original gray.
  static const backgroundGradientStart = Color(0xFFC9EAD9);
  static const backgroundGradientEnd = Color(0xFFECE9E9);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundGradientStart, backgroundGradientEnd],
  );

  // Neutrals
  static const textPrimary = Color(0xFF2E302E);
  static const border = Color(0xFFD6D8D6);

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}
