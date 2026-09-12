import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationFirestoreService {
  NotificationFirestoreService(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _items(String uid) =>
      _firestore.collection('notifications').doc(uid).collection('items');

  Stream<QuerySnapshot<Map<String, dynamic>>> watchNotifications(String uid) {
    return _items(
      uid,
    ).orderBy('createdAt', descending: true).limit(50).snapshots();
  }

  Future<void> markRead(String uid, String notificationId) {
    return _items(uid).doc(notificationId).update({'read': true});
  }

  Future<void> markAllRead(String uid) async {
    final unreadSnap = await _items(uid).where('read', isEqualTo: false).get();
    if (unreadSnap.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in unreadSnap.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  Future<int> unreadCount(String uid) async {
    final snap = await _items(
      uid,
    ).where('read', isEqualTo: false).count().get();
    return snap.count ?? 0;
  }
}
