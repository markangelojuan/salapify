import 'dart:async';

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

/// Username + avatarId for a group member, fetched together from the same
/// `users/{uid}` doc so adding avatar support doesn't cost an extra
/// Firestore read per member.
class GroupMemberInfo {
  const GroupMemberInfo({required this.username, this.avatarId});

  final String username;
  final String? avatarId;
}

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

/// Replaces the old `groupMemberNamesProvider`. Same single read per member
/// as before (`getUserProfile` returns the whole doc, same cost as the old
/// `getUsername`), just keeps `avatarId` instead of discarding it.
@riverpod
Future<Map<String, GroupMemberInfo>> groupMembers(
  Ref ref,
  String groupId,
) async {
  final repo = ref.watch(splitBillRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);

  final group = await repo.getGroup(groupId);
  if (group == null) return {};

  final entries = await Future.wait(
    group.memberIds.map((id) async {
      final profile = await userRepo.getUserProfile(id);
      return MapEntry(
        id,
        GroupMemberInfo(
          username: (profile?['username'] as String?) ?? 'Unknown',
          avatarId: profile?['avatarId'] as String?,
        ),
      );
    }),
  );
  return Map.fromEntries(entries);
}

@riverpod
Future<SplitGroup?> splitGroup(Ref ref, String groupId) {
  return ref.watch(splitBillRepositoryProvider).getGroup(groupId);
}

@riverpod
int totalUnreadSplitCount(Ref ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  if (uid == null) return 0;
  final groups = ref.watch(splitGroupsProvider).value ?? [];
  return groups.fold(0, (sum, g) => sum + (g.unreadCounts[uid] ?? 0));
}

@riverpod
class ActivityFeed extends _$ActivityFeed {
  static const _pageSize = 50;
  StreamSubscription<List<ActivityEntry>>? _liveSub;
  bool _hasMore = true;

  @override
  FutureOr<List<ActivityEntry>> build(String groupId) {
    ref.onDispose(() => _liveSub?.cancel());

    final repo = ref.watch(splitBillRepositoryProvider);
    final completer = Completer<List<ActivityEntry>>();

    _liveSub = repo.watchActivity(groupId, limit: _pageSize).listen((live) {
      if (!completer.isCompleted) {
        completer.complete(live);
        return;
      }
      // Merge: live window is authoritative for recent entries; keep
      // whatever older, non-overlapping tail we've already paginated in.
      final current = state.value ?? [];
      final liveIds = live.map((e) => e.id).toSet();
      final cutoff = live.isNotEmpty ? live.last.createdAt : null;
      final tail = current
          .where((e) => !liveIds.contains(e.id))
          .where((e) => cutoff == null || e.createdAt.isBefore(cutoff))
          .toList();
      state = AsyncData([...live, ...tail]);
    });

    return completer.future;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isEmpty || !_hasMore) return;
    if (ref.read(activityLoadingMoreProvider(groupId))) return;

    ref.read(activityLoadingMoreProvider(groupId).notifier).state = true;
    try {
      final older = await ref.read(splitBillRepositoryProvider).fetchOlderActivity(
            groupId: groupId,
            before: current.last.createdAt,
            limit: _pageSize,
          );
      if (older.length < _pageSize) _hasMore = false;
      state = AsyncData([...current, ...older]);
    } finally {
      ref.read(activityLoadingMoreProvider(groupId).notifier).state = false;
    }
  }
}

@riverpod
class ActivityLoadingMore extends _$ActivityLoadingMore {
  @override
  bool build(String groupId) => false;
}