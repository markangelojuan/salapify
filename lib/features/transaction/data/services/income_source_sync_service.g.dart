// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_source_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(incomeSourceSyncService)
final incomeSourceSyncServiceProvider = IncomeSourceSyncServiceProvider._();

final class IncomeSourceSyncServiceProvider
    extends
        $FunctionalProvider<
          IncomeSourceSyncService,
          IncomeSourceSyncService,
          IncomeSourceSyncService
        >
    with $Provider<IncomeSourceSyncService> {
  IncomeSourceSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomeSourceSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomeSourceSyncServiceHash();

  @$internal
  @override
  $ProviderElement<IncomeSourceSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IncomeSourceSyncService create(Ref ref) {
    return incomeSourceSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IncomeSourceSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IncomeSourceSyncService>(value),
    );
  }
}

String _$incomeSourceSyncServiceHash() =>
    r'4f352abbd8a605861a6f67694db62c4de96738af';
