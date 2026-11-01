import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/authentication/domain/entities/avatar_option.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    super.key,
    required this.avatarId,
    this.radius = 16,
    this.onLongPress,
  });

  final String? avatarId;
  final double radius;
  final void Function(Offset position)? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final option = avatarById(avatarId);
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: colors.primary.withValues(alpha: 0.12),
      backgroundImage: option != null ? AssetImage(option.assetPath) : null,
      child: option == null
          ? Icon(Icons.person_rounded, size: radius, color: colors.primary)
          : null,
    );
    if (onLongPress == null) return avatar;
    return GestureDetector(
      onLongPressStart: (details) => onLongPress!(details.globalPosition),
      child: avatar,
    );
  }
}
