import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

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
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: resolvedLabelColor,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: resolvedLabelColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}