// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BudgetingPeriodSetting)
final budgetingPeriodSettingProvider = BudgetingPeriodSettingProvider._();

final class BudgetingPeriodSettingProvider
    extends $AsyncNotifierProvider<BudgetingPeriodSetting, BudgetingPeriod> {
  BudgetingPeriodSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetingPeriodSettingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetingPeriodSettingHash();

  @$internal
  @override
  BudgetingPeriodSetting create() => BudgetingPeriodSetting();
}

String _$budgetingPeriodSettingHash() =>
    r'639f19286d84355cc5c0536e97dcae8c3ef2c4b9';

abstract class _$BudgetingPeriodSetting
    extends $AsyncNotifier<BudgetingPeriod> {
  FutureOr<BudgetingPeriod> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BudgetingPeriod>, BudgetingPeriod>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BudgetingPeriod>, BudgetingPeriod>,
              AsyncValue<BudgetingPeriod>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(FirstHalfEndDaySetting)
final firstHalfEndDaySettingProvider = FirstHalfEndDaySettingProvider._();

final class FirstHalfEndDaySettingProvider
    extends $AsyncNotifierProvider<FirstHalfEndDaySetting, int> {
  FirstHalfEndDaySettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstHalfEndDaySettingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstHalfEndDaySettingHash();

  @$internal
  @override
  FirstHalfEndDaySetting create() => FirstHalfEndDaySetting();
}

String _$firstHalfEndDaySettingHash() =>
    r'12af42c7e7a3e789b246a5667be2ff1f2cf77a25';

abstract class _$FirstHalfEndDaySetting extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
