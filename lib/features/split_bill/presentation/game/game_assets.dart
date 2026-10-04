/// Central place for every asset path used by the Whack-a-Debt game.
abstract final class GameAssets {
  static const rhino = 'assets/images/game/enemy_rhino.png';
  static const rhinoHit = 'assets/images/game/enemy_rhino_hit.png';

  /// Hit sprites follow the `<avatar id>_hit.png` naming convention.
  static String hitSprite(String avatarId) =>
      'assets/images/game/${avatarId}_hit.png';
}

/// AssetSource paths are relative to the assets/ folder.
abstract final class GameSounds {
  static const music = 'sounds/game/suspense_music.wav';
  static const goodSfx = 'sounds/game/successful_whack.wav';
  static const badSfx = 'sounds/game/failed_whack.wav';
  static const result = 'sounds/game/karaoke_score.wav';
}