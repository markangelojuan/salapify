import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/core/services/push_notification_service.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/authentication/domain/exceptions/auth_exceptions.dart';
import 'package:salapify/features/budget/data/repositories/budget_repository.dart';
import 'package:salapify/features/premium/data/repositories/entitlement_repository.dart';
import 'package:salapify/features/settings/data/repositories/settings_repository.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/transaction/data/repositories/transaction_repository.dart';
import 'package:salapify/features/transaction/data/repositories/income_source_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      final trimmedUsername = username.trim();
      final userRepository = ref.read(userRepositoryProvider);

      final existingUid = await userRepository.findUidByUsername(
        trimmedUsername,
      );
      if (existingUid != null) {
        throw const UsernameTakenException();
      }

      final authRepository = ref.read(authRepositoryProvider);
      // Email uniqueness is enforced by Firebase Auth itself
      await authRepository.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = authRepository.currentUser!.uid;
      await userRepository.createUserProfile(
        uid: uid,
        username: trimmedUsername,
        email: email,
      );
      await authRepository.sendEmailVerification();
      await ref.read(pushNotificationServiceProvider).initForUser(uid);
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

      await ref.read(pushNotificationServiceProvider).initForUser(uid);
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      final pushNotificationService = ref.read(pushNotificationServiceProvider);

      final uid = authRepository.currentUser?.uid;

      if (uid != null) {
        await pushNotificationService.clearForUser(uid);
      }

      await authRepository.signOut();

      await ref.read(appDatabaseProvider).transaction(() async {
        await ref.read(transactionRepositoryProvider).clearAllTransactions();
        await ref.read(incomeSourceRepositoryProvider).clearAllSources();
        await ref.read(budgetRepositoryProvider).clearAllCategories();
        await ref.read(entitlementRepositoryProvider).clearLocal();
      });

      await ref.read(settingsRepositoryProvider).clearAll();

      ref.invalidate(budgetingPeriodSettingProvider);
      ref.invalidate(firstHalfEndDaySettingProvider);
      ref.invalidate(currencySettingProvider);
      ref.invalidate(reminderNotificationsSettingProvider);
      ref.invalidate(isPremiumProvider);
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);

      late final UserCredential userCredential;
      try {
        userCredential = await authRepository.signInWithGoogle();
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) return;
        rethrow;
      }

      final uid = userCredential.user!.uid;
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        final userRepository = ref.read(userRepositoryProvider);
        final email = userCredential.user?.email ?? '';
        final base = userCredential.user?.displayName ?? email.split('@').first;
        final username = await userRepository.generateUniqueUsername(
          base: base,
        );

        await userRepository.createUserProfile(
          uid: uid,
          username: username,
          email: email,
        );
      }

      await ref.read(pushNotificationServiceProvider).initForUser(uid);
    });
  }

  Future<void> resendVerificationEmail() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendEmailVerification();
    });
  }

  Future<bool> checkEmailVerified() async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.reloadCurrentUser();
    return authRepository.isEmailVerified;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
  }
}
