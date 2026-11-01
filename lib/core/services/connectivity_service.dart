import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// Emits true when the device has network connectivity, false otherwise.
/// Note: this reflects network reachability, not guaranteed internet access
/// (e.g. connected to Wi-Fi with no internet still reports true). Good enough
/// for triggering sync attempts, which will simply fail and retry if there's
/// no real connectivity.
@Riverpod(keepAlive: true)
Stream<bool> isOnline(Ref ref) {
  final connectivity = Connectivity();

  return connectivity.onConnectivityChanged.map((results) {
    return !results.contains(ConnectivityResult.none);
  });
}