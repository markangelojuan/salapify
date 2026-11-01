import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/extensions/network_timeout.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/authentication/domain/entities/avatar_option.dart';
import 'package:salapify/features/authentication/presentation/controllers/app_user_controller.dart';
import 'package:salapify/features/premium/data/repositories/entitlement_repository.dart';

part 'avatar_controller.g.dart';

class AvatarNotAvailableException implements Exception {
  const AvatarNotAvailableException();
  @override
  String toString() => 'This avatar is not available.';
}

@riverpod
class AvatarController extends _$AvatarController {
  @override
  FutureOr<void> build() => null;

  Future<void> selectAvatar(String avatarId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final option = avatarById(avatarId);

      // Unknown or developer-only avatars can never be chosen in-app.
      if (option == null || option.isHidden) {
        throw const AvatarNotAvailableException();
      }

      // Premium-only avatars require an active premium entitlement.
      if (option.isPremiumOnly) {
        final isPremium = await ref.read(isPremiumProvider.future);
        if (!isPremium) throw const AvatarNotAvailableException();
      }

      final uid = ref.read(authRepositoryProvider).currentUser!.uid;
      await ref
          .read(userRepositoryProvider)
          .setAvatarId(uid, avatarId)
          .withNetworkTimeout();
      ref.invalidate(currentAppUserProvider);
    });
  }
}