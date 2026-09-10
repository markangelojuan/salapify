import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/authentication/domain/entities/app_user.dart';

part 'app_user_controller.g.dart';

@riverpod
Future<AppUser?> currentAppUser(Ref ref) async {
  final sessionUser = ref.watch(currentUserProvider);
  if (sessionUser == null) return null;

  final profile = await ref.watch(userRepositoryProvider).getUserProfile(sessionUser.uid);

  return AppUser(
    uid: sessionUser.uid,
    email: sessionUser.email,
    username: profile?['username'] as String?,
    avatarId: profile?['avatarId'] as String?,
  );
}