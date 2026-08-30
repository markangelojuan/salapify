// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_trigger_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Listens for connectivity changes and triggers a catch-up sync push
/// whenever the device comes back online, for signed-in users only.
/// Keep this provider alive for the whole app session (watched once from
/// the root widget) so the listener is never torn down.

@ProviderFor(SyncTrigger)
final syncTriggerProvider = SyncTriggerProvider._();

/// Listens for connectivity changes and triggers a catch-up sync push
/// whenever the device comes back online, for signed-in users only.
/// Keep this provider alive for the whole app session (watched once from
/// the root widget) so the listener is never torn down.
final class SyncTriggerProvider extends $NotifierProvider<SyncTrigger, void> {
  /// Listens for connectivity changes and triggers a catch-up sync push
  /// whenever the device comes back online, for signed-in users only.
  /// Keep this provider alive for the whole app session (watched once from
  /// the root widget) so the listener is never torn down.
  SyncTriggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncTriggerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncTriggerHash();

  @$internal
  @override
  SyncTrigger create() => SyncTrigger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$syncTriggerHash() => r'866873f391d2905c2bb21df4e3059c0a679caf01';

/// Listens for connectivity changes and triggers a catch-up sync push
/// whenever the device comes back online, for signed-in users only.
/// Keep this provider alive for the whole app session (watched once from
/// the root widget) so the listener is never torn down.

abstract class _$SyncTrigger extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
