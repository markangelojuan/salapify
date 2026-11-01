// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(entitlementRepository)
final entitlementRepositoryProvider = EntitlementRepositoryProvider._();

final class EntitlementRepositoryProvider
    extends
        $FunctionalProvider<
          EntitlementRepository,
          EntitlementRepository,
          EntitlementRepository
        >
    with $Provider<EntitlementRepository> {
  EntitlementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entitlementRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entitlementRepositoryHash();

  @$internal
  @override
  $ProviderElement<EntitlementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EntitlementRepository create(Ref ref) {
    return entitlementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EntitlementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EntitlementRepository>(value),
    );
  }
}

String _$entitlementRepositoryHash() =>
    r'5118c4641bc088207a786e34ed3ce5f17bbdb40f';

@ProviderFor(isPremium)
final isPremiumProvider = IsPremiumProvider._();

final class IsPremiumProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  IsPremiumProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isPremiumProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isPremiumHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return isPremium(ref);
  }
}

String _$isPremiumHash() => r'c956e60d8181d88aa1ce4692854907b9620a3acd';
