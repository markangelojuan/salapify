import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/authentication/presentation/controllers/app_user_controller.dart';

part 'avatar_controller.g.dart';

@riverpod
class AvatarController extends _$AvatarController {
  @override
  FutureOr<void> build() => null;

  Future<void> selectAvatar(String avatarId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authRepositoryProvider).currentUser!.uid;
      await ref.read(userRepositoryProvider).setAvatarId(uid, avatarId);
      ref.invalidate(currentAppUserProvider);
    });
  }
}