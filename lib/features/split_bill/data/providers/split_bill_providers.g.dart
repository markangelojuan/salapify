// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_bill_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(splitBillFirestoreService)
final splitBillFirestoreServiceProvider = SplitBillFirestoreServiceProvider._();

final class SplitBillFirestoreServiceProvider
    extends
        $FunctionalProvider<
          SplitBillFirestoreService,
          SplitBillFirestoreService,
          SplitBillFirestoreService
        >
    with $Provider<SplitBillFirestoreService> {
  SplitBillFirestoreServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splitBillFirestoreServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splitBillFirestoreServiceHash();

  @$internal
  @override
  $ProviderElement<SplitBillFirestoreService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SplitBillFirestoreService create(Ref ref) {
    return splitBillFirestoreService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplitBillFirestoreService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplitBillFirestoreService>(value),
    );
  }
}

String _$splitBillFirestoreServiceHash() =>
    r'639968fae4b3b9ccdb968265a205a3f93638fd77';

@ProviderFor(splitBillRepository)
final splitBillRepositoryProvider = SplitBillRepositoryProvider._();

final class SplitBillRepositoryProvider
    extends
        $FunctionalProvider<
          SplitBillRepository,
          SplitBillRepository,
          SplitBillRepository
        >
    with $Provider<SplitBillRepository> {
  SplitBillRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splitBillRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splitBillRepositoryHash();

  @$internal
  @override
  $ProviderElement<SplitBillRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SplitBillRepository create(Ref ref) {
    return splitBillRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplitBillRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplitBillRepository>(value),
    );
  }
}

String _$splitBillRepositoryHash() =>
    r'd1b872330e8046837b20b9950a5062e229fb4ac1';

@ProviderFor(splitGroups)
final splitGroupsProvider = SplitGroupsProvider._();

final class SplitGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SplitGroup>>,
          List<SplitGroup>,
          Stream<List<SplitGroup>>
        >
    with $FutureModifier<List<SplitGroup>>, $StreamProvider<List<SplitGroup>> {
  SplitGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splitGroupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splitGroupsHash();

  @$internal
  @override
  $StreamProviderElement<List<SplitGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SplitGroup>> create(Ref ref) {
    return splitGroups(ref);
  }
}

String _$splitGroupsHash() => r'ee6980aae430edb58e2db17ff796af81d44300ed';

@ProviderFor(splitBills)
final splitBillsProvider = SplitBillsFamily._();

