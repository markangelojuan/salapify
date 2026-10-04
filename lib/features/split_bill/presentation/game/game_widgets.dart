import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

import 'game_assets.dart';

AppColorsExt _colorsOf(BuildContext context) =>
    Theme.of(context).extension<AppColorsExt>()!;

/// Primary action button, styled like the form screens' CommonButton
/// (textPrimary fill, background-colored label) so it adapts to light/dark.
ButtonStyle _pillFilled(AppColorsExt colors) => FilledButton.styleFrom(
      backgroundColor: colors.textPrimary,
      foregroundColor: colors.background,
      minimumSize: const Size.fromHeight(54),
      shape: const StadiumBorder(),
      textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
    );

// ---------------------------------------------------------------------------
// Small building blocks
// ---------------------------------------------------------------------------

class GameStat extends StatelessWidget {
  const GameStat({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsOf(context);
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Circle-clipped sprite used for every character in the game (avatars,
/// hit sprites, rhino), so they all render the same way.
///
/// - [assetPath] null  -> generic person icon (unknown / missing avatar)
/// - image fails to load -> tries [fallbackPath], then the person icon
class CircleSprite extends StatelessWidget {
  const CircleSprite({
    super.key,
    required this.assetPath,
    required this.diameter,
    this.fallbackPath,
  });

  final String? assetPath;
  final String? fallbackPath;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsOf(context);

    final placeholder = Container(
      color: colors.primary.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: diameter / 2,
        color: colors.primary,
      ),
    );

    Widget content = placeholder;
    final path = assetPath;
    if (path != null) {
      final fallback = fallbackPath;
      content = Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback == null
            ? placeholder
            : Image.asset(
                fallback,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder,
              ),
      );
    }

    return SizedBox(
      width: diameter,
      height: diameter,
      child: ClipOval(child: content),
    );
  }
}

class InstructionRow extends StatelessWidget {
  const InstructionRow({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsOf(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Overlay cards (one per non-playing phase)
// ---------------------------------------------------------------------------

/// Dimmed backdrop + pop-in card. Re-runs the pop-in whenever [phaseKey]
/// changes, so pass the current phase. Use [maxWidth] to widen the card
/// (e.g. for the result modal).
class GameOverlay extends StatelessWidget {
  const GameOverlay({
    super.key,
    required this.phaseKey,
    required this.child,
    this.maxWidth = 360,
  });

  final Object phaseKey;
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsOf(context);
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: TweenAnimationBuilder<double>(
          key: ValueKey(phaseKey),
          tween: Tween(begin: 0.88, end: 1),
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          builder: (_, v, child) => Transform.scale(scale: v, child: child),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              // Scrolls instead of overflowing on short screens, large text
              // scale or landscape. Shrink-wraps when there is enough room.
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReadyCard extends StatelessWidget {
  const ReadyCard({
    super.key,
    required this.totalSeconds,
    required this.sampleAvatarPath,
    required this.onStart,
  });

  final int totalSeconds;
  final String? sampleAvatarPath;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ready?',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'You have $totalSeconds seconds.',
          style: TextStyle(color: colors.textSecondary, fontSize: 15),
        ),
        const SizedBox(height: 24),
        InstructionRow(
          leading: CircleSprite(assetPath: sampleAvatarPath, diameter: 48),
          title: 'Whack your friends',
          subtitle: '+1 point for every hit',
          accent: colors.primary,
        ),
        const SizedBox(height: 12),
        InstructionRow(
          leading: const CircleSprite(
            assetPath: GameAssets.rhino,
            diameter: 48,
          ),
          title: 'Avoid the black rhino!',
          subtitle: '-2 points. Avoid it at all cost!',
          accent: colors.error,
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: onStart,
          style: _pillFilled(colors),
          child: const Text('Start'),
        ),
      ],
    );
  }
}

class TallyCard extends StatelessWidget {
  const TallyCard({super.key, required this.duration});

  /// Length of the karaoke build-up; drives the progress ring.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('⏰', style: TextStyle(fontSize: 44)),
        const SizedBox(height: 8),
        Text(
          'Time\'s up!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 28),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: duration,
          builder: (_, v, __) => SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              value: v,
              strokeWidth: 6,
              color: colors.primary,
              backgroundColor: colors.primary.withValues(alpha: 0.15),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Counting your score...',
          style: TextStyle(color: colors.textSecondary, fontSize: 15),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.score,
    required this.onPlayAgain,
    required this.onDone,
  });

  final int score;
  final VoidCallback onPlayAgain;
  final VoidCallback onDone;

  String get _message => score < 8
      ? 'Just warming up!'
      : score < 18
          ? 'Nice whacking!'
          : score < 28
              ? 'Debt crusher!'
              : 'Absolute legend!';

  @override
  Widget build(BuildContext context) {
    final colors = _colorsOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🏆', style: TextStyle(fontSize: 44)),
        const SizedBox(height: 8),
        Text(
          'Your result',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.08),
            border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                'YOUR SCORE',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 64,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _message,
                style: TextStyle(color: colors.textSecondary, fontSize: 15),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onPlayAgain,
          style: _pillFilled(colors),
          child: const Text('Play again'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: onDone,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            shape: const StadiumBorder(),
            foregroundColor: colors.textPrimary,
            side: BorderSide(color: colors.border),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Done'),
        ),
      ],
    );
  }
}