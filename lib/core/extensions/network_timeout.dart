
/// Applies a consistent timeout to any Future that talks to the network.
/// Firestore *reads* fail fast when offline (so they don't usually need
/// this), but Firestore *writes* get queued locally and their Future can
/// hang indefinitely with no connection — this turns that hang into a
/// TimeoutException
extension NetworkTimeout<T> on Future<T> {
  Future<T> withNetworkTimeout([
    Duration duration = const Duration(seconds: 10),
  ]) {
    return timeout(duration);
  }
}