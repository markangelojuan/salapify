import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/split_bill/presentation/widgets/member_avatar.dart';

class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  Future<void> _unblock(
    BuildContext context,
    WidgetRef ref,
    BlockedUserInfo user,
  ) async {
    final currentUid = ref.read(currentUserProvider)?.uid;
    if (currentUid == null) return;
    try {
      await ref.read(userRepositoryProvider).unblockUser(
            blockerId: currentUid,
            blockedId: user.uid,
          );
      if (context.mounted) {
        CommonSnackbar.showSuccess(context, 'Unblocked ${user.username}');
      }
    } catch (e) {
      if (context.mounted) CommonSnackbar.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final blockedAsync = ref.watch(blockedUsersInfoProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: const Text('Blocked Users')),
      body: blockedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load: $err')),
        data: (blocked) {
          if (blocked.isEmpty) {
            return Center(
              child: Text(
                'No blocked users',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: blocked.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final user = blocked[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    MemberAvatar(avatarId: user.avatarId, radius: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        user.username,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _unblock(context, ref, user),
                      child: const Text('Unblock'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}