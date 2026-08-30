// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Emits true when the device has network connectivity, false otherwise.
/// Note: this reflects network reachability, not guaranteed internet access
/// (e.g. connected to Wi-Fi with no internet still reports true). Good enough
/// for triggering sync attempts, which will simply fail and retry if there's
/// no real connectivity.

@ProviderFor(isOnline)
final isOnlineProvider = IsOnlineProvider._();

/// Emits true when the device has network connectivity, false otherwise.
/// Note: this reflects network reachability, not guaranteed internet access
/// (e.g. connected to Wi-Fi with no internet still reports true). Good enough
/// for triggering sync attempts, which will simply fail and retry if there's
/// no real connectivity.

final class IsOnlineProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Emits true when the device has network connectivity, false otherwise.
  /// Note: this reflects network reachability, not guaranteed internet access
  /// (e.g. connected to Wi-Fi with no internet still reports true). Good enough
  /// for triggering sync attempts, which will simply fail and retry if there's
  /// no real connectivity.
  IsOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOnlineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOnlineHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return isOnline(ref);
  }
}

String _$isOnlineHash() => r'f0da56f380a9192c5fd28a5e55bce11bb29aa9ee';
