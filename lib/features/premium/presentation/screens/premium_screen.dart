import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/budget/domain/entities/budget_limits.dart';
import 'package:salapify/features/premium/data/repositories/entitlement_repository.dart';
import 'package:salapify/features/premium/data/services/purchase_service.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill_limits.dart';

TextStyle _font(TextStyle style) =>
    GoogleFonts.plusJakartaSans(textStyle: style);

/// Standalone "go premium" destination, distinct from [showPremiumUpsellSheet].
/// The sheet interrupts a specific limited action; this screen is for a
/// considered decision — reachable any time from Account, with the full
/// feature/limit comparison laid out rather than a single contextual reason.
class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool _busy = false;
  late final Future<String?> _priceFuture;

  @override
  void initState() {
    super.initState();
    _priceFuture = ref.read(purchaseServiceProvider).premiumPriceLabel();
  }

  Future<void> _run(
    Future<PurchaseOutcome> Function() action, {
    required String successMessage,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final outcome = await action();
      if (!mounted) return;
      switch (outcome) {
        case PurchaseOutcome.granted:
          CommonSnackbar.showSuccess(context, successMessage);
        case PurchaseOutcome.alreadyClaimedElsewhere:
          CommonSnackbar.showError(
            context,
            'This purchase is linked to a different account. '
            'Sign in with that account to restore it.',
          );
        case PurchaseOutcome.nothingToRestore:
          CommonSnackbar.showWarning(
            context,
            'No previous purchase found to restore.',
          );
        case PurchaseOutcome.cancelled:
          // User backed out of the Play sheet — no message needed.
          break;
        case PurchaseOutcome.notSignedIn:
          CommonSnackbar.showWarning(
            context,
            'Please sign in first to unlock premium.',
          );
        case PurchaseOutcome.notAvailable:
          CommonSnackbar.showError(
            context,
            'Billing is unavailable right now. Please try again later.',
          );
        case PurchaseOutcome.transientFailure:
          CommonSnackbar.showWarning(
            context,
            "Purchase didn't go through. Please try again.",
          );
      }
    } catch (e) {
      if (!mounted) return;
      CommonSnackbar.showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final isPremium = ref.watch(isPremiumProvider).value ?? false;
    final purchaseService = ref.read(purchaseServiceProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Premium',
          style: _font(
            TextStyle(fontWeight: FontWeight.w700, color: colors.textPrimary),
          ),
        ),
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(colors: colors, isPremium: isPremium),
                    const SizedBox(height: 28),
                    Text(
                      'What you get',
                      style: _font(
                        TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _FeatureList(
                      colors: colors,
                      items: [
                        _FeatureItem(
                          icon: Icons.account_balance_wallet_outlined,
                          title:
                              '${BudgetLimits.premiumMaxActiveCategories} active budget categories',
                          subtitle:
                              'Free plan: up to ${BudgetLimits.freeMaxActiveCategories} active',
                        ),
                        _FeatureItem(
                          icon: Icons.groups_outlined,
                          title:
                              '${SplitBillLimits.premiumMaxActiveGroups} active groups',
                          subtitle:
                              'Free plan: up to ${SplitBillLimits.freeMaxActiveGroups} active',
                        ),
                        _FeatureItem(
                          icon: Icons.receipt_long_outlined,
                          title:
                              '${SplitBillLimits.premiumMaxBillsPerGroup} bills per group',
                          subtitle:
                              'Free plan: up to ${SplitBillLimits.freeMaxBillsPerGroup} per group',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    if (!isPremium) ...[
                      Text(
                        'Pricing',
                        style: _font(
                          TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _PriceCard(
                        colors: colors,
                        priceFuture: _priceFuture,
                        busy: _busy,
                        onRestore: () => _run(
                          purchaseService.restorePurchases,
                          successMessage: 'Purchase restored — enjoy!',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 14,
                            color: colors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Secure one-time payment via App Store',
                            style: _font(
                              TextStyle(
                                fontSize: 12,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else
                      _PremiumActiveCard(colors: colors),
                  ],
                ),
              ),
            ),
            if (!isPremium)
              _StickyCta(
                colors: colors,
                priceFuture: _priceFuture,
                busy: _busy,
                onUnlock: () => _run(
                  purchaseService.buyPremium,
                  successMessage: "You're premium now — enjoy!",
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.colors, required this.isPremium});

  final AppColorsExt colors;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors.primary.withValues(alpha: 0.18),
                colors.primary.withValues(alpha: 0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium_rounded,
                size: 16,
                color: colors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                isPremium ? 'You are premium' : 'Be premium',
                style: _font(
                  TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          isPremium
              ? 'Every limit is removed on this account.'
              : 'Remove every free-plan limit',
          style: _font(
            TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: -0.4,
              color: colors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isPremium
              ? 'Thanks for supporting Salapify.'
              : 'One-time payment. No subscription, ever.',
          style: _font(TextStyle(fontSize: 13, color: colors.textSecondary)),
        ),
      ],
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

class _FeatureList extends StatelessWidget {
  const _FeatureList({required this.colors, required this.items});

  final AppColorsExt colors;
  final List<_FeatureItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Divider(height: 1, color: colors.border),
            _featureTile(items[i]),
          ],
        ],
      ),
    );
  }

  Widget _featureTile(_FeatureItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 18, color: colors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: _font(
                    TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: _font(
                    TextStyle(fontSize: 12, color: colors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, size: 20, color: colors.primary),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({
    required this.colors,
    required this.priceFuture,
    required this.busy,
    required this.onRestore,
  });

  final AppColorsExt colors;
  final Future<String?> priceFuture;
  final bool busy;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withValues(alpha: 0.12),
            colors.primary.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.primary.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'BEST VALUE — PAY ONCE',
              style: _font(
                TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: colors.background,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          FutureBuilder<String?>(
            future: priceFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 40,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary,
                      ),
                    ),
                  ),
                );
              }
              final price = snapshot.data;
              return Text(
                price ?? '—',
                textAlign: TextAlign.center,
                style: _font(
                  TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                    letterSpacing: -1,
                    color: colors.textPrimary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            'one-time fee',
            style: _font(TextStyle(fontSize: 12, color: colors.textSecondary)),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: busy ? null : onRestore,
            child: Text(
              'Restore purchase',
              style: _font(
                TextStyle(
                  fontSize: 13,
                  color: colors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumActiveCard extends StatelessWidget {
  const _PremiumActiveCard({required this.colors});

  final AppColorsExt colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(Icons.verified_rounded, size: 32, color: colors.primary),
          const SizedBox(height: 10),
          Text(
            'Premium is active on this account',
            textAlign: TextAlign.center,
            style: _font(
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pinned bottom CTA so the primary action stays reachable while the
/// comparison content scrolls behind it.
class _StickyCta extends StatelessWidget {
  const _StickyCta({
    required this.colors,
    required this.priceFuture,
    required this.busy,
    required this.onUnlock,
  });

  final AppColorsExt colors;
  final Future<String?> priceFuture;
  final bool busy;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: FutureBuilder<String?>(
        future: priceFuture,
        builder: (context, snapshot) {
          final price = snapshot.data;
          final label = price == null ? 'Go Premium' : 'Go Premium — $price';
          return CommonButton(
            label: label,
            btnColor: colors.textPrimary,
            labelColor: colors.background,
            isLoading: busy,
            onPressed: onUnlock,
          );
        },
      ),
    );
  }
}
