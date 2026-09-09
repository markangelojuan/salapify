// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_source_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(incomeSources)
final incomeSourcesProvider = IncomeSourcesProvider._();

final class IncomeSourcesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<IncomeSource>>,
          List<IncomeSource>,
          Stream<List<IncomeSource>>
        >
    with
        $FutureModifier<List<IncomeSource>>,
        $StreamProvider<List<IncomeSource>> {
  IncomeSourcesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomeSourcesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomeSourcesHash();

  @$internal
  @override
  $StreamProviderElement<List<IncomeSource>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<IncomeSource>> create(Ref ref) {
    return incomeSources(ref);
  }
}

String _$incomeSourcesHash() => r'b0e5dce3561e8ac9b67198bfcd50affb2936d1f0';

@ProviderFor(IncomeSourceActions)
final incomeSourceActionsProvider = IncomeSourceActionsProvider._();

final class IncomeSourceActionsProvider
    extends $AsyncNotifierProvider<IncomeSourceActions, void> {
  IncomeSourceActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomeSourceActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomeSourceActionsHash();

  @$internal
  @override
  IncomeSourceActions create() => IncomeSourceActions();
}

String _$incomeSourceActionsHash() =>
    r'e2ed04d825c55ebcb310f19304ae685026f28417';

abstract class _$IncomeSourceActions extends $AsyncNotifier<void> {
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
