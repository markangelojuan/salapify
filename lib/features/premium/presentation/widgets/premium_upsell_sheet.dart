import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/features/premium/domain/entities/premium_limit.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/premium/data/services/purchase_service.dart'
    show PurchaseOutcome;

export 'package:salapify/features/premium/domain/entities/premium_limit.dart';

TextStyle _font(TextStyle style) =>
    GoogleFonts.plusJakartaSans(textStyle: style);

Future<void> showPremiumUpsellSheet(
  BuildContext context, {
  required PremiumLimit limit,
  Future<PurchaseOutcome> Function()? onUnlock,
  Future<PurchaseOutcome> Function()? onRestore,
  String priceLabel = '₱59',
  String benefit = 'Remove every free-plan limit',
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PremiumUpsellSheet(
      limit: limit,
      onUnlock: onUnlock,
      onRestore: onRestore,
      priceLabel: priceLabel,
      benefit: benefit,
    ),
  );
}

class _PremiumUpsellSheet extends StatefulWidget {
  const _PremiumUpsellSheet({
    required this.limit,
    required this.onUnlock,
    required this.onRestore,
    required this.priceLabel,
    required this.benefit,
  });

  final PremiumLimit limit;
  final Future<PurchaseOutcome> Function()? onUnlock;
  final Future<PurchaseOutcome> Function()? onRestore;
  final String priceLabel;
  final String benefit;

  @override
  State<_PremiumUpsellSheet> createState() => _PremiumUpsellSheetState();
}

class _PremiumUpsellSheetState extends State<_PremiumUpsellSheet> {
  bool _busy = false;

  /// UI-only stand-in until purchases exist: shows the loading state briefly,
  /// then leaves the sheet open. Delete once onUnlock is always provided.
  Future<PurchaseOutcome> _previewUnlock() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return PurchaseOutcome.transientFailure;
  }

  Future<void> _run(Future<PurchaseOutcome> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final outcome = await action();
      if (!mounted) return;
      switch (outcome) {
        case PurchaseOutcome.granted:
          Navigator.of(context).pop();
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
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(top: BorderSide(color: colors.border)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 20 + bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                _PremiumPill(colors: colors),
                const SizedBox(height: 14),

                // Headline: the reason the sheet appeared
                Text(
                  widget.limit.message,
                  textAlign: TextAlign.center,
                  style: _font(
                    TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      letterSpacing: -0.4,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // Price: plain type, no container
                Text(
                  widget.priceLabel,
                  textAlign: TextAlign.center,
                  style: _font(
                    TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      letterSpacing: -1,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                if (widget.benefit.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 20,
                        color: colors.textPrimary,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.benefit,
                          style: _font(
                            TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),

                CommonButton(
                  label: 'Go Premium — ${widget.priceLabel}',
                  btnColor: colors.textPrimary,
                  labelColor: colors.background,
                  isLoading: _busy,
                  onPressed: () => _run(widget.onUnlock ?? _previewUnlock),
                ),
                const SizedBox(height: 10),
                Text(
                  'No subscription. Just one-time fee.',
                  textAlign: TextAlign.center,
                  style: _font(
                    TextStyle(fontSize: 12, color: colors.textSecondary),
                  ),
                ),
                const SizedBox(height: 6),

                // Quiet footer actions
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(
                        'Close',
                        style: _font(TextStyle(color: colors.textSecondary)),
                      ),
                    ),
                    if (widget.onRestore != null)
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () => _run(widget.onRestore!),
                        child: Text(
                          'Restore purchase',
                          style: _font(
                            TextStyle(
                              fontSize: 13,
                              color: colors.textSecondary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumPill extends StatelessWidget {
  const _PremiumPill({required this.colors});

  final AppColorsExt colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.textPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            size: 16,
            color: colors.textPrimary,
          ),
          const SizedBox(width: 6),
          Text(
            'Be premium',
            style: _font(
              TextStyle(
                fontSize: 13,
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