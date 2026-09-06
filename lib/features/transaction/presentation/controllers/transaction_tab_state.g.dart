// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_tab_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks which sub-tab is active inside TransactionScreen, so HomeScreen's
/// shared FAB (which lives outside the tab's own widget tree) knows whether
/// tapping it should add an expense or an income entry.

@ProviderFor(TransactionTabState)
final transactionTabStateProvider = TransactionTabStateProvider._();

/// Tracks which sub-tab is active inside TransactionScreen, so HomeScreen's
/// shared FAB (which lives outside the tab's own widget tree) knows whether
/// tapping it should add an expense or an income entry.
final class TransactionTabStateProvider
    extends $NotifierProvider<TransactionTabState, TransactionTab> {
  /// Tracks which sub-tab is active inside TransactionScreen, so HomeScreen's
  /// shared FAB (which lives outside the tab's own widget tree) knows whether
  /// tapping it should add an expense or an income entry.
  TransactionTabStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionTabStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionTabStateHash();

  @$internal
  @override
  TransactionTabState create() => TransactionTabState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionTab>(value),
    );
  }
}

String _$transactionTabStateHash() =>
    r'92a89f40a0d8512db243261067962ca3bd5d38f7';

/// Tracks which sub-tab is active inside TransactionScreen, so HomeScreen's
/// shared FAB (which lives outside the tab's own widget tree) knows whether
/// tapping it should add an expense or an income entry.

abstract class _$TransactionTabState extends $Notifier<TransactionTab> {
  TransactionTab build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TransactionTab, TransactionTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TransactionTab, TransactionTab>,
              TransactionTab,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
