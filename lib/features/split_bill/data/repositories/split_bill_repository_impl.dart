import 'package:salapify/features/split_bill/data/mappers/activity_entry_mapper.dart';
import 'package:salapify/features/split_bill/data/mappers/bill_share_mapper.dart';
import 'package:salapify/features/split_bill/data/mappers/split_bill_mapper.dart';
import 'package:salapify/features/split_bill/data/mappers/split_group_mapper.dart';
import 'package:salapify/features/split_bill/data/repositories/split_bill_repository.dart';
import 'package:salapify/features/split_bill/data/services/split_bill_service.dart';
import 'package:salapify/features/split_bill/domain/entities/activity_entry.dart';
import 'package:salapify/features/split_bill/domain/entities/bill_share.dart';
import 'package:salapify/features/split_bill/domain/entities/payment_status.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';

class SplitBillRepositoryImpl implements SplitBillRepository {
  SplitBillRepositoryImpl(this._service);
  final SplitBillFirestoreService _service;

  @override
  Stream<List<SplitGroup>> watchGroupsForUser(String userId) {
    return _service
        .watchGroupsForUser(userId)
        .map(
          (snap) => snap.docs
              .map((d) => SplitGroupMapper.fromFirestore(d.id, d.data()))
              .toList(),
        );
  }

  @override
  Future<String> createGroup(SplitGroup group) async {
    final ref = await _service.createGroup(group.toFirestore());
    return ref.id;
  }

  @override
  Future<void> deleteGroup(String groupId) => _service.deleteGroup(groupId);

  @override
  Future<void> addMember(String groupId, String memberId) {
    return _service.addMember(groupId, memberId);
  }

  @override
  Future<void> markGroupRead(String groupId, String userId) {
    return _service.markGroupRead(groupId, userId);
  }

  @override
  Stream<List<SplitBill>> watchBills(String groupId) {
    return _service
        .watchBills(groupId)
        .map(
          (snap) => snap.docs
              .map((d) => SplitBillMapper.fromFirestore(d.id, d.data()))
              .toList(),
        );
  }

  @override
  Future<void> createBill(SplitBill bill) {
    return _service.createBill(bill.groupId, bill.toFirestore());
  }

  @override
  Future<void> updateBillShares(
    String groupId,
    String billId,
    List<BillShare> shares,
  ) {
    return _service.updateBillShares(
      groupId,
      billId,
      shares.map((s) => s.toMap()).toList(),
    );
  }

  @override
  Future<void> deleteBill(String groupId, String billId) {
    return _service.deleteBill(groupId, billId);
  }

  @override
  Stream<List<ActivityEntry>> watchActivity(String groupId, {int limit = 50}) {
    return _service
        .watchActivity(groupId, limit: limit)
        .map(
          (snap) => snap.docs
              .map((d) => ActivityEntryMapper.fromFirestore(d.id, d.data()))
              .toList(),
        );
  }

  @override
  Future<List<ActivityEntry>> fetchOlderActivity({
    required String groupId,
    required DateTime before,
    int limit = 50,
  }) async {
    final snap = await _service.fetchOlderActivity(
      groupId,
      before: before,
      limit: limit,
    );
    return snap.docs
        .map((d) => ActivityEntryMapper.fromFirestore(d.id, d.data()))
        .toList();
  }

  @override
  Future<void> removeMember(String groupId, String memberId) {
    return _service.removeMember(groupId, memberId);
  }

  @override
  Future<void> updateGroupDetails({
    required String groupId,
    required String name,
    required List<String> memberIds,
  }) {
    return _service.updateGroup(groupId, {
      'name': name,
      'memberIds': memberIds,
    });
  }

  @override
  Future<void> updateBill(SplitBill bill) {
    return _service.updateBillFields(bill.groupId, bill.id, bill.toFirestore());
  }

  @override
  Future<void> addActivity(ActivityEntry entry) {
    return _service.addActivity(entry.groupId, entry.toFirestore());
  }

  @override
  Future<SplitGroup?> getGroup(String groupId) async {
    final doc = await _service.getGroup(groupId);
    if (!doc.exists) return null;
    return SplitGroupMapper.fromFirestore(doc.id, doc.data()!);
  }

  @override
  Future<void> updateShareStatus({
    required String groupId,
    required String billId,
    required String userId,
    required PaymentStatus status,
  }) {
    return _service.updateShareStatusAtomic(groupId, billId, userId, {
      'status': status.name,
      'statusUpdatedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> createBillWithActivity(SplitBill bill, ActivityEntry activity) {
    return _service.createBillWithActivity(
      bill.groupId,
      bill.toFirestore(),
      activity.toFirestore(),
    );
  }
}
