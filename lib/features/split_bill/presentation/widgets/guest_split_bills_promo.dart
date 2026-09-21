import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/authentication/presentation/controllers/guest_controller.dart';

class GuestSplitBillPromo extends ConsumerWidget {
  const GuestSplitBillPromo({super.key});

  static const double _portraitHeroMaxHeight = 410;

  static const double _navClearance = 100;
  static const double _topPadding = 8;

  static const double _landscapeTopPadding = 24;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sideBySide = constraints.maxWidth > constraints.maxHeight;

          return sideBySide
              ? _buildSideBySide(context, ref, colors, constraints)
              : _buildStacked(context, ref, colors);
        },
      ),
    );
  }

  Widget _buildStacked(
    BuildContext context,
    WidgetRef ref,
    AppColorsExt colors,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, _topPadding, 28, _navClearance),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: _portraitHeroMaxHeight,
                      ),
                      child: _Hero(colors: colors),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(
                    begin: const Offset(0.96, 0.96),
                    end: const Offset(1, 1),
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: 4),
              ..._textAndCta(ref, colors, landscape: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideBySide(
    BuildContext context,
    WidgetRef ref,
    AppColorsExt colors,
    BoxConstraints constraints,
  ) {
    final isTablet = constraints.maxWidth > 700;
    final heroHeight = (constraints.maxHeight * 0.7).clamp(
      180.0,
      isTablet ? 480.0 : 300.0,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                    width: heroHeight * 0.9,
                    height: heroHeight,
                    child: _Hero(colors: colors),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(
                    begin: const Offset(0.96, 0.96),
                    end: const Offset(1, 1),
                    curve: Curves.easeOut,
                  ),
              SizedBox(width: isTablet ? 48 : 32),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 460 : 360),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _textAndCta(ref, colors, landscape: true),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _textAndCta(
    WidgetRef ref,
    AppColorsExt colors, {
    required bool landscape,
  }) {
    return [
      FittedBox(
            fit: BoxFit.scaleDown,
            alignment: landscape ? Alignment.centerLeft : Alignment.center,
            child: Text(
              'Chip in. Settle up. Stay friends.',
              maxLines: 1,
              textAlign: landscape ? TextAlign.start : TextAlign.center,
              style: TextStyle(
                fontSize: landscape ? 22 : 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: colors.textPrimary,
              ),
            ),
          )
          .animate()
          .fadeIn(delay: 150.ms, duration: 400.ms)
          .slideY(begin: 0.15, end: 0, curve: Curves.easeOut),
      SizedBox(height: landscape ? 8 : 10),
      Text(
        'Create groups, split bills, and see who owes who. '
        'Sign in to sync it all with your friends.',
        textAlign: landscape ? TextAlign.start : TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: colors.textSecondary,
        ),
      ).animate().fadeIn(delay: 230.ms, duration: 400.ms),
      SizedBox(height: landscape ? 12 : 16),
      TextButton.icon(
        onPressed: () {
          ref.read(guestModeProvider.notifier).disable();
        },
        iconAlignment: IconAlignment.end,
        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
        label: const Text('Sign in to get started'),
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          backgroundColor: colors.primary.withValues(alpha: 0.12),
          padding: EdgeInsets.symmetric(
            horizontal: 22,
            vertical: landscape ? 12 : 14,
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
    ];
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.colors});

  final AppColorsExt colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                colors.primary.withValues(alpha: 0.18),
                colors.primary.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),

        ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.85,
                child: Image.asset(
                  'assets/images/chat_graphic.png',
                  fit: BoxFit.contain,
                ),
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(
              begin: -4,
              end: 4,
              duration: 2500.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }
}
