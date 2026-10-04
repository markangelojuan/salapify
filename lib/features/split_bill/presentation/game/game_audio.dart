import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'game_assets.dart';

/// Owns every AudioPlayer used by the game so the screen only deals with
/// intent ("start the round", "play a good hit") and never with players.
class WhackAudio {
  WhackAudio();

  /// Whether sound is muted. Toggle through [setMuted] so players pause.
  bool muted = false;

  final _music = AudioPlayer();
  final _resultPlayer = AudioPlayer();

  // Preloaded players so rapid taps never cut each other off.
  final _goodPool = List.generate(6, (_) => AudioPlayer());
  final _badPool = List.generate(4, (_) => AudioPlayer());
  int _goodNext = 0;
  int _badNext = 0;

  Future<void> init() async {
    try {
      // Don't let SFX steal audio focus from the music or each other.
      await AudioPlayer.global.setAudioContext(
        AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers)
            .build(),
      );
    } catch (e) {
      debugPrint('Audio context error: $e');
    }

    try {
      await AudioCache.instance.loadAll([
        GameSounds.music,
        GameSounds.goodSfx,
        GameSounds.badSfx,
        GameSounds.result,
      ]);
      await _music.setReleaseMode(ReleaseMode.loop);
      await _music.setVolume(0.5);

      // Load each SFX into its player ONCE. Taps just replay it.
      for (final p in _goodPool) {
        await p.setReleaseMode(ReleaseMode.stop);
        await p.setSource(AssetSource(GameSounds.goodSfx));
      }
      for (final p in _badPool) {
        await p.setReleaseMode(ReleaseMode.stop);
        await p.setSource(AssetSource(GameSounds.badSfx));
      }
    } catch (e) {
      debugPrint('Audio init error: $e');
    }
  }

  void playSfx({required bool good}) {
    if (muted) return;
    final pool = good ? _goodPool : _badPool;
    final i = good ? _goodNext++ : _badNext++;
    final p = pool[i % pool.length];
    () async {
      try {
        await p.seek(Duration.zero);
        await p.resume();
      } catch (e) {
        debugPrint('SFX error: $e');
      }
    }();
  }

  /// Round begins: silence any leftover result jingle, start the music.
  void startMusic() {
    _resultPlayer.stop().catchError((_) {});
    if (!muted) {
      _music.play(AssetSource(GameSounds.music)).catchError((_) {});
    }
  }

  /// Round ends: stop the music and play the karaoke build-up.
  void startResult() {
    _music.stop().catchError((_) {});
    if (!muted) {
      _resultPlayer.play(AssetSource(GameSounds.result)).catchError((_) {});
    }
  }

  void pauseAll() {
    _music.pause().catchError((_) {});
    _resultPlayer.pause().catchError((_) {});
  }

  void resumeMusic() {
    if (muted) return;
    _music.resume().catchError((_) {});
  }

  void resumeResult() {
    if (muted) return;
    _resultPlayer.resume().catchError((_) {});
  }

  void setMuted(bool value) {
    muted = value;
    if (muted) pauseAll();
  }

  void dispose() {
    _music.dispose();
    _resultPlayer.dispose();
    for (final p in [..._goodPool, ..._badPool]) {
      p.dispose();
    }
  }
}