import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/split_bill/domain/entities/activity_entry.dart';
import 'package:salapify/features/split_bill/domain/entities/payment_status.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';

part 'split_bill_controller.g.dart';

@Riverpod(keepAlive: true)
class SplitBillController extends _$SplitBillController {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> createGroup({
    required String name,
    required List<String> memberIds, // does NOT include the creator
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentUser = ref.read(authRepositoryProvider).currentUser;
      if (currentUser == null) throw StateError('Not signed in');

      final now = DateTime.now();
      final group = SplitGroup(
        id: '',
        name: name,
        memberIds: {currentUser.uid, ...memberIds}.toList(),
        createdBy: currentUser.uid,
        createdAt: now,
        lastActivityAt: now,
      );

      await ref.read(splitBillRepositoryProvider).createGroup(group);
    });
  }

  /// Full replace of name + membership, used by the group edit form.
  /// [memberIds] should be the complete desired list, including the creator.
  Future<void> updateGroupDetails({
    required String groupId,
    required String name,
    required List<String> memberIds,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(splitBillRepositoryProvider)
          .updateGroupDetails(
            groupId: groupId,
            name: name,
            memberIds: memberIds,
          );
    });
  }

  /// Removes the current user from the group. Anyone can call this,
  /// including the creator (the group persists for remaining members).
  Future<void> leaveGroup(String groupId) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(splitBillRepositoryProvider)
          .removeMember(groupId, currentUser.uid);
    });
  }

  /// Fully deletes the group. Intended for the creator only — enforce that
  /// in the UI before calling this.
  Future<void> deleteGroup(String groupId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(splitBillRepositoryProvider).deleteGroup(groupId);
    });
  }


  Future<void> markGroupRead(String groupId) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    try {
      await ref
          .read(splitBillRepositoryProvider)
          .markGroupRead(groupId, currentUser.uid);
    } catch (_) {
      // Non-critical — failing to clear a read receipt shouldn't surface
      // an error to the user.
    }
  }

  /// Saves the bill and logs the "bill added" activity entry as one unit,
  /// so screens can never save one without the other.
  Future<void> createBill(SplitBill bill) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(splitBillRepositoryProvider);
      await repo.createBill(bill);
      await repo.addActivity(
        ActivityEntry(
          id: '',
          groupId: bill.groupId,
          senderId: bill.paidBy,
          type: ActivityType.billAdded,
          createdAt: DateTime.now(),
          metadata: {'billTitle': bill.title, 'amount': bill.totalAmount},
        ),
      );
    });
  }

  /// Full edit of an existing bill. Enforce "only the creator can edit" in
  /// the UI — this method doesn't re-check `paidBy` itself.
  Future<void> updateBill(SplitBill bill) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(splitBillRepositoryProvider).updateBill(bill);
    });
  }

  /// Enforce "only the creator can delete" in the UI.
  Future<void> deleteBill({
    required String groupId,
    required String billId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(splitBillRepositoryProvider).deleteBill(groupId, billId);
    });
  }

  Future<void> sendMessage({
    required String groupId,
    required String text,
  }) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    state = await AsyncValue.guard(() async {
      await ref
          .read(splitBillRepositoryProvider)
          .addActivity(
            ActivityEntry(
              id: '',
              groupId: groupId,
              senderId: currentUser.uid,
              type: ActivityType.message,
              createdAt: DateTime.now(),
              text: text,
            ),
          );
    });
  }

  Future<void> updateShareStatus({
    required String groupId,
    required String billId,
    required String userId, // whose share this is (the ower)
    required PaymentStatus status,
    String? actorId, // who performed the action; defaults to userId
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(splitBillRepositoryProvider);
      await repo.updateShareStatus(
        groupId: groupId,
        billId: billId,
        userId: userId,
        status: status,
      );

      final activityType = switch (status) {
        PaymentStatus.markedPaid => ActivityType.paymentMarked,
        PaymentStatus.confirmed => ActivityType.paymentConfirmed,
        PaymentStatus.disputed => ActivityType.paymentDisputed,
        PaymentStatus.unpaid => null,
      };
      if (activityType == null) return;

      final isActorEvent =
          status == PaymentStatus.confirmed || status == PaymentStatus.disputed;

      await repo.addActivity(
        ActivityEntry(
          id: '',
          groupId: groupId,
          senderId: actorId ?? userId,
          type: activityType,
          createdAt: DateTime.now(),
          metadata: isActorEvent ? {'targetUserId': userId} : null,
        ),
      );
    });
  }
}