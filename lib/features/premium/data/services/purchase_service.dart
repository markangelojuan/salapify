import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/premium/data/services/entitlement_sync_service.dart';

part 'purchase_service.g.dart';

/// Must match the Product ID created in Play Console exactly.
const String kPremiumProductId = 'premium_upgrade';

/// Outcome of a [PurchaseService.buyPremium] or [PurchaseService.restorePurchases]
/// call. Kept granular so the UI can show an accurate message instead of a
/// generic "didn't work, try again" for cases that aren't actually retryable.
enum PurchaseOutcome {
  /// Entitlement was verified and granted.
  granted,

  /// User cancelled the Play purchase sheet, or the flow errored out on the
  /// store side. Retrying makes sense.
  cancelled,

  /// The purchase token was already redeemed by a different account.
  /// This is a real, final state — retrying will not help.
  alreadyClaimedElsewhere,

  /// Network blip, function cold-start error, or similar. Safe to retry.
  transientFailure,

  /// No signed-in user to attach the entitlement to.
  notSignedIn,

  /// Billing unavailable, or the product couldn't be loaded from the store.
  notAvailable,

  /// [restorePurchases] specifically: no previous purchase was found for
  /// this account within the wait window.
  nothingToRestore,
}

class PurchaseService {
  PurchaseService({
    required InAppPurchase iap,
    required FirebaseFunctions functions,
    required EntitlementSyncService syncService,
    required FirebaseAuth auth,
  }) : _iap = iap,
       _functions = functions,
       _syncService = syncService,
       _auth = auth;

  final InAppPurchase _iap;
  final FirebaseFunctions _functions;
  final EntitlementSyncService _syncService;
  final FirebaseAuth _auth;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Completer<PurchaseOutcome>? _pendingCompleter;
  ProductDetails? _cachedProduct;

  /// Call once, e.g. from a keepAlive provider's build method, before any
  /// purchase button can be tapped.
  Future<void> init() async {
    if (_subscription != null) return;
    final available = await _iap.isAvailable();
    if (!available) {
      return;
    }
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (Object _) => _resolvePending(PurchaseOutcome.transientFailure),
    );
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<ProductDetails?> _loadProduct() async {
    if (_cachedProduct != null) return _cachedProduct;
    final response = await _iap.queryProductDetails({kPremiumProductId});
    if (response.error != null || response.productDetails.isEmpty) {
      return null;
    }
    _cachedProduct = response.productDetails.first;
    return _cachedProduct;
  }

  /// The store-formatted price (e.g. "₱59.00"), or null if not loaded yet.
  Future<String?> premiumPriceLabel() async {
    if (!await _iap.isAvailable()) return null;
    return (await _loadProduct())?.price;
  }

  Future<PurchaseOutcome> buyPremium() async {
    if (_auth.currentUser == null) {
      // Entitlement is written to users/{uid} — without a signed-in user
      // there's nowhere for the grant to attach to.
      return PurchaseOutcome.notSignedIn;
    }
    if (!await _iap.isAvailable()) return PurchaseOutcome.notAvailable;

    final product = await _loadProduct();
    if (product == null) return PurchaseOutcome.notAvailable;

    _pendingCompleter = Completer<PurchaseOutcome>();
    final started = await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
    if (!started) {
      _pendingCompleter = null;
      return PurchaseOutcome.transientFailure;
    }

    return _pendingCompleter!.future.timeout(
      const Duration(minutes: 3),
      onTimeout: () => PurchaseOutcome.transientFailure,
    );
  }

  Future<PurchaseOutcome> restorePurchases() async {
    if (_auth.currentUser == null) return PurchaseOutcome.notSignedIn;

    _pendingCompleter = Completer<PurchaseOutcome>();
    await _iap.restorePurchases();

    // If the user never bought it, Play simply never emits anything on the
    // stream for this product — so this has to time out rather than hang.
    return _pendingCompleter!.future.timeout(
      const Duration(seconds: 12),
      onTimeout: () => PurchaseOutcome.nothingToRestore,
    );
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final details in purchases) {
      if (details.productID != kPremiumProductId) continue;

      switch (details.status) {
        case PurchaseStatus.pending:
          continue; // still awaiting user action in the Play sheet

        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          _resolvePending(PurchaseOutcome.cancelled);
          if (details.pendingCompletePurchase) {
            await _iap.completePurchase(details);
          }

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final result = await _verifyAndGrant(details);
          _resolvePending(result);
          // Only tell Play we're done if there's nothing left to retry.
          // A transient failure (network blip, function cold-start error)
          // leaves the purchase un-acknowledged so it's redelivered on the
          // next purchaseStream/restorePurchases call instead of being lost.
          if (result != PurchaseOutcome.transientFailure &&
              details.pendingCompletePurchase) {
            await _iap.completePurchase(details);
          }
      }
    }
  }

  void _resolvePending(PurchaseOutcome result) {
    final completer = _pendingCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(result);
    }
    _pendingCompleter = null;
  }

  Future<PurchaseOutcome> _verifyAndGrant(PurchaseDetails details) async {
    try {
      final callable = _functions.httpsCallable('verifyPurchase');
      await callable.call<Map<String, dynamic>>({
        'productId': details.productID,
        'purchaseToken': details.verificationData.serverVerificationData,
      });

      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await _syncService.pullRemoteEntitlement(uid);
      }
      return PurchaseOutcome.granted;
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'already-exists') {
        // Token was redeemed by a different account — real, not retryable.
        return PurchaseOutcome.alreadyClaimedElsewhere;
      }
      return PurchaseOutcome.transientFailure;
    } catch (_) {
      return PurchaseOutcome.transientFailure;
    }
  }
}

@Riverpod(keepAlive: true)
PurchaseService purchaseService(Ref ref) {
  final service = PurchaseService(
    iap: InAppPurchase.instance,
    functions: FirebaseFunctions.instance,
    syncService: ref.watch(entitlementSyncServiceProvider),
    auth: FirebaseAuth.instance,
  );
  service.init();
  ref.onDispose(service.dispose);
  return service;
}