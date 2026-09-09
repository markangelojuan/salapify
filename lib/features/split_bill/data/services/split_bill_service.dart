import 'package:cloud_firestore/cloud_firestore.dart';

class SplitBillFirestoreService {
  SplitBillFirestoreService(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _groups =>
      _firestore.collection('splitGroups');

  CollectionReference<Map<String, dynamic>> _bills(String groupId) =>
      _groups.doc(groupId).collection('bills');

  CollectionReference<Map<String, dynamic>> _activity(String groupId) =>
      _groups.doc(groupId).collection('activity');

  // Groups
  Stream<QuerySnapshot<Map<String, dynamic>>> watchGroupsForUser(
    String userId,
  ) {
    // Newest activity first (falls back to createdAt via the mapper for
    // any older doc missing lastActivityAt — though such a doc is still
    // excluded from THIS query's results until it has the field
    return _groups
        .where('memberIds', arrayContains: userId)
        .orderBy('lastActivityAt', descending: true)
        .snapshots();
  }

  Future<DocumentReference<Map<String, dynamic>>> createGroup(
    Map<String, dynamic> data,
  ) {
    return _groups.add(data);
  }

  Future<void> deleteGroup(String groupId) => _groups.doc(groupId).delete();

  Future<void> updateGroup(String groupId, Map<String, dynamic> data) {
    return _groups.doc(groupId).update(data);
  }

  Future<void> addMember(String groupId, String memberId) {
    return _groups.doc(groupId).update({
      'memberIds': FieldValue.arrayUnion([memberId]),
    });
  }

  /// Clears [userId]'s unread badge for this group.
  Future<void> markGroupRead(String groupId, String userId) {
    return _groups.doc(groupId).update({'unreadCounts.$userId': 0});
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getGroup(String groupId) {
    return _groups.doc(groupId).get();
  }

  // Bills
  Stream<QuerySnapshot<Map<String, dynamic>>> watchBills(String groupId) {
    return _bills(groupId).orderBy('createdAt', descending: true).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getBill(
    String groupId,
    String billId,
  ) {
    return _bills(groupId).doc(billId).get();
  }

  Future<void> createBill(String groupId, Map<String, dynamic> data) {
    return _bills(groupId).add(data);
  }

  Future<void> updateBillShares(
    String groupId,
    String billId,
    List<Map<String, dynamic>> shares,
  ) {
    return _bills(groupId).doc(billId).update({'shares': shares});
  }

  Future<void> deleteBill(String groupId, String billId) {
    return _bills(groupId).doc(billId).delete();
  }

  // Activity
  Stream<QuerySnapshot<Map<String, dynamic>>> watchActivity(String groupId) {
    return _activity(
      groupId,
    ).orderBy('createdAt', descending: true).snapshots();
  }


  Future<void> addActivity(String groupId, Map<String, dynamic> data) async {
    final groupRef = _groups.doc(groupId);
    final activityRef = _activity(groupId).doc();

    await _firestore.runTransaction((txn) async {
      final groupSnap = await txn.get(groupRef);

      txn.set(activityRef, data);

      if (!groupSnap.exists) return; // group was deleted concurrently

      final memberIds = List<String>.from(
        groupSnap.data()?['memberIds'] as List? ?? const [],
      );
      final senderId = data['senderId'] as String?;

      final updates = <String, dynamic>{
        'lastActivityAt': data['createdAt'] ?? Timestamp.now(),
      };
      for (final id in memberIds) {
        if (id == senderId) continue;
        updates['unreadCounts.$id'] = FieldValue.increment(1);
      }
      txn.update(groupRef, updates);
    });
  }

  Future<void> removeMember(String groupId, String memberId) {
    return _groups.doc(groupId).update({
      'memberIds': FieldValue.arrayRemove([memberId]),
    });
  }

  Future<void> updateBillFields(
    String groupId,
    String billId,
    Map<String, dynamic> data,
  ) {
    return _bills(groupId).doc(billId).update(data);
  }
}