import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/theme/theme_controller.dart';
import 'package:salapify/features/authentication/presentation/controllers/app_user_controller.dart';
import 'package:salapify/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:salapify/features/authentication/presentation/controllers/guest_controller.dart';
import 'package:salapify/features/authentication/domain/entities/avatar_option.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentAppUserProvider);
    final user = userAsync.value;
    final isGuest = ref.watch(guestModeProvider);
    final themeMode = ref.watch(themeControllerProvider);

    return Drawer(
      child: Column(
        children: [
          _DrawerHeader(
            username: user?.username ?? 'User',
            email: user?.email ?? '',
            avatarId: user?.avatarId,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  _DrawerItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Account',
                    onTap: () {
                      Navigator.pop(context);
                      if (isGuest) {
                        ref.read(guestModeProvider.notifier).disable();
                        context.go('/sign-in');
                      } else {
                        context.push('/account');
                      }
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (_) {
                        ref.read(themeControllerProvider.notifier).toggle();
                      },
                    ),
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/settings');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help / FAQ',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/help');
                    },
                  ),
                  const Spacer(),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  const SizedBox(height: 8),
                  _DrawerItem(
                    icon: isGuest ? Icons.login_rounded : Icons.logout_rounded,
                    title: isGuest ? 'Sign In' : 'Logout',
                    destructive: !isGuest,
                    onTap: () {
                      Navigator.pop(context);
                      if (isGuest) {
                        ref.read(guestModeProvider.notifier).disable();
                        context.go('/sign-in');
                      } else {
                        ref.read(authControllerProvider.notifier).signOut();
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.username,
    required this.email,
    this.avatarId,
  });

  final String username;
  final String email;
  final String? avatarId;

  @override
  Widget build(BuildContext context) {
    final avatar = avatarById(avatarId);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.backgroundGradientStart,
            AppColors.backgroundGradientEnd,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              backgroundImage: avatar != null
                  ? AssetImage(avatar.assetPath)
                  : null,
              child: avatar == null
                  ? Icon(
                      Icons.person_rounded,
                      color: AppColors.textPrimary,
                      size: 28,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? Theme.of(context).colorScheme.error : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
        trailing: trailing,
      ),
    );
  }
}
