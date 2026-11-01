import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/l10n/app_localizations.dart';

class CommonConfirmationDialog extends StatelessWidget {
  const CommonConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel,
    this.cancelLabel,
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String? confirmLabel;
  final String? cancelLabel;

  /// When true, tints the confirm action with the app's error color —
  /// use for deletes and other irreversible actions.
  final bool isDestructive;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
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
    final l10n = AppLocalizations.of(context);
    return show(
      context,
      title: title ?? l10n.commonDelete,
      message: l10n.confirmDeleteMessage(itemName),
      confirmLabel: l10n.commonDelete,
      isDestructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final confirmColor = isDestructive ? colors.error : colors.primary;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title),
      content: Text(message),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        _PillButton(
          label: cancelLabel ?? l10n.commonCancel,
          color: colors.textPrimary,
          borderColor: colors.border,
          onPressed: () => Navigator.pop(context, false),
        ),
        _PillButton(
          label: confirmLabel ?? l10n.commonConfirm,
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
