import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColorsExt.light.primary,
      brightness: Brightness.light,
    ),
    extensions: const [AppColorsExt.light],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColorsExt.light.primary,
      centerTitle: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      elevation: 0,
      backgroundColor: AppColorsExt.light.surface,
      indicatorColor: AppColorsExt.light.primary.withValues(alpha: 0.15),

      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),

      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: AppColorsExt.light.primary, size: 24);
        }

        return IconThemeData(color: AppColorsExt.light.textPrimary, size: 22);
      }),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    scaffoldBackgroundColor: Colors.transparent,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColorsExt.dark.primary,
      brightness: Brightness.dark,
    ),
    extensions: const [AppColorsExt.dark],
    appBarTheme: AppBarTheme(
      
      backgroundColor: AppColorsExt.dark.surface,
      foregroundColor: Colors.white,
      centerTitle: false,
    ),

    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      elevation: 0,
      backgroundColor: AppColorsExt.dark.surface,
      indicatorColor: AppColorsExt.dark.primary.withValues(alpha: 0.20),

      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),

      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          // FIX: was AppColors.primary (light theme's green) — now uses
          // the dark theme's own primary so selection is visible in dark mode.
          return IconThemeData(color: AppColorsExt.dark.primary, size: 24);
        }
        return IconThemeData(
          color: AppColorsExt.dark.textSecondary,
          size: 22,
        );
      }),
    ),
  );
}