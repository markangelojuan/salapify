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

String _$periodResetGuardHash() => r'49adebc51632d7d890cd6fd9bde47bc8e0ebc761';

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

String _$budgetActionsHash() => r'4c5187cd9e80ec8a8794fa8fa5e01bba6cdd98ec';

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

/// Keeps `isCompleted` in sync with actual spend

@ProviderFor(BudgetCompletionGuard)
final budgetCompletionGuardProvider = BudgetCompletionGuardProvider._();

/// Keeps `isCompleted` in sync with actual spend
final class BudgetCompletionGuardProvider
    extends $AsyncNotifierProvider<BudgetCompletionGuard, void> {
  /// Keeps `isCompleted` in sync with actual spend
  BudgetCompletionGuardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetCompletionGuardProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetCompletionGuardHash();

  @$internal
  @override
  BudgetCompletionGuard create() => BudgetCompletionGuard();
}

String _$budgetCompletionGuardHash() =>
    r'4e8ced0f3e02c211710049fa899f95021c507a7a';

/// Keeps `isCompleted` in sync with actual spend

abstract class _$BudgetCompletionGuard extends $AsyncNotifier<void> {
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

@ProviderFor(BudgetCompletionEventNotifier)
final budgetCompletionEventProvider = BudgetCompletionEventNotifierProvider._();

final class BudgetCompletionEventNotifierProvider
    extends
        $NotifierProvider<
          BudgetCompletionEventNotifier,
          BudgetCompletionEvent?
        > {
  BudgetCompletionEventNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetCompletionEventProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetCompletionEventNotifierHash();

  @$internal
  @override
  BudgetCompletionEventNotifier create() => BudgetCompletionEventNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetCompletionEvent? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetCompletionEvent?>(value),
    );
  }
}

String _$budgetCompletionEventNotifierHash() =>
    r'9c69be53474d9a84698c264835e0848a1edf01d1';

abstract class _$BudgetCompletionEventNotifier
    extends $Notifier<BudgetCompletionEvent?> {
  BudgetCompletionEvent? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<BudgetCompletionEvent?, BudgetCompletionEvent?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BudgetCompletionEvent?, BudgetCompletionEvent?>,
              BudgetCompletionEvent?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
