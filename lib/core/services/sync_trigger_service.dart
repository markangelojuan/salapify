import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/services/connectivity_service.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/domain/entities/app_user.dart';
import 'package:salapify/features/budget/data/services/budget_sync_service.dart';
import 'package:salapify/features/settings/data/services/settings_sync_service.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/transaction/data/services/income_source_sync_service.dart';
import 'package:salapify/features/transaction/data/services/transaction_sync_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'sync_trigger_service.g.dart';

@Riverpod(keepAlive: true)
class SyncTrigger extends _$SyncTrigger {
  bool _wasOnline = true;
  String? _previousUid;

  @override
  void build() {
    _previousUid = FirebaseAuth.instance.currentUser?.uid;
    ref.listen<AsyncValue<bool>>(isOnlineProvider, (previous, next) {
      final isOnlineNow = next.value ?? false;
      if (isOnlineNow && !_wasOnline) {
        _triggerSync();
      }
      _wasOnline = isOnlineNow;
    });

    // Auth trigger — guest -> signed-in (covers signup AND login on a fresh/guest session)
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider, (
      previous,
      next,
    ) {
      final newUid = next.value?.uid;

      if (_previousUid == null && newUid != null) {
        _onSignedIn(newUid);
      }
      _previousUid = newUid;
    });
  }

  // Fires once per guest -> signed-in transition. Pushes any local guest
  // data up first, then pulls whatever's already on the account
  Future<void> _onSignedIn(String uid) async {
    try {
      final syncService = ref.read(budgetSyncServiceProvider);
      await syncService.migrateGuestDataToAccount(uid);
      await syncService.pullRemoteCategories(uid);
    } catch (e) {
      _logIfRealError(e, context: 'onSignedIn: budget migrate/pull');
    }

    try {
      final transactionSyncService = ref.read(transactionSyncServiceProvider);
      await transactionSyncService.migrateGuestDataToAccount(uid);
      await transactionSyncService.pullRemoteTransactions(uid);
    } catch (e) {
      _logIfRealError(e, context: 'onSignedIn: transaction migrate/pull');
    }

    try {
      final incomeSourceSyncService = ref.read(incomeSourceSyncServiceProvider);
      await incomeSourceSyncService.migrateGuestDataToAccount(uid);
      await incomeSourceSyncService.pullRemoteSources(uid);
    } catch (e) {
      _logIfRealError(e, context: 'onSignedIn: income source migrate/pull');
    }

    try {
      // Push local (possibly guest-set) settings first, THEN pull — same
      // ordering reasoning as budget: push what's genuinely local before
      // pulling remote, so an existing account's remote settings aren't
      // clobbered by a stale local default, and a fresh account gets the
      // guest's actual choices instead of silently losing them.
      final settingsService = ref.read(settingsSyncServiceProvider);
      await settingsService.pushLocalSettingsOnSignIn(uid);
      await settingsService.pullRemoteSettings(uid);
      ref.invalidate(budgetingPeriodSettingProvider);
      ref.invalidate(firstHalfEndDaySettingProvider);
    } catch (e) {
      _logIfRealError(e, context: 'onSignedIn: settings push/pull');
    }
  }

  Future<void> _triggerSync() async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return;

    try {
      final syncService = ref.read(budgetSyncServiceProvider);
      await syncService.pullRemoteCategories(uid);
      await syncService.pushUnsyncedCategories(uid);
    } catch (e) {
      _logIfRealError(e, context: 'triggerSync: budget pull/push');
    }

    try {
      final transactionSyncService = ref.read(transactionSyncServiceProvider);
      await transactionSyncService.pullRemoteTransactions(uid);
      await transactionSyncService.pushUnsyncedTransactions(uid);
    } catch (e) {
      _logIfRealError(e, context: 'triggerSync: transaction pull/push');
    }

    try {
      final incomeSourceSyncService = ref.read(incomeSourceSyncServiceProvider);
      await incomeSourceSyncService.pullRemoteSources(uid);
      await incomeSourceSyncService.pushUnsyncedSources(uid);
    } catch (e) {
      _logIfRealError(e, context: 'triggerSync: income source pull/push');
    }

    try {
      await ref.read(settingsSyncServiceProvider).retryPendingSettingsSync(uid);
    } catch (e) {
      _logIfRealError(e, context: 'triggerSync: retryPendingSettingsSync');
    }
  }

  void _logIfRealError(Object e, {required String context}) {
    final isOnline = ref.read(isOnlineProvider).value ?? true;
    if (!isOnline) return; // expected — offline, will retry later
    // Online but still failed
    // FirebaseCrashlytics.instance.recordError(e, StackTrace.current, reason: context);
  }
}