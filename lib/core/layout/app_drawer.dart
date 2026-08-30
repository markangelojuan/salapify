import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/theme/theme_controller.dart';
import 'package:salapify/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:salapify/features/authentication/presentation/controllers/guest_controller.dart';
import 'package:salapify/features/authentication/presentation/controllers/app_user_controller.dart';


class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentAppUserProvider);
    final user = userAsync.value;
    final isGuest = ref.watch(guestModeProvider);
    final themeMode = ref.watch(themeControllerProvider);
    

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.username ?? "User"),
              accountEmail: Text(user?.email ?? ""),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Account"),
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
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text("Dark Mode"),
              value: themeMode == ThemeMode.dark,
              onChanged: (_) =>
                  ref.read(themeControllerProvider.notifier).toggle(),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Help / FAQ"),
              onTap: () {
                Navigator.pop(context);
                context.push('/help');
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: Icon(
                isGuest ? Icons.login : Icons.logout,
                color: isGuest ? null : Colors.red,
              ),
              title: Text(
                isGuest ? "Sign In" : "Logout",
                style: isGuest ? null : const TextStyle(color: Colors.red),
              ),
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
    );
  }
}
