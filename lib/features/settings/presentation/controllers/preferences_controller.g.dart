// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Commits the first-time preferences (budgeting period, first-half end day,
/// currency) and flags the user's profile as onboarded.

@ProviderFor(PreferencesController)
final preferencesControllerProvider = PreferencesControllerProvider._();

/// Commits the first-time preferences (budgeting period, first-half end day,
/// currency) and flags the user's profile as onboarded.
final class PreferencesControllerProvider
    extends $AsyncNotifierProvider<PreferencesController, void> {
  /// Commits the first-time preferences (budgeting period, first-half end day,
  /// currency) and flags the user's profile as onboarded.
  PreferencesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesControllerHash();

  @$internal
  @override
  PreferencesController create() => PreferencesController();
}

String _$preferencesControllerHash() =>
    r'6f62f190cd86e1dfdebf7d7eda2586eee5d8ca81';

/// Commits the first-time preferences (budgeting period, first-half end day,
/// currency) and flags the user's profile as onboarded.

abstract class _$PreferencesController extends $AsyncNotifier<void> {
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
