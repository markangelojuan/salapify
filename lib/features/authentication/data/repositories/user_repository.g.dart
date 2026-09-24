// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userRepository)
final userRepositoryProvider = UserRepositoryProvider._();

final class UserRepositoryProvider
    extends $FunctionalProvider<UserRepository, UserRepository, UserRepository>
    with $Provider<UserRepository> {
  UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserRepository create(Ref ref) {
    return userRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRepository>(value),
    );
  }
}

String _$userRepositoryHash() => r'87287d4e46f84fa6e8d053d1070a93681d49f70f';

/// People *I* have blocked — feeds the Blocked Users settings screen.

@ProviderFor(blockedUserIds)
final blockedUserIdsProvider = BlockedUserIdsProvider._();

/// People *I* have blocked — feeds the Blocked Users settings screen.

final class BlockedUserIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          Stream<List<String>>
        >
    with $FutureModifier<List<String>>, $StreamProvider<List<String>> {
  /// People *I* have blocked — feeds the Blocked Users settings screen.
  BlockedUserIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blockedUserIdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blockedUserIdsHash();

  @$internal
  @override
  $StreamProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<String>> create(Ref ref) {
    return blockedUserIds(ref);
  }
}

String _$blockedUserIdsHash() => r'0f62983fdb236bb245359742c1db935ffce62f79';

/// Union of blocked + blocked-by — feeds chat filtering and member search.

@ProviderFor(blockedAndBlockingIds)
final blockedAndBlockingIdsProvider = BlockedAndBlockingIdsProvider._();

/// Union of blocked + blocked-by — feeds chat filtering and member search.

final class BlockedAndBlockingIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          Stream<Set<String>>
        >
    with $FutureModifier<Set<String>>, $StreamProvider<Set<String>> {
  /// Union of blocked + blocked-by — feeds chat filtering and member search.
  BlockedAndBlockingIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blockedAndBlockingIdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blockedAndBlockingIdsHash();

  @$internal
  @override
  $StreamProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<String>> create(Ref ref) {
    return blockedAndBlockingIds(ref);
  }
}

String _$blockedAndBlockingIdsHash() =>
    r'd4d6cecc19ce440e10c01784377597b3410537c8';

@ProviderFor(blockedUsersInfo)
final blockedUsersInfoProvider = BlockedUsersInfoProvider._();

final class BlockedUsersInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BlockedUserInfo>>,
          List<BlockedUserInfo>,
          FutureOr<List<BlockedUserInfo>>
        >
    with
        $FutureModifier<List<BlockedUserInfo>>,
        $FutureProvider<List<BlockedUserInfo>> {
  BlockedUsersInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blockedUsersInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blockedUsersInfoHash();

  @$internal
  @override
  $FutureProviderElement<List<BlockedUserInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BlockedUserInfo>> create(Ref ref) {
    return blockedUsersInfo(ref);
  }
}

String _$blockedUsersInfoHash() => r'4cd1b7a96b864e9ecbb824e7eaa3d9f0d3645751';
