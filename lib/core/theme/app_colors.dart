import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const primary = const Color(0xFF3E6B4A);
  static const background = Color(0xFFECE9E9);

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

@immutable
class AppColorsExt extends ThemeExtension<AppColorsExt> {
  const AppColorsExt({
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.surface,
    required this.background,
    required this.backgroundGradient,
    required this.primary,
    required this.onPrimary,
    required this.error,
    required this.warning,
  });

  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color surface;
  final Color background;
  final LinearGradient backgroundGradient;
  final Color primary;
  final Color onPrimary;
  final Color error;
  final Color warning;

  static const light = AppColorsExt(
    textPrimary: Color(0xFF2E302E),
    textSecondary: Color(0xFF6B6D6B),
    border: Color(0xFFD6D8D6),
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFECE9E9),
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFC9EAD9), Color(0xFFECE9E9)],
    ),
    primary: Color(0xFF3E6B4A),
    onPrimary: Color(0xFFFFFFFF),
    error: Color(0xFFD64545),
    warning: Color(0xFFE0902E),
  );

  static const dark = AppColorsExt(
    textPrimary: Color(0xFFECE9E9),
    textSecondary: Color(0xFFA0A0A0),
    border: Color(0xFF3A3A3A),
    surface: Color(0xFF1E1E1E),
    background: Color(0xFF121212),
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF121212), Color(0xFF121212)],
    ),
    primary: Color(0xFF5C9470),
    onPrimary: Color(0xFFFFFFFF),
    error: Color(0xFFE57373),
    warning: Color(0xFFE0A94E),
  );

  @override
  AppColorsExt copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? surface,
    Color? background,
    LinearGradient? backgroundGradient,
    Color? primary,
    Color? onPrimary,
    Color? error,
    Color? warning,
  }) {
    return AppColorsExt(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      surface: surface ?? this.surface,
      background: background ?? this.background,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      error: error ?? this.error,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppColorsExt lerp(ThemeExtension<AppColorsExt>? other, double t) {
    if (other is! AppColorsExt) return this;
    return AppColorsExt(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      backgroundGradient: LinearGradient.lerp(
        backgroundGradient,
        other.backgroundGradient,
        t,
      )!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}