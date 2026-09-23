import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/domain/exceptions/auth_exceptions.dart';

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
    required bool emailVerified,
  }) async {
    await _users.doc(uid).set({
      'username': username,
      'email': email,
      'avatarId': null,
      'isPremium': false,
      'emailVerified': emailVerified,
      'createdAt': FieldValue.serverTimestamp(),
      'preferencesCompleted': false,
    });
  }

  Future<void> markEmailVerified(String uid) async {
    await _users.doc(uid).update({'emailVerified': true});
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

  Future<List<Map<String, String?>>> searchUsernames(String prefix) async {
    if (prefix.isEmpty) return [];
    final query = await _users
        .where('emailVerified', isEqualTo: true)
        .where('username', isGreaterThanOrEqualTo: prefix)
        .where('username', isLessThan: '$prefix\uf8ff')
        .limit(10)
        .get();
    return query.docs
        .map(
          (d) => {
            'uid': d.id,
            'username': d.data()['username'] as String,
            'avatarId': d.data()['avatarId'] as String?,
          },
        )
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

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.data();
  }

  Future<bool> isPremiumUser(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.data()?['isPremium'] as bool? ?? false;
  }

  Future<void> setAvatarId(String uid, String avatarId) async {
    await _users.doc(uid).update({'avatarId': avatarId});
  }

  Future<String> generateUniqueUsername({required String base}) async {
    final sanitized = base.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final fallback = sanitized.isEmpty ? 'user' : sanitized;

    String candidate = fallback;
    int suffix = 0;
    while (await findUidByUsername(candidate) != null) {
      suffix++;
      candidate = '$fallback$suffix';
    }
    return candidate;
  }

  Future<void> markPreferencesCompleted(String uid) async {
    await _users.doc(uid).set({
      'preferencesCompleted': true,
    }, SetOptions(merge: true));
  }

  Future<void> deleteUserProfile(String uid) async {
    await _users.doc(uid).delete();
  }

  Future<void> updateUsername({
    required String uid,
    required String newUsername,
  }) async {
    final existingUid = await findUidByUsername(newUsername);
    if (existingUid != null && existingUid != uid) {
      throw const UsernameTakenException();
    }
    await _users.doc(uid).update({'username': newUsername});
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepository(FirebaseFirestore.instance);
}
