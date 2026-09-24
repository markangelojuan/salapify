import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/domain/exceptions/auth_exceptions.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';

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

  Future<void> blockUser({
    required String blockerId,
    required String blockedId,
  }) async {
    final batch = _firestore.batch();
    batch.update(_users.doc(blockerId), {
      'blockedUserIds': FieldValue.arrayUnion([blockedId]),
    });
    batch.update(_users.doc(blockedId), {
      'blockedByUserIds': FieldValue.arrayUnion([blockerId]),
    });
    await batch.commit();
  }

  Future<void> unblockUser({
    required String blockerId,
    required String blockedId,
  }) async {
    final batch = _firestore.batch();
    batch.update(_users.doc(blockerId), {
      'blockedUserIds': FieldValue.arrayRemove([blockedId]),
    });
    batch.update(_users.doc(blockedId), {
      'blockedByUserIds': FieldValue.arrayRemove([blockerId]),
    });
    await batch.commit();
  }

  Stream<List<String>> watchBlockedIds(String uid) {
    return _users
        .doc(uid)
        .snapshots()
        .map(
          (doc) =>
              List<String>.from(doc.data()?['blockedUserIds'] as List? ?? []),
        );
  }

  Stream<Set<String>> watchBlockedAndBlockingIds(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      final blocked = List<String>.from(
        doc.data()?['blockedUserIds'] as List? ?? [],
      );
      final blockedBy = List<String>.from(
        doc.data()?['blockedByUserIds'] as List? ?? [],
      );
      return {...blocked, ...blockedBy};
    });
  }

  Stream<Map<String, dynamic>?> watchUserProfile(String uid) {
    return _users.doc(uid).snapshots().map((doc) => doc.data());
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepository(FirebaseFirestore.instance);
}

class BlockedUserInfo {
  const BlockedUserInfo({
    required this.uid,
    required this.username,
    this.avatarId,
  });

  final String uid;
  final String username;
  final String? avatarId;
}

/// People *I* have blocked — feeds the Blocked Users settings screen.
@Riverpod(keepAlive: true)
Stream<List<String>> blockedUserIds(Ref ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  if (uid == null) return Stream.value(const <String>[]);
  return ref.watch(userRepositoryProvider).watchBlockedIds(uid);
}

/// Union of blocked + blocked-by — feeds chat filtering and member search.
@Riverpod(keepAlive: true)
Stream<Set<String>> blockedAndBlockingIds(Ref ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  if (uid == null) return Stream.value(const <String>{});
  return ref.watch(userRepositoryProvider).watchBlockedAndBlockingIds(uid);
}

@riverpod
Future<List<BlockedUserInfo>> blockedUsersInfo(Ref ref) async {
  final ids = await ref.watch(blockedUserIdsProvider.future);
  final userRepo = ref.watch(userRepositoryProvider);

  final entries = await Future.wait(
    ids.map((id) async {
      final profile = await userRepo.getUserProfile(id);
      return BlockedUserInfo(
        uid: id,
        username: (profile?['username'] as String?) ?? 'Unknown',
        avatarId: profile?['avatarId'] as String?,
      );
    }),
  );
  return entries;
}
