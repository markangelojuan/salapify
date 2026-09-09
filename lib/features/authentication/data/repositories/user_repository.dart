import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

class UserRepository {
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<void> createUserProfile({
    required String uid,
    required String username,
    required String email,
  }) async {
    await _users.doc(uid).set({
      'username': username,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String?> getUsername(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.data()?['username'] as String?;
  }

  Future<String?> findUidByUsername(String username) async {
    final query = await _users
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return query.docs.first.id;
  }

  Future<List<Map<String, String>>> searchUsernames(String prefix) async {
    if (prefix.isEmpty) return [];
    final query = await _users
        .where('username', isGreaterThanOrEqualTo: prefix)
        .where('username', isLessThan: '$prefix\uf8ff')
        .limit(10)
        .get();
    return query.docs
        .map((d) => {'uid': d.id, 'username': d.data()['username'] as String})
        .toList();
  }

  Future<void> saveFcmToken(String uid, String token) async {
    await _users.doc(uid).update({
      'fcmTokens': FieldValue.arrayUnion([token]),
    });
  }

  Future<void> removeFcmToken(String uid, String token) async {
    await _users.doc(uid).update({
      'fcmTokens': FieldValue.arrayRemove([token]),
    });
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepository(FirebaseFirestore.instance);
}
