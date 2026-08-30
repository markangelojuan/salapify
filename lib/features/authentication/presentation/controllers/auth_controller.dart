import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/auth_repository.dart';
import 'package:salapify/features/authentication/data/user_repository.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    return null;
  }

Future<void> createUserWithEmailAndPassword({
  required String email,
  required String password,
  required String username,
}) async {
  state = const AsyncLoading();
  state = await AsyncValue.guard(() async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = authRepository.currentUser!.uid;
    await ref.read(userRepositoryProvider).createUserProfile(
      uid: uid,
      username: username,
      email: email,
    );
  });
}

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signOut(),
    );
  }
}
