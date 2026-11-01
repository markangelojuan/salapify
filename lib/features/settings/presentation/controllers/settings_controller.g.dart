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
    extends $NotifierProvider<SettingsSyncWarning, SettingsWarning?> {
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
  Override overrideWithValue(SettingsWarning? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsWarning?>(value),
    );
  }
}

String _$settingsSyncWarningHash() =>
    r'd388ea78db878bbb4f5818de12dd3fa8890b847d';

abstract class _$SettingsSyncWarning extends $Notifier<SettingsWarning?> {
  SettingsWarning? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SettingsWarning?, SettingsWarning?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsWarning?, SettingsWarning?>,
              SettingsWarning?,
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
    r'457d863e96c28583360eff78ad754e25118de0a9';

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
    r'b0699a8fa80ca09bf76ce6d1a65371d7e5496ed3';

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

String _$currencySettingHash() => r'c91b389af48677ea055084963a03607d04138958';

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

@ProviderFor(ReminderNotificationsSetting)
final reminderNotificationsSettingProvider =
    ReminderNotificationsSettingProvider._();

final class ReminderNotificationsSettingProvider
    extends $AsyncNotifierProvider<ReminderNotificationsSetting, bool> {
  ReminderNotificationsSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderNotificationsSettingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderNotificationsSettingHash();

  @$internal
  @override
  ReminderNotificationsSetting create() => ReminderNotificationsSetting();
}

String _$reminderNotificationsSettingHash() =>
    r'f30a5ce76d301ebb30c751d9c95c5c5c0c8c3f02';

abstract class _$ReminderNotificationsSetting extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
