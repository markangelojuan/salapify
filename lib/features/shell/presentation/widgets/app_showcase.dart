import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:salapify/core/theme/app_colors.dart';

/// Themed wrapper around [Showcase] so every tour step matches the app.
class AppShowcase extends StatelessWidget {
  const AppShowcase({
    super.key,
    required this.showcaseKey,
    required this.title,
    required this.description,
    required this.child,
    this.circle = false,
  });

  final GlobalKey showcaseKey;
  final String title;
  final String description;
  final Widget child;

  /// Use a round spotlight (e.g. for the FAB).
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Showcase(
      key: showcaseKey,
      title: title,
      description: description,
      titleTextAlign: TextAlign.center,
      descriptionTextAlign: TextAlign.center,
      // Tooltip card
      tooltipBackgroundColor: colors.background,
      tooltipBorderRadius: BorderRadius.circular(20),
      tooltipPadding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: colors.primary,
      ),
      descTextStyle: TextStyle(
        fontSize: 13.5,
        height: 1.4,
        color: colors.textSecondary,
      ),
      // Dimmed backdrop + spotlight
      overlayColor: Colors.black,
      overlayOpacity: 0.72,
      targetPadding: const EdgeInsets.all(6),
      targetShapeBorder: circle
          ? const CircleBorder()
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: child,
    );
  }
}
