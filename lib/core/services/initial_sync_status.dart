import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'initial_sync_status.g.dart';

/// True while SyncTrigger is doing the guest -> signed-in pull, so guards
/// that compare categories against transactions don't act on half-loaded data.
@Riverpod(keepAlive: true)
class InitialSyncStatus extends _$InitialSyncStatus {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}