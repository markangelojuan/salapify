import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/transaction/data/repositories/transaction_repository.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';
import 'package:salapify/core/services/connectivity_service.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/transaction/data/services/transaction_sync_service.dart';

part 'transaction_controller.g.dart';

@Riverpod(keepAlive: true)
Stream<List<TransactionEntry>> transactions(Ref ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchTransactions();
}

@Riverpod(keepAlive: true)
class TransactionActions extends _$TransactionActions {
  @override
  FutureOr<void> build() => null;

  bool get _isOnline => ref.read(isOnlineProvider).value ?? true;

  Future<void> _syncIfSignedIn(TransactionEntry transaction) async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return;
    if (!_isOnline) return; // offline — SyncTrigger picks it up on reconnect

    try {
      await ref
          .read(transactionSyncServiceProvider)
          .pushTransaction(uid, transaction);
    } catch (e) {
      _logIfRealError(e, context: 'syncIfSignedIn');
    }
  }

  void _logIfRealError(Object e, {required String context}) {
    if (!_isOnline) return;
    // FirebaseCrashlytics.instance.recordError(e, StackTrace.current, reason: context);
  }

  Future<void> addTransaction(TransactionEntry transaction) async {
    final result = await AsyncValue.guard(() async {
      await ref.read(transactionRepositoryProvider).addTransaction(transaction);
      await _syncIfSignedIn(transaction);
    });
    state = result;
  }

  Future<void> updateTransaction(TransactionEntry transaction) async {
    final result = await AsyncValue.guard(() async {
      final updated = transaction.copyWith(updatedAt: DateTime.now());
      await ref.read(transactionRepositoryProvider).updateTransaction(updated);
      await _syncIfSignedIn(updated);
    });
    state = result;
  }

  Future<void> deleteTransaction(String id) async {
    final result = await AsyncValue.guard(() async {
      await ref.read(transactionRepositoryProvider).deleteTransaction(id);
      final uid = ref.read(currentUserProvider)?.uid;
      if (uid == null || !_isOnline) return;
      try {
        await ref
            .read(transactionSyncServiceProvider)
            .pushUnsyncedTransactions(uid);
      } catch (e) {
        _logIfRealError(e, context: 'deleteTransaction');
      }
    });
    state = result;
  }
}