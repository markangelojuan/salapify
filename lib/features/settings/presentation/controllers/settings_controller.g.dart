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
    r'b4e93c683ad1176821a0475ab6cff640948ffd21';

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
    r'35ca16cb063c32144915b189953035541603bf4a';

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

@ProviderFor(CurrencySetting)
final currencySettingProvider = CurrencySettingProvider._();

final class CurrencySettingProvider
    extends $AsyncNotifierProvider<CurrencySetting, AppCurrency> {
  CurrencySettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencySettingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencySettingHash();

  @$internal
  @override
  CurrencySetting create() => CurrencySetting();
}

String _$currencySettingHash() => r'8533d95fb58d773afa6ca5a03c1e6e528a8725b3';

abstract class _$CurrencySetting extends $AsyncNotifier<AppCurrency> {
  FutureOr<AppCurrency> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppCurrency>, AppCurrency>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppCurrency>, AppCurrency>,
              AsyncValue<AppCurrency>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
