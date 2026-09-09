import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/split_bill/data/repositories/split_bill_repository.dart';
import 'package:salapify/features/split_bill/data/repositories/split_bill_repository_impl.dart';
import 'package:salapify/features/split_bill/data/services/split_bill_service.dart';
import 'package:salapify/features/split_bill/domain/entities/activity_entry.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';

part 'split_bill_providers.g.dart';

@Riverpod(keepAlive: true)
SplitBillFirestoreService splitBillFirestoreService(Ref ref) {
  return SplitBillFirestoreService(FirebaseFirestore.instance);
}

@Riverpod(keepAlive: true)
SplitBillRepository splitBillRepository(Ref ref) {
  return SplitBillRepositoryImpl(ref.watch(splitBillFirestoreServiceProvider));
}

@riverpod
Stream<List<SplitGroup>> splitGroups(Ref ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  if (uid == null) return const Stream.empty();
  return ref.watch(splitBillRepositoryProvider).watchGroupsForUser(uid);
}

@riverpod
Stream<List<SplitBill>> splitBills(Ref ref, String groupId) {
  return ref.watch(splitBillRepositoryProvider).watchBills(groupId);
}

@riverpod
Stream<List<ActivityEntry>> splitActivity(Ref ref, String groupId) {
  return ref.watch(splitBillRepositoryProvider).watchActivity(groupId);
}

@riverpod
Future<Map<String, String>> groupMemberNames(Ref ref, String groupId) async {
  final repo = ref.watch(splitBillRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);

  final group = await repo.getGroup(groupId);
  if (group == null) return {};

  final entries = await Future.wait(
    group.memberIds.map((id) async {
      final username = await userRepo.getUsername(id);
      return MapEntry(id, username ?? 'Unknown');
    }),
  );
  return Map.fromEntries(entries);
}

@riverpod
Future<SplitGroup?> splitGroup(Ref ref, String groupId) {
  return ref.watch(splitBillRepositoryProvider).getGroup(groupId);
}