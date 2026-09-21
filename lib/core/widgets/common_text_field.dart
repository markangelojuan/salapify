import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salapify/core/theme/app_colors.dart';

class CommonTextField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String? label;
  final bool isPassword;
  final bool isPasswordVisible;
  final Widget? suffix;
  final String? prefixText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxCharacters;
  final bool showCharacterCount;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CommonTextField({
    super.key,
    required this.icon,
    required this.hint,
    this.label,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.suffix,
    this.prefixText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxCharacters,
    this.showCharacterCount = false,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label!, style: TextStyle(color: colors.textPrimary)),
          ),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxCharacters,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colors.textSecondary, fontSize: 15),
            prefixIcon: prefixText != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        prefixText!,
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : Icon(icon, color: colors.primary, size: 22),
            suffixIcon: suffix,
            counterText:
                (maxCharacters != null && !showCharacterCount) ? '' : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
            filled: true,
            fillColor: colors.surface,
            errorStyle: TextStyle(
              color: colors.error,
              fontSize: 12,
              height: 1.4,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}