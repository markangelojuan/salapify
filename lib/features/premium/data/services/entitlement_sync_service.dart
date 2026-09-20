import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/premium/data/repositories/entitlement_repository.dart';

part 'entitlement_sync_service.g.dart';

class EntitlementSyncService {
  EntitlementSyncService(this._entitlementRepo, this._firestore);

  final EntitlementRepository _entitlementRepo;
  final FirebaseFirestore _firestore;

  static const _firestoreTimeout = Duration(seconds: 8);

  /// Pulls the authoritative entitlement fields from `users/{uid}` and
  /// writes them into the local cache. This is the ONLY direction data
  /// flows for entitlement — the local table is never pushed back to
  /// Firestore. Only the (future) Cloud Function is allowed to set
  /// `isPremium` on the remote doc.
  Future<void> pullRemoteEntitlement(String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get()
        .timeout(_firestoreTimeout);

    final data = doc.data();
    if (data == null) return; // no profile yet — nothing to pull

    final isPremium = data['isPremium'] as bool? ?? false;
    final premiumSinceTimestamp = data['premiumSince'] as Timestamp?;
    final premiumProductId = data['premiumProductId'] as String?;

    await _entitlementRepo.setPremium(
      isPremium: isPremium,
      premiumSince: premiumSinceTimestamp?.toDate(),
      productId: premiumProductId,
    );
  }
}

@Riverpod(keepAlive: true)
EntitlementSyncService entitlementSyncService(Ref ref) {
  return EntitlementSyncService(
    ref.watch(entitlementRepositoryProvider),
    FirebaseFirestore.instance,
  );
}