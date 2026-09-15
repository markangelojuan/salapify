import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class SplitBillStorageService {
  SplitBillStorageService(this._storage);
  final FirebaseStorage _storage;

  Future<String> uploadActivityPhoto({
    required String groupId,
    required File file,
  }) async {
    final id = const Uuid().v4();
    final ref = _storage.ref('splitGroups/$groupId/activity/$id.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }
}