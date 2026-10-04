abstract final class GameAssets {
  static const rhino = 'assets/images/game/enemy_rhino.png';
  static const rhinoHit = 'assets/images/game/enemy_rhino_hit.png';

  /// Hit sprites follow the `<avatar id>_hit.png` naming convention.
  static String hitSprite(String avatarId) =>
      'assets/images/game/${avatarId}_hit.png';
}

/// AssetSource paths are relative to the assets/ folder.
abstract final class GameSounds {
  static const music = 'sounds/game/suspense_music.m4a';
  static const goodSfx = 'sounds/game/successful_whack.m4a';
  static const badSfx = 'sounds/game/failed_whack.m4a';
  static const result = 'sounds/game/karaoke_score.m4a';
}