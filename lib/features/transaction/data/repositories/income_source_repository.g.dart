// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_source_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(incomeSourceRepository)
final incomeSourceRepositoryProvider = IncomeSourceRepositoryProvider._();

final class IncomeSourceRepositoryProvider
    extends
        $FunctionalProvider<
          IncomeSourceRepository,
          IncomeSourceRepository,
          IncomeSourceRepository
        >
    with $Provider<IncomeSourceRepository> {
  IncomeSourceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomeSourceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomeSourceRepositoryHash();

  @$internal
  @override
  $ProviderElement<IncomeSourceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IncomeSourceRepository create(Ref ref) {
    return incomeSourceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IncomeSourceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IncomeSourceRepository>(value),
    );
  }
}

String _$incomeSourceRepositoryHash() =>
    r'1b8305e064a9bf027650d477c1f3ae6e2713c2d8';
