import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 70),
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}