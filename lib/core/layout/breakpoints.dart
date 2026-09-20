// core/layout/breakpoints.dart
import 'package:flutter/material.dart';


class Breakpoints {
  Breakpoints._();

  static const double compact = 600;   // phones
  static const double medium = 840;    // small/medium tablets, foldables
  static const double expanded = 1200; // large tablets, desktop
}

enum ScreenSize { compact, medium, expanded }

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  ScreenSize get screenSize {
    final w = screenWidth;
    if (w >= Breakpoints.expanded) return ScreenSize.expanded;
    if (w >= Breakpoints.medium) return ScreenSize.medium;
    return ScreenSize.compact;
  }

  bool get isCompact => screenSize == ScreenSize.compact;
  bool get isMedium => screenSize == ScreenSize.medium;
  bool get isExpanded => screenSize == ScreenSize.expanded;
  bool get isTabletOrWider => screenSize != ScreenSize.compact;
}