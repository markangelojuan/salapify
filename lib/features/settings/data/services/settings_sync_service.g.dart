// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsSyncService)
final settingsSyncServiceProvider = SettingsSyncServiceProvider._();

final class SettingsSyncServiceProvider
    extends
        $FunctionalProvider<
          SettingsSyncService,
          SettingsSyncService,
          SettingsSyncService
        >
    with $Provider<SettingsSyncService> {
  SettingsSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsSyncServiceHash();

  @$internal
  @override
  $ProviderElement<SettingsSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsSyncService create(Ref ref) {
    return settingsSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsSyncService>(value),
    );
  }
}

String _$settingsSyncServiceHash() =>
    r'c6c009f36b68e48b01fef5f958ac597387301199';
