import 'package:salapify/features/split_bill/domain/entities/activity_entry.dart';
import 'package:salapify/features/split_bill/domain/entities/bill_share.dart';
import 'package:salapify/features/split_bill/domain/entities/payment_status.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';

abstract class SplitBillRepository {
  Stream<List<SplitGroup>> watchGroupsForUser(String userId);
  Future<String> createGroup(SplitGroup group);
  Future<void> deleteGroup(String groupId);
  Future<void> addMember(String groupId, String memberId);
  Future<void> removeMember(String groupId, String memberId);
  Future<void> updateGroupDetails({
    required String groupId,
    required String name,
    required List<String> memberIds,
  });

  Future<void> createBillWithActivity(SplitBill bill, ActivityEntry activity);

  /// Resets [userId]'s unread badge count for [groupId] to 0.
  Future<void> markGroupRead(String groupId, String userId);

  Stream<List<SplitBill>> watchBills(String groupId);
  Future<void> createBill(SplitBill bill);
  Future<void> updateBill(SplitBill bill);
  Future<void> updateBillShares(
    String groupId,
    String billId,
    List<BillShare> shares,
  );
  Future<void> deleteBill(String groupId, String billId);

  Stream<List<ActivityEntry>> watchActivity(String groupId);
  Future<void> addActivity(ActivityEntry entry);

  Future<SplitGroup?> getGroup(String groupId);
  Future<void> updateShareStatus({
    required String groupId,
    required String billId,
    required String userId,
    required PaymentStatus status,
  });
}