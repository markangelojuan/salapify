// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(budgetCategories)
final budgetCategoriesProvider = BudgetCategoriesProvider._();

final class BudgetCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BudgetCategory>>,
          List<BudgetCategory>,
          Stream<List<BudgetCategory>>
        >
    with
        $FutureModifier<List<BudgetCategory>>,
        $StreamProvider<List<BudgetCategory>> {
  BudgetCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetCategoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetCategoriesHash();

  @$internal
  @override
  $StreamProviderElement<List<BudgetCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BudgetCategory>> create(Ref ref) {
    return budgetCategories(ref);
  }
}

String _$budgetCategoriesHash() => r'148a98a48faae9cea9830e2ba82978fbd10c26e5';

@ProviderFor(BudgetActions)
final budgetActionsProvider = BudgetActionsProvider._();

final class BudgetActionsProvider
    extends $AsyncNotifierProvider<BudgetActions, void> {
  BudgetActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetActionsHash();

  @$internal
  @override
  BudgetActions create() => BudgetActions();
}

String _$budgetActionsHash() => r'56600066aaec163c7983891adfe7b2f180d00b03';

abstract class _$BudgetActions extends $AsyncNotifier<void> {
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
