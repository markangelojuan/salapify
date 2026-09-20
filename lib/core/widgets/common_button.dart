import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/bouncing_dots.dart';

class CommonButton extends StatelessWidget {
  final Color? btnColor;
  final Color? labelColor;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CommonButton({
    super.key,
    this.btnColor,
    this.labelColor,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final resolvedBtnColor = btnColor ?? colors.primary;

    final resolvedLabelColor = labelColor ?? colors.onPrimary;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: resolvedBtnColor,
          disabledBackgroundColor: resolvedBtnColor.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // Cross-fades (with a slight scale) between the label and the dots
        // instead of snapping, so the loading state feels smooth.
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
              child: child,
            ),
          ),
          child: isLoading
              ? BouncingDots(
                  key: const ValueKey('loading'),
                  color: resolvedLabelColor,
                )
              : Text(
                  label,
                  key: const ValueKey('label'),
                  style: TextStyle(
                    color: resolvedLabelColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}