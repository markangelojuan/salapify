import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/services/connectivity_service.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/transaction/data/repositories/income_source_repository.dart';
import 'package:salapify/features/transaction/data/services/income_source_sync_service.dart';
import 'package:salapify/features/transaction/domain/entities/income_source.dart';

part 'income_source_controller.g.dart';

@Riverpod(keepAlive: true)
Stream<List<IncomeSource>> incomeSources(Ref ref) {
  final repository = ref.watch(incomeSourceRepositoryProvider);
  return repository.watchSources();
}

@Riverpod(keepAlive: true)
class IncomeSourceActions extends _$IncomeSourceActions {
  @override
  FutureOr<void> build() => null;

  bool get _isOnline => ref.read(isOnlineProvider).value ?? true;

  Future<void> _syncIfSignedIn(IncomeSource source) async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return; // guest — local only, nothing to sync
    if (!_isOnline) return; // offline — SyncTrigger picks it up on reconnect

    try {
      await ref.read(incomeSourceSyncServiceProvider).pushSource(uid, source);
    } catch (e) {
      _logIfRealError(e, context: 'syncIfSignedIn');
    }
  }

  void _logIfRealError(Object e, {required String context}) {
    if (!_isOnline) {
      return; // expected — offline, will retry via pushUnsyncedSources
    }
    // FirebaseCrashlytics.instance.recordError(e, StackTrace.current, reason: context);
  }

  Future<void> addSource(IncomeSource source) async {
    final result = await AsyncValue.guard(() async {
      await ref.read(incomeSourceRepositoryProvider).addSource(source);
      await _syncIfSignedIn(source);
    });
    state = result;
  }

  Future<void> updateSource(IncomeSource source) async {
    final result = await AsyncValue.guard(() async {
      final updated = source.copyWith(updatedAt: DateTime.now());
      await ref.read(incomeSourceRepositoryProvider).updateSource(updated);
      await _syncIfSignedIn(updated);
    });
    state = result;
  }

  Future<void> deleteSource(String id) async {
    final result = await AsyncValue.guard(() async {
      await ref.read(incomeSourceRepositoryProvider).deleteSource(id);
      final uid = ref.read(currentUserProvider)?.uid;
      if (uid == null || !_isOnline) return;
      try {
        await ref.read(incomeSourceSyncServiceProvider).pushUnsyncedSources(uid);
      } catch (e) {
        _logIfRealError(e, context: 'deleteSource');
      }
    });
    state = result;
  }
}