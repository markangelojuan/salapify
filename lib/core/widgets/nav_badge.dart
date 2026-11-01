import 'package:flutter/material.dart';

/// Badges a nav icon with a count, capped at "9+". Reusable across bottom
/// nav tabs (Split Bill now, Notifications later) for a consistent look.
class NavBadge extends StatelessWidget {
  const NavBadge({super.key, required this.count, required this.child});

  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text(count > 9 ? '9+' : '$count'),
      isLabelVisible: count > 0,
      backgroundColor: Colors.red[600],
      child: child,
    );
  }
}