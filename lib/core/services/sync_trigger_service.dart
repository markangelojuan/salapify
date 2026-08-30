import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/core/services/connectivity_service.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/budget/data/services/budget_sync_service.dart';

part 'sync_trigger_service.g.dart';

/// Listens for connectivity changes and triggers a catch-up sync push
/// whenever the device comes back online, for signed-in users only.
/// Keep this provider alive for the whole app session (watched once from
/// the root widget) so the listener is never torn down.
@Riverpod(keepAlive: true)
class SyncTrigger extends _$SyncTrigger {
  bool _wasOnline = true;

  @override
  void build() {
    ref.listen<AsyncValue<bool>>(isOnlineProvider, (previous, next) {
      final isOnlineNow = next.value ?? false;

      if (isOnlineNow && !_wasOnline) {
        _triggerSync();
      }
      _wasOnline = isOnlineNow;
    });
  }

  Future<void> _triggerSync() async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return; // guest — nothing to sync

    try {
      await ref.read(budgetSyncServiceProvider).pushUnsyncedCategories(uid);
    } catch (_) {
      // Still offline or push failed — will retry on next reconnect.
    }
  }
}