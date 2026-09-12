import 'package:salapify/features/notification/data/mappers/notification_entry_mapper.dart';
import 'package:salapify/features/notification/data/repositories/notification_repository.dart';
import 'package:salapify/features/notification/data/services/notification_firestore_service.dart';
import 'package:salapify/features/notification/domain/entities/notification_entry.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._service);
  final NotificationFirestoreService _service;

  @override
  Stream<List<NotificationEntry>> watchNotifications(String uid) {
    return _service.watchNotifications(uid).map(
          (snap) => snap.docs
              .map((d) => NotificationEntryMapper.fromFirestore(d.id, d.data()))
              .toList(),
        );
  }

  @override
  Future<void> markRead(String uid, String notificationId) {
    return _service.markRead(uid, notificationId);
  }

  @override
  Future<void> markAllRead(String uid) {
    return _service.markAllRead(uid);
  }

  @override
  Future<int> unreadCount(String uid) {
    return _service.unreadCount(uid);
  }
}