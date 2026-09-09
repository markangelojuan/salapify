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

@ProviderFor(groupMemberNames)
final groupMemberNamesProvider = GroupMemberNamesFamily._();

final class GroupMemberNamesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, String>>,
          Map<String, String>,
          FutureOr<Map<String, String>>
        >
    with
        $FutureModifier<Map<String, String>>,
        $FutureProvider<Map<String, String>> {
  GroupMemberNamesProvider._({
    required GroupMemberNamesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupMemberNamesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupMemberNamesHash();

  @override
  String toString() {
    return r'groupMemberNamesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, String>> create(Ref ref) {
    final argument = this.argument as String;
    return groupMemberNames(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupMemberNamesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupMemberNamesHash() => r'81144d649646e9dcf3317d100ce3cc752a8dfe8e';

final class GroupMemberNamesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, String>>, String> {
  GroupMemberNamesFamily._()
    : super(
        retry: null,
        name: r'groupMemberNamesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupMemberNamesProvider call(String groupId) =>
      GroupMemberNamesProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupMemberNamesProvider';
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
