import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/core/services/push_notification_service.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/authentication/domain/exceptions/auth_exceptions.dart';
import 'package:salapify/features/budget/data/repositories/budget_repository.dart';
import 'package:salapify/features/budget/data/services/budget_sync_service.dart';
import 'package:salapify/features/premium/data/repositories/entitlement_repository.dart';
import 'package:salapify/features/settings/data/repositories/settings_repository.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/transaction/data/repositories/transaction_repository.dart';
import 'package:salapify/features/transaction/data/repositories/income_source_repository.dart';
import 'package:salapify/features/authentication/presentation/controllers/app_user_controller.dart';
import 'package:salapify/features/notification/data/providers/notification_providers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salapify/features/transaction/data/services/income_source_sync_service.dart';
import 'package:salapify/features/transaction/data/services/transaction_sync_service.dart';

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
        emailVerified: false,
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
          emailVerified: userCredential.user?.emailVerified ?? true,
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
    final verified = authRepository.isEmailVerified;

    if (verified) {
      final uid = authRepository.currentUser?.uid;
      if (uid != null) {
        await ref.read(userRepositoryProvider).markEmailVerified(uid);
        ref.invalidate(currentAppUserProvider);
      }
    }

    return verified;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
  }

  Future<void> deleteAccountWithPassword(String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      try {
        await authRepository.reauthenticateWithPassword(password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
          throw const WrongPasswordException();
        }
        rethrow;
      }
      await _deleteAccountData();
    });
  }

  Future<void> deleteAccountWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      try {
        await authRepository.reauthenticateWithGoogle();
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) {
          throw const ReauthCancelledException();
        }
        rethrow;
      }
      await _deleteAccountData();
    });
  }

  Future<void> _deleteAccountData() async {
    final authRepository = ref.read(authRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);
    final pushNotificationService = ref.read(pushNotificationServiceProvider);

    final uid = authRepository.currentUser?.uid;
    if (uid == null) return;

    await ref.read(splitBillRepositoryProvider).leaveAllGroups(uid);
    await pushNotificationService.clearForUser(uid);
    await ref.read(notificationRepositoryProvider).deleteAllForUser(uid);
    await ref.read(budgetSyncServiceProvider).deleteAllRemoteCategories(uid);
    await ref
        .read(transactionSyncServiceProvider)
        .deleteAllRemoteTransactions(uid);
    await ref.read(incomeSourceSyncServiceProvider).deleteAllRemoteSources(uid);
    await userRepository.deleteUserProfile(uid); // parent doc last

    await ref.read(appDatabaseProvider).transaction(() async {
      await ref.read(transactionRepositoryProvider).clearAllTransactions();
      await ref.read(incomeSourceRepositoryProvider).clearAllSources();
      await ref.read(budgetRepositoryProvider).clearAllCategories();
      await ref.read(entitlementRepositoryProvider).clearLocal();
    });
    await ref.read(settingsRepositoryProvider).clearAll();

    await authRepository.deleteCurrentUser();

    ref.invalidate(budgetingPeriodSettingProvider);
    ref.invalidate(firstHalfEndDaySettingProvider);
    ref.invalidate(currencySettingProvider);
    ref.invalidate(reminderNotificationsSettingProvider);
    ref.invalidate(isPremiumProvider);
  }

  Future<void> updateUsername(String username) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      final userRepository = ref.read(userRepositoryProvider);

      final uid = authRepository.currentUser?.uid;
      if (uid == null) return;

      await userRepository.updateUsername(
        uid: uid,
        newUsername: username.trim(),
      );
      ref.invalidate(currentAppUserProvider);
    });
  }
}
