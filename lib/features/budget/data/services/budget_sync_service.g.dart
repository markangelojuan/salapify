// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(budgetSyncService)
final budgetSyncServiceProvider = BudgetSyncServiceProvider._();

final class BudgetSyncServiceProvider
    extends
        $FunctionalProvider<
          BudgetSyncService,
          BudgetSyncService,
          BudgetSyncService
        >
    with $Provider<BudgetSyncService> {
  BudgetSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetSyncServiceHash();

  @$internal
  @override
  $ProviderElement<BudgetSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BudgetSyncService create(Ref ref) {
    return budgetSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetSyncService>(value),
    );
  }
}

String _$budgetSyncServiceHash() => r'9ea25f590134c73c7f5b2edf4dd2dbb05b4bfeb5';
