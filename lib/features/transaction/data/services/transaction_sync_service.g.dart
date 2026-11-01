// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactionSyncService)
final transactionSyncServiceProvider = TransactionSyncServiceProvider._();

final class TransactionSyncServiceProvider
    extends
        $FunctionalProvider<
          TransactionSyncService,
          TransactionSyncService,
          TransactionSyncService
        >
    with $Provider<TransactionSyncService> {
  TransactionSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionSyncServiceHash();

  @$internal
  @override
  $ProviderElement<TransactionSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionSyncService create(Ref ref) {
    return transactionSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionSyncService>(value),
    );
  }
}

String _$transactionSyncServiceHash() =>
    r'763e9e56781e9d264c8d47cb3ac79b5d762f516a';
