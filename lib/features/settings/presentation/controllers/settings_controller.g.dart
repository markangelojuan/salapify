// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsSyncWarning)
final settingsSyncWarningProvider = SettingsSyncWarningProvider._();

final class SettingsSyncWarningProvider
    extends $NotifierProvider<SettingsSyncWarning, String?> {
  SettingsSyncWarningProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsSyncWarningProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsSyncWarningHash();

  @$internal
  @override
  SettingsSyncWarning create() => SettingsSyncWarning();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$settingsSyncWarningHash() =>
    r'1c535575e6f13ed247605f703ed58eb8e4a05fbd';

abstract class _$SettingsSyncWarning extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

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
    r'86584160b52d3d1146f246efadd5ee2f3cb68243';

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
    r'6bbc748b793d8a1e347516413d64ffdb59da2ae4';

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
