// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(entitlementSyncService)
final entitlementSyncServiceProvider = EntitlementSyncServiceProvider._();

final class EntitlementSyncServiceProvider
    extends
        $FunctionalProvider<
          EntitlementSyncService,
          EntitlementSyncService,
          EntitlementSyncService
        >
    with $Provider<EntitlementSyncService> {
  EntitlementSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entitlementSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entitlementSyncServiceHash();

  @$internal
  @override
  $ProviderElement<EntitlementSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EntitlementSyncService create(Ref ref) {
    return entitlementSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EntitlementSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EntitlementSyncService>(value),
    );
  }
}

String _$entitlementSyncServiceHash() =>
    r'a810a743829f4fa055c86be32738f4d8dbc95a3c';
