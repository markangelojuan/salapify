// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_bill_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SplitBillController)
final splitBillControllerProvider = SplitBillControllerProvider._();

final class SplitBillControllerProvider
    extends $AsyncNotifierProvider<SplitBillController, void> {
  SplitBillControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splitBillControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splitBillControllerHash();

  @$internal
  @override
  SplitBillController create() => SplitBillController();
}

String _$splitBillControllerHash() =>
    r'e8d822fb31d8324126bfd42f22c4821c8ef51dca';

abstract class _$SplitBillController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
