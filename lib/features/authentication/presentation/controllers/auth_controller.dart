import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
// import 'package:salapify/features/budget/data/services/budget_sync_service.dart';
import 'package:salapify/features/budget/data/repositories/budget_repository.dart';
// import 'package:salapify/features/settings/data/settings_repository.dart';
// import 'package:salapify/features/settings/data/services/settings_sync_service.dart';
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

      // await ref.read(budgetSyncServiceProvider).migrateGuestDataToAccount(uid);

      // final settingsRepository = ref.read(settingsRepositoryProvider);
      // final settingsSyncService = ref.read(settingsSyncServiceProvider);
      // try {
      //   await settingsSyncService.pushBudgetingPeriod(
      //     uid,
      //     await settingsRepository.getLocalBudgetingPeriod(),
      //   );
      //   await settingsSyncService.pushFirstHalfEndDay(
      //     uid,
      //     await settingsRepository.getLocalFirstHalfEndDay(),
      //   );
      // } catch (_) {
      //   // Offline during signup — retryPendingSettingsSync will pick it up.
      // }
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

      // final uid = authRepository.currentUser!.uid;
      // await ref.read(budgetSyncServiceProvider).pullRemoteCategories(uid);
      // await ref.read(budgetSyncServiceProvider).pushUnsyncedCategories(uid);

      // await ref.read(settingsSyncServiceProvider).pullRemoteSettings(uid);
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