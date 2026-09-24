// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentAppUser)
final currentAppUserProvider = CurrentAppUserProvider._();

final class CurrentAppUserProvider
    extends
        $FunctionalProvider<AsyncValue<AppUser?>, AppUser?, Stream<AppUser?>>
    with $FutureModifier<AppUser?>, $StreamProvider<AppUser?> {
  CurrentAppUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAppUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAppUserHash();

  @$internal
  @override
  $StreamProviderElement<AppUser?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AppUser?> create(Ref ref) {
    return currentAppUser(ref);
  }
}

String _$currentAppUserHash() => r'd4f62fc90e164297f0acd6fd492a9baa4ef4f019';
