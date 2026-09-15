import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/authentication/domain/entities/avatar_option.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({super.key, required this.avatarId, this.radius = 16});

  final String? avatarId;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final option = avatarById(avatarId);
    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primary.withValues(alpha: 0.12),
      backgroundImage: option != null ? AssetImage(option.assetPath) : null,
      child: option == null
          ? Icon(
              Icons.person_rounded,
              size: radius,
              color: colors.primary,
            )
          : null,
    );
  }
}