final class SplitBillsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SplitBill>>,
          List<SplitBill>,
          Stream<List<SplitBill>>
        >
    with $FutureModifier<List<SplitBill>>, $StreamProvider<List<SplitBill>> {
  SplitBillsProvider._({
    required SplitBillsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'splitBillsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$splitBillsHash();

  @override
  String toString() {
    return r'splitBillsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<SplitBill>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SplitBill>> create(Ref ref) {
    final argument = this.argument as String;
    return splitBills(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SplitBillsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$splitBillsHash() => r'24e4fca09d176cf5f431b415b82a729186768ff0';

final class SplitBillsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<SplitBill>>, String> {
  SplitBillsFamily._()
    : super(
        retry: null,
        name: r'splitBillsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SplitBillsProvider call(String groupId) =>
      SplitBillsProvider._(argument: groupId, from: this);

  @override
  String toString() => r'splitBillsProvider';
}

@ProviderFor(splitActivity)
final splitActivityProvider = SplitActivityFamily._();

final class SplitActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivityEntry>>,
          List<ActivityEntry>,
          Stream<List<ActivityEntry>>
        >
    with
        $FutureModifier<List<ActivityEntry>>,
        $StreamProvider<List<ActivityEntry>> {
  SplitActivityProvider._({
    required SplitActivityFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'splitActivityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$splitActivityHash();

  @override
  String toString() {
    return r'splitActivityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ActivityEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ActivityEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return splitActivity(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SplitActivityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$splitActivityHash() => r'6450c10ea66887006aaf1603f41d08738b97e883';

final class SplitActivityFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ActivityEntry>>, String> {
  SplitActivityFamily._()
    : super(
        retry: null,
        name: r'splitActivityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SplitActivityProvider call(String groupId) =>
      SplitActivityProvider._(argument: groupId, from: this);

  @override
  String toString() => r'splitActivityProvider';
}

/// Replaces the old `groupMemberNamesProvider`. Same single read per member
/// as before (`getUserProfile` returns the whole doc, same cost as the old
/// `getUsername`), just keeps `avatarId` instead of discarding it.

@ProviderFor(groupMembers)
final groupMembersProvider = GroupMembersFamily._();

/// Replaces the old `groupMemberNamesProvider`. Same single read per member
/// as before (`getUserProfile` returns the whole doc, same cost as the old
/// `getUsername`), just keeps `avatarId` instead of discarding it.

final class GroupMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, GroupMemberInfo>>,
          Map<String, GroupMemberInfo>,
          FutureOr<Map<String, GroupMemberInfo>>
        >
    with
        $FutureModifier<Map<String, GroupMemberInfo>>,
        $FutureProvider<Map<String, GroupMemberInfo>> {
  /// Replaces the old `groupMemberNamesProvider`. Same single read per member
  /// as before (`getUserProfile` returns the whole doc, same cost as the old
  /// `getUsername`), just keeps `avatarId` instead of discarding it.
  GroupMembersProvider._({
    required GroupMembersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupMembersHash();

  @override
  String toString() {
    return r'groupMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, GroupMemberInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, GroupMemberInfo>> create(Ref ref) {
    final argument = this.argument as String;
    return groupMembers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupMembersHash() => r'16133a043aa44f9302bc75d6ed6386bb3dc79617';

/// Replaces the old `groupMemberNamesProvider`. Same single read per member
/// as before (`getUserProfile` returns the whole doc, same cost as the old
/// `getUsername`), just keeps `avatarId` instead of discarding it.

final class GroupMembersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, GroupMemberInfo>>,
          String
        > {
  GroupMembersFamily._()
    : super(
        retry: null,
        name: r'groupMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Replaces the old `groupMemberNamesProvider`. Same single read per member
  /// as before (`getUserProfile` returns the whole doc, same cost as the old
  /// `getUsername`), just keeps `avatarId` instead of discarding it.

  GroupMembersProvider call(String groupId) =>
      GroupMembersProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupMembersProvider';
}

@ProviderFor(splitGroup)
final splitGroupProvider = SplitGroupFamily._();

final class SplitGroupProvider
    extends
        $FunctionalProvider<
          AsyncValue<SplitGroup?>,
          SplitGroup?,
          FutureOr<SplitGroup?>
        >
    with $FutureModifier<SplitGroup?>, $FutureProvider<SplitGroup?> {
  SplitGroupProvider._({
    required SplitGroupFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'splitGroupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$splitGroupHash();

  @override
  String toString() {
    return r'splitGroupProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SplitGroup?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SplitGroup?> create(Ref ref) {
    final argument = this.argument as String;
    return splitGroup(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SplitGroupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$splitGroupHash() => r'edec8eac88030df9a6b79d2c499c0a9116a1484e';

final class SplitGroupFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SplitGroup?>, String> {
  SplitGroupFamily._()
    : super(
        retry: null,
        name: r'splitGroupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SplitGroupProvider call(String groupId) =>
      SplitGroupProvider._(argument: groupId, from: this);

  @override
  String toString() => r'splitGroupProvider';
}

@ProviderFor(totalUnreadSplitCount)
final totalUnreadSplitCountProvider = TotalUnreadSplitCountProvider._();

final class TotalUnreadSplitCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  TotalUnreadSplitCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalUnreadSplitCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalUnreadSplitCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return totalUnreadSplitCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$totalUnreadSplitCountHash() =>
    r'413f5e57b9f3bfe73eb178667c32107ddb5dcff5';

@ProviderFor(ActivityFeed)
final activityFeedProvider = ActivityFeedFamily._();

final class ActivityFeedProvider
    extends $AsyncNotifierProvider<ActivityFeed, List<ActivityEntry>> {
  ActivityFeedProvider._({
    required ActivityFeedFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activityFeedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityFeedHash();

  @override
  String toString() {
    return r'activityFeedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityFeed create() => ActivityFeed();

  @override
  bool operator ==(Object other) {
    return other is ActivityFeedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityFeedHash() => r'98ada509951d91bc84a47c9c33a31f18de0fd2f9';

final class ActivityFeedFamily extends $Family
    with
        $ClassFamilyOverride<
          ActivityFeed,
          AsyncValue<List<ActivityEntry>>,
          List<ActivityEntry>,
          FutureOr<List<ActivityEntry>>,
          String
        > {
  ActivityFeedFamily._()
    : super(
        retry: null,
        name: r'activityFeedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActivityFeedProvider call(String groupId) =>
      ActivityFeedProvider._(argument: groupId, from: this);

  @override
  String toString() => r'activityFeedProvider';
}

abstract class _$ActivityFeed extends $AsyncNotifier<List<ActivityEntry>> {
  late final _$args = ref.$arg as String;
  String get groupId => _$args;

  FutureOr<List<ActivityEntry>> build(String groupId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ActivityEntry>>, List<ActivityEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ActivityEntry>>, List<ActivityEntry>>,
              AsyncValue<List<ActivityEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ActivityLoadingMore)
final activityLoadingMoreProvider = ActivityLoadingMoreFamily._();

final class ActivityLoadingMoreProvider
    extends $NotifierProvider<ActivityLoadingMore, bool> {
  ActivityLoadingMoreProvider._({
    required ActivityLoadingMoreFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activityLoadingMoreProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityLoadingMoreHash();

  @override
  String toString() {
    return r'activityLoadingMoreProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityLoadingMore create() => ActivityLoadingMore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityLoadingMoreProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityLoadingMoreHash() =>
    r'9448846f9a26275822e8a10e25333716cd3521eb';

final class ActivityLoadingMoreFamily extends $Family
    with $ClassFamilyOverride<ActivityLoadingMore, bool, bool, bool, String> {
  ActivityLoadingMoreFamily._()
    : super(
        retry: null,
        name: r'activityLoadingMoreProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActivityLoadingMoreProvider call(String groupId) =>
      ActivityLoadingMoreProvider._(argument: groupId, from: this);

  @override
  String toString() => r'activityLoadingMoreProvider';
}

abstract class _$ActivityLoadingMore extends $Notifier<bool> {
  late final _$args = ref.$arg as String;
  String get groupId => _$args;

  bool build(String groupId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
