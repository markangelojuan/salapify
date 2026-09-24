import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_repository.g.dart';

class ReportRepository {
  ReportRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> submitReport({
    required String reporterId,
    required String reportedUserId,
    required String reportedUsername,
    required String groupId,
    required String note,
  }) async {
    await _firestore.collection('reports').add({
      'reporterId': reporterId,
      'reportedUserId': reportedUserId,
      'reportedUsername': reportedUsername,
      'groupId': groupId,
      'note': note,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

@Riverpod(keepAlive: true)
ReportRepository reportRepository(Ref ref) {
  return ReportRepository(FirebaseFirestore.instance);
}