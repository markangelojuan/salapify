import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/auth_repository.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController{
  @override
  FutureOr<void> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .createUserWithEmailAndPassword(email: email, password: password),
    );
  }

  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signInWithEmailAndPassword(email: email, password: password));
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signOut());
  }
}
