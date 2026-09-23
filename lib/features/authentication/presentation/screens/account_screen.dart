import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/authentication/domain/entities/avatar_option.dart';
import 'package:salapify/features/authentication/presentation/controllers/app_user_controller.dart';
import 'package:salapify/features/authentication/presentation/widgets/account_bottom_sheet.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final userAsync = ref.watch(currentAppUserProvider);
    final user = userAsync.value;
    final avatar = avatarById(user?.avatarId);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: colors.primary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: colors.onPrimary),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.primary,
                      colors.primary.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => context.push('/avatar-picker'),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: colors.onPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 46,
                                backgroundColor: colors.background,
                                backgroundImage: avatar != null
                                    ? AssetImage(avatar.assetPath)
                                    : null,
                                child: avatar == null
                                    ? Icon(
                                        Icons.person_rounded,
                                        size: 40,
                                        color: colors.textSecondary,
                                      )
                                    : null,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colors.onPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                size: 14,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user?.username ?? 'User',
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (avatar != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.onPrimary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            avatar.name,
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    icon: Icons.person_outline_rounded,
                    title: 'Profile info',
                    colors: colors,
                    iconColor: colors.primary,
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    colors: colors,
                    children: [
                      _InfoRow(
                        colors: colors,
                        icon: Icons.alternate_email_rounded,
                        label: 'Username',
                        value: user?.username ?? '—',
                        trailing: TextButton(
                          onPressed: () => showEditUsernameSheet(
                            context,
                            user?.username ?? '',
                          ),
                          child: Text(
                            'Change',
                            style: TextStyle(color: colors.primary),
                          ),
                        ),
                      ),
                      Divider(height: 1, color: colors.border),
                      _InfoRow(
                        colors: colors,
                        icon: Icons.mail_outline_rounded,
                        label: 'Email',
                        value: user?.email ?? '—',
                      ),
                      Divider(height: 1, color: colors.border),
                      _InfoRow(
                        colors: colors,
                        icon: Icons.pets_rounded,
                        label: 'Avatar',
                        value: avatar?.name ?? 'Not selected',
                        trailing: TextButton(
                          onPressed: () => context.push('/avatar-picker'),
                          child: Text(
                            'Change',
                            style: TextStyle(color: colors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _SectionHeader(
                    icon: Icons.warning_amber_rounded,
                    title: 'Danger zone',
                    colors: colors,
                    iconColor: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  _DangerZoneCard(
                    colors: colors,
                    onTap: () => showDeleteAccountSheet(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon + label header used above a card, consistent with the settings
/// screen's section-label convention.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.colors,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final AppColorsExt colors;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: iconColor),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children, required this.colors});
  final List<Widget> children;
  final AppColorsExt colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppColorsExt colors;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Tappable row, styled like the settings screen's currency tile, that opens
/// the delete-account bottom sheet.
class _DangerZoneCard extends StatelessWidget {
  const _DangerZoneCard({required this.colors, required this.onTap});

  final AppColorsExt colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delete account',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Permanently remove your account and all data',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.red.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
