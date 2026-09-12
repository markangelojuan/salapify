import 'package:salapify/features/notification/domain/entities/notification_entry.dart';

abstract class NotificationRepository {
  Stream<List<NotificationEntry>> watchNotifications(String uid);
  Future<void> markRead(String uid, String notificationId);
  Future<void> markAllRead(String uid);
  Future<int> unreadCount(String uid);
}