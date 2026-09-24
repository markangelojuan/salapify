import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/authentication/domain/entities/app_user.dart';

part 'app_user_controller.g.dart';

@riverpod
Stream<AppUser?> currentAppUser(Ref ref) {
  final sessionUser = ref.watch(currentUserProvider);
  if (sessionUser == null) return Stream.value(null);

  return ref
      .watch(userRepositoryProvider)
      .watchUserProfile(sessionUser.uid)
      .map((profile) {
    return AppUser(
      uid: sessionUser.uid,
      email: sessionUser.email,
      username: profile?['username'] as String?,
      avatarId: profile?['avatarId'] as String?,
      preferencesCompleted: profile?['preferencesCompleted'] as bool? ?? true,
      emailVerified: profile?['emailVerified'] as bool? ?? false,
      isDisabled: profile?['isDisabled'] as bool? ?? false,
    );
  });
}