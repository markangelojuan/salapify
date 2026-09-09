// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactions)
final transactionsProvider = TransactionsProvider._();

final class TransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionEntry>>,
          List<TransactionEntry>,
          Stream<List<TransactionEntry>>
        >
    with
        $FutureModifier<List<TransactionEntry>>,
        $StreamProvider<List<TransactionEntry>> {
  TransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsHash();

  @$internal
  @override
  $StreamProviderElement<List<TransactionEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransactionEntry>> create(Ref ref) {
    return transactions(ref);
  }
}

String _$transactionsHash() => r'33b4c794cd35f450d7cc31e8a2b662ec00695cb7';

@ProviderFor(TransactionActions)
final transactionActionsProvider = TransactionActionsProvider._();

final class TransactionActionsProvider
    extends $AsyncNotifierProvider<TransactionActions, void> {
  TransactionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionActionsHash();

  @$internal
  @override
  TransactionActions create() => TransactionActions();
}

String _$transactionActionsHash() =>
    r'256a8b8b02473f02af736ebee02e6942151633dc';

abstract class _$TransactionActions extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
