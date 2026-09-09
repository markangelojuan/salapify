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

@ProviderFor(hasUnsyncedCategories)
final hasUnsyncedCategoriesProvider = HasUnsyncedCategoriesProvider._();

final class HasUnsyncedCategoriesProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  HasUnsyncedCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasUnsyncedCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasUnsyncedCategoriesHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return hasUnsyncedCategories(ref);
  }
}

String _$hasUnsyncedCategoriesHash() =>
    r'060e5053facd17195377ff41abe8d9ef80b33295';

@ProviderFor(PeriodResetGuard)
final periodResetGuardProvider = PeriodResetGuardProvider._();

final class PeriodResetGuardProvider
    extends $AsyncNotifierProvider<PeriodResetGuard, void> {
  PeriodResetGuardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'periodResetGuardProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$periodResetGuardHash();

  @$internal
  @override
  PeriodResetGuard create() => PeriodResetGuard();
}

String _$periodResetGuardHash() => r'8ad1bb1ef971c6d7e7bfb48eeb85576f31a84a82';

abstract class _$PeriodResetGuard extends $AsyncNotifier<void> {
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
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetActionsHash();

  @$internal
  @override
  BudgetActions create() => BudgetActions();
}

String _$budgetActionsHash() => r'8f901ce6d207e15183a0706938cf389dd834852a';

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
