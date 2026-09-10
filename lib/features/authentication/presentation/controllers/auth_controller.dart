import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/database/app_database.dart';
import 'package:salapify/core/services/push_notification_service.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/budget/data/repositories/budget_repository.dart';
import 'package:salapify/features/transaction/data/repositories/transaction_repository.dart';
import 'package:salapify/features/transaction/data/repositories/income_source_repository.dart';
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
      });
    });
  }
}