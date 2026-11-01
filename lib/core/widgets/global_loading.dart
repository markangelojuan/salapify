import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/bouncing_dots.dart';

/// How many blocking operations are running, plus the message to show.
class GlobalLoadingState {
  const GlobalLoadingState({this.count = 0, this.message});

  final int count;
  final String? message;

  bool get isLoading => count > 0;
}

/// Hand-written provider (no codegen / .g.dart needed).
final globalLoadingProvider =
    NotifierProvider<GlobalLoading, GlobalLoadingState>(GlobalLoading.new);

class GlobalLoading extends Notifier<GlobalLoadingState> {
  @override
  GlobalLoadingState build() => const GlobalLoadingState();

  /// Shows the overlay while [task] runs, then hides it (even if [task]
  /// throws — the error still propagates to the caller).
  ///
  /// A counter is used instead of a bool so overlapping operations don't
  /// hide the overlay when the first one finishes.
  ///
  /// Call this from event handlers / controller methods, never from inside
  /// a provider's build() or a widget's build().
  Future<T> run<T>(String? message, Future<T> Function() task) async {
    state = GlobalLoadingState(
      count: state.count + 1,
      message: message ?? state.message,
    );
    try {
      return await task();
    } finally {
      final remaining = state.count - 1;
      state = GlobalLoadingState(
        count: remaining,
        message: remaining > 0 ? state.message : null,
      );
    }
  }
}

/// Wrap your app content with this (see MaterialApp.router `builder`).
class GlobalLoadingOverlay extends ConsumerWidget {
  const GlobalLoadingOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(globalLoadingProvider);

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (loading.isLoading) _LoadingLayer(message: loading.message),
      ],
    );
  }
}

class _LoadingLayer extends StatefulWidget {
  const _LoadingLayer({required this.message});

  final String? message;

  @override
  State<_LoadingLayer> createState() => _LoadingLayerState();
}

class _LoadingLayerState extends State<_LoadingLayer> {
  // Quick operations finish before this and never flash a loader.
  static const _showDelay = Duration(milliseconds: 300);

  // Plain translucent tint (no blur), so it costs almost nothing to draw on
  // any device. Higher = less of the screen behind shows through.
  static const _scrimOpacity = 0.85;

  Timer? _timer;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_showDelay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final message = widget.message;

    // Built once and passed as `child` below, so the fade animation doesn't
    // rebuild it on every frame.
    final content = Semantics(
      container: true,
      liveRegion: true,
      label: message ?? 'Loading',
      child: ExcludeSemantics(
        // Material gives the Text a proper default style; this overlay sits
        // above the Navigator so none is inherited.
        child: Material(
          type: MaterialType.transparency,
          // Isolates the animated dots so only this small layer repaints
          // each frame, not the full-screen scrim.
          child: RepaintBoundary(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BouncingDots(color: colors.primary, dotSize: 12),
                  if (message != null) ...[
                    const SizedBox(height: 18),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                          letterSpacing: -0.1,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        // Blocks taps immediately, even before the visuals fade in.
        const ModalBarrier(dismissible: false, color: Colors.transparent),
        IgnorePointer(
          // Fades the scrim by animating its color alpha, and fades only the
          // small content with Opacity. This avoids wrapping the whole
          // full-screen layer in an offscreen opacity buffer.
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(end: _visible ? 1 : 0),
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: Center(child: content),
            builder: (context, t, child) => ColoredBox(
              color: colors.background.withValues(alpha: _scrimOpacity * t),
              child: Opacity(opacity: t, child: child),
            ),
          ),
        ),
      ],
    );
  }
}