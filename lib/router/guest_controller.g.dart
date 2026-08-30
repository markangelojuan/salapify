// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GuestMode)
final guestModeProvider = GuestModeProvider._();

final class GuestModeProvider extends $NotifierProvider<GuestMode, bool> {
  GuestModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'guestModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$guestModeHash();

  @$internal
  @override
  GuestMode create() => GuestMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$guestModeHash() => r'40445e21e427433fb9920e95a7acacb9137d548f';

abstract class _$GuestMode extends $Notifier<bool> {
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
