import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

class CommonConfirmationDialog extends StatelessWidget {
  const CommonConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  /// When true, tints the confirm action with the app's error color —
  /// use for deletes and other irreversible actions.
  final bool isDestructive;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => CommonConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  /// Convenience wrapper for the very common "Delete X?" case.
  static Future<bool> confirmDelete(
    BuildContext context, {
    required String itemName,
    String? title,
  }) {
    return show(
      context,
      title: title ?? 'Delete',
      message:
          'Are you sure you want to delete "$itemName"? This cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final confirmColor = isDestructive ? colors.error : colors.primary;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title),
      content: Text(message),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        _PillButton(
          label: cancelLabel,
          color: colors.textPrimary,
          borderColor: colors.border,
          onPressed: () => Navigator.pop(context, false),
        ),
        _PillButton(
          label: confirmLabel,
          color: confirmColor,
          borderColor: confirmColor,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}

/// Transparent, fully-rounded action button used by [CommonConfirmationDialog]
/// — the border (and text) carry the color, the fill stays transparent.
class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.color,
    required this.borderColor,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final Color borderColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: color,
        side: BorderSide(color: borderColor),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      ),
      child: Text(label),
    );
  }
}