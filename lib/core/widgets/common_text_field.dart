import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

class CommonTextField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String? label;
  final bool isPassword;
  final bool isPasswordVisible;
  final Widget? suffix;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CommonTextField({
    super.key,
    required this.icon,
    required this.hint,
    this.label,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.suffix,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 4),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary.withOpacity(0.8),
                letterSpacing: 1.2,
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.4),
              fontSize: 15,
            ),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            filled: true,
            fillColor: Colors.white,
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              height: 1.4,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}