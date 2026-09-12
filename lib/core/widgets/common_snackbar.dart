import 'package:flutter/material.dart';

class CommonSnackbar {
  static OverlayEntry? _currentEntry;
  static String? _currentMessage;

  static void showError(BuildContext context, Object error) {
    _show(context, _sanitizeError(error), Colors.red.shade700, Icons.error_outline_rounded);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, Colors.green.shade700, Icons.check_circle_outline_rounded);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, message, Colors.amber.shade800, Icons.warning_amber_rounded);
  }

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    // Two listeners reacting to the same underlying state change (e.g. a
    // form screen's own error check + a list screen's ref.listen on the
    // same action provider) can both call this within the same frame.
    // Since we track the actual live entry (not just a time window), an
    // identical message already on screen is simply skipped rather than
    // stacked or replaced.
    if (_currentEntry != null && _currentMessage == message) {
      return;
    }

    // Remove any existing banner immediately (no reverse animation) before
    // showing the new one, and make sure it's actually detached.
    if (_currentEntry != null) {
      final old = _currentEntry!;
      if (old.mounted) old.remove();
      _currentEntry = null;
      _currentMessage = null;
    }

    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) => _SnackbarBanner(
        message: message,
        color: color,
        icon: icon,
        onDismissed: () {
          if (_currentEntry == entry) {
            _currentEntry = null;
            _currentMessage = null;
          }
          // This is the actual fix: previously only the static refs were
          // cleared here, so the OverlayEntry itself was never detached
          // from the Overlay and silently lived on forever.
          if (entry.mounted) entry.remove();
        },
      ),
    );

    _currentEntry = entry;
    _currentMessage = message;
    overlay.insert(entry);
  }

  static String _sanitizeError(Object error) {
    final message = error.toString();

    const errorMap = {
      'user-not-found': 'No account found with this email.',
      'wrong-password': 'Incorrect password.',
      'invalid-credential': 'Invalid email or password.',
      'email-already-in-use': 'This email is already registered.',
      'weak-password': 'Password is too weak.',
      'network-request-failed': 'No internet connection.',
      'too-many-requests': 'Too many attempts. Please try again later.',
      'user-disabled': 'This account has been disabled.',
    };

    for (final entry in errorMap.entries) {
      if (message.contains(entry.key)) return entry.value;
    }

    if (error is String) return message;

    return 'Something went wrong. Please try again.';
  }
}

class _SnackbarBanner extends StatefulWidget {
  const _SnackbarBanner({
    required this.message,
    required this.color,
    required this.icon,
    required this.onDismissed,
  });

  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onDismissed;

  @override
  State<_SnackbarBanner> createState() => _SnackbarBannerState();
}

class _SnackbarBannerState extends State<_SnackbarBanner>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  late final Animation<double> _fade;

  // Drives the light that chases around the border while the banner is
  // visible. Runs continuously and independently of the entrance/exit
  // animation above.
  late final AnimationController _borderController;

  bool _dismissing = false;

  static const _displayDuration = Duration(seconds: 3);
  static const _radius = 16.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _controller.forward();
    Future.delayed(_displayDuration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted || _dismissing) return;
    _dismissing = true;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    // Keep it above the keyboard and clear of the home indicator / gesture
    // bar, and give it a generous z-index via the root overlay so it can
    // never end up hidden behind other content.
    final bottomInset = mq.viewInsets.bottom > 0
        ? mq.viewInsets.bottom + 12
        : mq.padding.bottom + 16;

    return Positioned(
      left: 16,
      right: 16,
      bottom: bottomInset,
      child: SlideTransition(
        position: _offset,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: _dismiss,
              onVerticalDragEnd: (details) {
                if ((details.primaryVelocity ?? 0) > 200) _dismiss();
              },
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.97),
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _dismiss,
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white.withValues(alpha: 0.85),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // The chasing light: a bright arc that sweeps around the
                  // rounded-rect border, on a continuous loop, independent
                  // of how long the banner stays visible.
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _borderController,
                        builder: (context, _) => CustomPaint(
                          painter: _RunningBorderPainter(
                            progress: _borderController.value,
                            radius: _radius,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Renamed fields kept local to build() for clarity.
  Color get color => widget.color;
  IconData get icon => widget.icon;
  String get message => widget.message;
}

/// Paints a faint full ring plus one bright arc that sweeps continuously
/// around a rounded rectangle, creating the "light chasing the corners"
/// effect. [progress] should run 0 -> 1 on a loop.
class _RunningBorderPainter extends CustomPainter {
  const _RunningBorderPainter({required this.progress, required this.radius});

  final double progress;
  final double radius;

  static const _strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      _strokeWidth / 2,
      _strokeWidth / 2,
      size.width - _strokeWidth,
      size.height - _strokeWidth,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // Faint base ring so the shape reads even between light passes.
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..color = Colors.white.withValues(alpha: 0.10);
    canvas.drawRRect(rrect, basePaint);

    // The bright comet: a short arc of the sweep gradient is opaque white,
    // the rest is transparent, and the whole thing rotates with `progress`.
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: const [
          Colors.transparent,
          Colors.transparent,
          Colors.white,
          Colors.transparent,
          Colors.transparent,
        ],
        stops: const [0.0, 0.78, 0.86, 0.94, 1.0],
        transform: GradientRotation(progress * 6.28318530718),
      ).createShader(rect);
    canvas.drawRRect(rrect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _RunningBorderPainter oldDelegate) =>
      oldDelegate.progress != progress;
}