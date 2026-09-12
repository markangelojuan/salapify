import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/notification/data/providers/notification_providers.dart';

part 'notification_controller.g.dart';

@Riverpod(keepAlive: true)
class NotificationController extends _$NotificationController {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> markRead(String notificationId) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;
    try {
      await ref
          .read(notificationRepositoryProvider)
          .markRead(currentUser.uid, notificationId);
      // no invalidate needed — unreadNotificationCountProvider derives live from notificationsProvider
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(notificationRepositoryProvider)
          .markAllRead(currentUser.uid);
    });
  }
}
