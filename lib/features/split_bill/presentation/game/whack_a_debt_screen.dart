import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/authentication/domain/entities/avatar_option.dart';

import 'game_assets.dart';
import 'game_audio.dart';
import 'game_widgets.dart';

enum _Kind { avatar, enemy }

class _Target {
  _Target(this.kind, this.avatarId, this.expiresAt);
  final _Kind kind;
  final String? avatarId;
  DateTime expiresAt;
  bool hit = false;
}

enum _Phase { ready, playing, tallying, done }

/// Pops with the final score (int) when the player taps "Done".
class WhackADebtScreen extends StatefulWidget {
  const WhackADebtScreen({super.key, required this.avatarIds});

  /// Avatars of the group members, used as the "good" targets.
  final List<String?> avatarIds;

  @override
  State<WhackADebtScreen> createState() => _WhackADebtScreenState();
}

class _WhackADebtScreenState extends State<WhackADebtScreen>
    with WidgetsBindingObserver {
  static const _totalSeconds = 30;
  static const _holeCount = 9;
  static const _hitLingerMs = 250;
  static const _tallyMs = 6000; 
  static const _firstSpawnDelayMs = 400;
  static const _enemyChance = 0.25;
  static const _enemyPenalty = 2;
  static const _gapStartMs = 700, _gapShrinkMs = 350;
  static const _lifeStartMs = 1100, _lifeShrinkMs = 500;

  static const _gridSpacing = 12.0;
  static const _maxGridSide = 420.0;

  static const _overlayMaxWidth = 360.0;
  static const _resultMaxWidth = 390.0;

  final _rng = Random();
  final _audio = WhackAudio();
  final List<_Target?> _holes = List.filled(_holeCount, null);

  Timer? _timer;
  Timer? _tallyTimer;
  _Phase _phase = _Phase.ready;
  int _score = 0;
  late DateTime _endsAt;
  late DateTime _nextSpawn;
  bool _precached = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audio.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;

    final paths = <String>{GameAssets.rhino, GameAssets.rhinoHit};
    for (final id in widget.avatarIds.toSet()) {
      final option = avatarById(id);
      if (option != null) {
        paths
          ..add(option.assetPath)
          ..add(GameAssets.hitSprite(option.id));
      }
    }
    for (final p in paths) {
      precacheImage(AssetImage(p), context, onError: (_, __) {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _tallyTimer?.cancel();
    _audio.dispose();
    super.dispose();
  }


  /// Resumes whichever track belongs to the current phase (no-op if muted).
  void _resumeAudioForPhase() {
    if (_phase == _Phase.playing) {
      _audio.resumeMusic();
    } else if (_phase == _Phase.tallying) {
      _audio.resumeResult();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _audio.pauseAll();
    } else {
      _resumeAudioForPhase();
    }
  }

  void _toggleMute() {
    setState(() => _audio.setMuted(!_audio.muted));
    if (!_audio.muted) _resumeAudioForPhase();
  }


  void _clearHoles() {
    for (var i = 0; i < _holeCount; i++) {
      _holes[i] = null;
    }
  }

  void _start() {
    final now = DateTime.now();
    setState(() {
      _phase = _Phase.playing;
      _score = 0;
      _clearHoles();
      _endsAt = now.add(const Duration(seconds: _totalSeconds));
      _nextSpawn = now.add(const Duration(milliseconds: _firstSpawnDelayMs));
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), _tick);

    _tallyTimer?.cancel();
    _audio.startMusic();
  }

  void _tick(Timer t) {
    final now = DateTime.now();
    if (now.isAfter(_endsAt)) {
      t.cancel();
      setState(() {
        _clearHoles();
        _phase = _Phase.tallying;
      });
      _audio.startResult();
      _tallyTimer = Timer(const Duration(milliseconds: _tallyMs), () {
        if (mounted) setState(() => _phase = _Phase.done);
      });
      return;
    }
    setState(() {
      for (var i = 0; i < _holeCount; i++) {
        final h = _holes[i];
        if (h != null && now.isAfter(h.expiresAt)) _holes[i] = null;
      }
      if (!now.isBefore(_nextSpawn)) _spawn(now);
    });
  }

  void _spawn(DateTime now) {
    final empty = [
      for (var i = 0; i < _holeCount; i++)
        if (_holes[i] == null) i,
    ];
    final remaining = _endsAt.difference(now).inMilliseconds;
    final p = 1 - remaining / (_totalSeconds * 1000);
    final gapMs = (_gapStartMs - _gapShrinkMs * p).round();
    final lifeMs = (_lifeStartMs - _lifeShrinkMs * p).round();
    _nextSpawn = now.add(Duration(milliseconds: gapMs));
    if (empty.isEmpty) return;

    final index = empty[_rng.nextInt(empty.length)];
    final isEnemy = _rng.nextDouble() < _enemyChance;
    final ids = widget.avatarIds;
    _holes[index] = _Target(
      isEnemy ? _Kind.enemy : _Kind.avatar,
      isEnemy || ids.isEmpty ? null : ids[_rng.nextInt(ids.length)],
      now.add(Duration(milliseconds: lifeMs)),
    );
  }

  void _whack(int i) {
    final t = _holes[i];
    // t.hit blocks double-taps on a target that's already showing its hit sprite.
    if (t == null || t.hit || _phase != _Phase.playing) return;

    final good = t.kind == _Kind.avatar;
    setState(() {
      t.hit = true;
      t.expiresAt = DateTime.now().add(
        const Duration(milliseconds: _hitLingerMs),
      );
      _score = good ? _score + 1 : max(0, _score - _enemyPenalty);
    });
    _audio.playSfx(good: good);
    good ? HapticFeedback.lightImpact() : HapticFeedback.heavyImpact();
  }

  int get _secondsLeft {
    if (_phase != _Phase.playing) {
      return _phase == _Phase.ready ? _totalSeconds : 0;
    }
    return (_endsAt.difference(DateTime.now()).inMilliseconds / 1000)
        .ceil()
        .clamp(0, _totalSeconds);
  }


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Whack-a-Debt'),
        actions: [
          IconButton(
            icon: Icon(
              _audio.muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
            ),
            onPressed: _toggleMute,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GameStat(label: 'Time', value: '$_secondsLeft s'),
                      GameStat(label: 'Score', value: '$_score'),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    // The grid is a square sized by the SMALLER of the
                    // available width/height, so all 3x3 holes always fit
                    // on one screen (phones, foldables, tablets, landscape).
                    child: LayoutBuilder(
                      builder: (context, box) {
                        final side = min(
                          min(box.maxWidth, box.maxHeight),
                          _maxGridSide,
                        );
                        return Align(
                          alignment: const Alignment(0, -0.3),
                          child: SizedBox(
                            width: side,
                            height: side,
                            child: GridView.count(
                              crossAxisCount: 3,
                              padding: EdgeInsets.zero,
                              mainAxisSpacing: _gridSpacing,
                              crossAxisSpacing: _gridSpacing,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                for (var i = 0; i < _holeCount; i++)
                                  _hole(i, colors),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Tap your friends. Avoid the rhinos (-$_enemyPenalty)!',
                    style: TextStyle(color: colors.textSecondary, fontSize: 12),
                  ),
                ),
              ],
            ),
            if (_phase != _Phase.playing) _overlay(),
          ],
        ),
      ),
    );
  }

  Widget _targetImage(_Target t, double size) {
    final diameter = size * 0.72;

    if (t.kind == _Kind.enemy) {
      return CircleSprite(
        assetPath: t.hit ? GameAssets.rhinoHit : GameAssets.rhino,
        fallbackPath: GameAssets.rhino,
        diameter: diameter,
      );
    }

    final option = avatarById(t.avatarId);
    return CircleSprite(
      // null (unknown/missing avatar) -> generic person icon
      assetPath: option == null
          ? null
          : (t.hit ? GameAssets.hitSprite(option.id) : option.assetPath),
      fallbackPath: option?.assetPath,
      diameter: diameter,
    );
  }

  Widget _hole(int i, AppColorsExt colors) {
    final t = _holes[i];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _whack(i),
      child: LayoutBuilder(
        builder: (context, box) {
          final size = min(box.maxWidth, box.maxHeight);
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size * 0.9,
                height: size * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary.withValues(alpha: 0.12),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.25),
                    width: 2,
                  ),
                ),
              ),
              if (t != null)
                TweenAnimationBuilder<double>(
                  key: ObjectKey(t),
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 120),
                  builder: (_, v, child) =>
                      Transform.scale(scale: v, child: child),
                  child: _targetImage(t, size),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _overlay() {
    return GameOverlay(
      phaseKey: _phase,
      maxWidth: _phase == _Phase.done ? _resultMaxWidth : _overlayMaxWidth,
      child: switch (_phase) {
        _Phase.ready => ReadyCard(
            totalSeconds: _totalSeconds,
            sampleAvatarPath: widget.avatarIds.isNotEmpty
                ? avatarById(widget.avatarIds.first)?.assetPath
                : null,
            onStart: _start,
          ),
        _Phase.tallying => const TallyCard(
            duration: Duration(milliseconds: _tallyMs),
          ),
        _ => ResultCard(
            score: _score,
            onPlayAgain: _start,
            onDone: () => Navigator.of(context).pop(_score),
          ),
      },
    );
  }
}