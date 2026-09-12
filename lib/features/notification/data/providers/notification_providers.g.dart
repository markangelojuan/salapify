// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationFirestoreService)
final notificationFirestoreServiceProvider =
    NotificationFirestoreServiceProvider._();

final class NotificationFirestoreServiceProvider
    extends
        $FunctionalProvider<
          NotificationFirestoreService,
          NotificationFirestoreService,
          NotificationFirestoreService
        >
    with $Provider<NotificationFirestoreService> {
  NotificationFirestoreServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationFirestoreServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationFirestoreServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationFirestoreService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationFirestoreService create(Ref ref) {
    return notificationFirestoreService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationFirestoreService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationFirestoreService>(value),
    );
  }
}

String _$notificationFirestoreServiceHash() =>
    r'15047af10fcff40280813363379dc1162f25f816';

@ProviderFor(notificationRepository)
final notificationRepositoryProvider = NotificationRepositoryProvider._();

final class NotificationRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationRepository,
          NotificationRepository,
          NotificationRepository
        >
    with $Provider<NotificationRepository> {
  NotificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationRepository create(Ref ref) {
    return notificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationRepository>(value),
    );
  }
}

String _$notificationRepositoryHash() =>
    r'e677251e53e670dd91b5836f16b4dac01ec7edcf';

@ProviderFor(notifications)
final notificationsProvider = NotificationsProvider._();

final class NotificationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationEntry>>,
          List<NotificationEntry>,
          Stream<List<NotificationEntry>>
        >
    with
        $FutureModifier<List<NotificationEntry>>,
        $StreamProvider<List<NotificationEntry>> {
  NotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsHash();

  @$internal
  @override
  $StreamProviderElement<List<NotificationEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NotificationEntry>> create(Ref ref) {
    return notifications(ref);
  }
}

String _$notificationsHash() => r'01ee7e184d731521152077c273f91dfd23f4c930';

@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = UnreadNotificationCountProvider._();

final class UnreadNotificationCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  UnreadNotificationCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadNotificationCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadNotificationCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return unreadNotificationCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unreadNotificationCountHash() =>
    r'7f187ee16fb387c67bb6b30fd32a51ff76e411b9';
