import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/authentication/domain/entities/avatar_option.dart';

/// Circular member avatar. Resolves [avatarId] to a local asset via
/// [avatarById]; falls back to a plain person icon when the member has no
/// avatarId set (or hasn't loaded yet).
class MemberAvatar extends StatelessWidget {
  const MemberAvatar({super.key, required this.avatarId, this.radius = 16});

  final String? avatarId;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final option = avatarById(avatarId);
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      backgroundImage: option != null ? AssetImage(option.assetPath) : null,
      child: option == null
          ? Icon(
              Icons.person_rounded,
              size: radius,
              color: AppColors.primary,
            )
          : null,
    );
  }
}