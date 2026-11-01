// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initial_sync_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// True while SyncTrigger is doing the guest -> signed-in pull, so guards
/// that compare categories against transactions don't act on half-loaded data.

@ProviderFor(InitialSyncStatus)
final initialSyncStatusProvider = InitialSyncStatusProvider._();

/// True while SyncTrigger is doing the guest -> signed-in pull, so guards
/// that compare categories against transactions don't act on half-loaded data.
final class InitialSyncStatusProvider
    extends $NotifierProvider<InitialSyncStatus, bool> {
  /// True while SyncTrigger is doing the guest -> signed-in pull, so guards
  /// that compare categories against transactions don't act on half-loaded data.
  InitialSyncStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialSyncStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialSyncStatusHash();

  @$internal
  @override
  InitialSyncStatus create() => InitialSyncStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$initialSyncStatusHash() => r'b123a6dbf82758541bc82fad360156f0b05dbc7f';

/// True while SyncTrigger is doing the guest -> signed-in pull, so guards
/// that compare categories against transactions don't act on half-loaded data.

abstract class _$InitialSyncStatus extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
