import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/notification/data/repositories/notification_repository.dart';
import 'package:salapify/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:salapify/features/notification/data/services/notification_firestore_service.dart';
import 'package:salapify/features/notification/domain/entities/notification_entry.dart';

part 'notification_providers.g.dart';

@Riverpod(keepAlive: true)
NotificationFirestoreService notificationFirestoreService(Ref ref) {
  return NotificationFirestoreService(FirebaseFirestore.instance);
}

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepositoryImpl(ref.watch(notificationFirestoreServiceProvider));
}

@riverpod
Stream<List<NotificationEntry>> notifications(Ref ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  if (uid == null) return const Stream.empty();
  return ref.watch(notificationRepositoryProvider).watchNotifications(uid);
}

@riverpod
int unreadNotificationCount(Ref ref) {
  final items = ref.watch(notificationsProvider).value ?? [];
  return items.where((n) => !n.read).length;
}