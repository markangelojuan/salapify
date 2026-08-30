import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/budget/data/services/budget_sync_service.dart';
import 'package:salapify/features/budget/data/repositories/budget_repository.dart';

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
      await ref
          .read(userRepositoryProvider)
          .createUserProfile(uid: uid, username: username, email: email);

      // Guest data (if any) must migrate BEFORE any pull, or an empty
      // remote collection would overwrite local data on first pull.
      await ref.read(budgetSyncServiceProvider).migrateGuestDataToAccount(uid);
    });
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = authRepository.currentUser!.uid;
      // Existing account signing in on this device: pull their remote data
      // down, then push anything that only exists locally.
      await ref.read(budgetSyncServiceProvider).pullRemoteCategories(uid);
      await ref.read(budgetSyncServiceProvider).pushUnsyncedCategories(uid);
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
      await ref.read(budgetRepositoryProvider).clearAllCategories();
    });
  }
}
