import 'package:salapify/features/authentication/domain/entities/avatar_option.dart';
import 'package:salapify/l10n/app_localizations.dart';

extension AvatarOptionText on AvatarOption {
  /// Localized display name, keyed by [id]. Falls back to the English
  /// [name] for any avatar added later without a translation yet.
  String localizedName(AppLocalizations l10n) => switch (id) {
    'luxurious_dog' => l10n.avatarLuxuriousDog,
    'savvy_monkey' => l10n.avatarSavvyMonkey,
    'greedy_cat' => l10n.avatarGreedyCat,
    'thrifty_pig' => l10n.avatarThriftyPig,
    'stingy_turtle' => l10n.avatarStingyTurtle,
    'covetous_snake' => l10n.avatarCovetousSnake,
    'prosperous_panda' => l10n.avatarProsperousPanda,
    'frugal_shark' => l10n.avatarFrugalShark,
    'opulent_walrus' => l10n.avatarOpulentWalrus,
    'broke_eagle' => l10n.avatarBrokeEagle,
    _ => name,
  };
}