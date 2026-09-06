// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_trigger_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncTrigger)
final syncTriggerProvider = SyncTriggerProvider._();

final class SyncTriggerProvider extends $NotifierProvider<SyncTrigger, void> {
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

String _$syncTriggerHash() => r'ca7730df02b196f076588cc9115b94db64694fa8';

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
