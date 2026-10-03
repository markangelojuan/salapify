class AvatarOption {
  const AvatarOption({
    required this.id,
    required this.assetPath,
    required this.name,
    this.isHidden = false,
    this.isPremiumOnly = false,
  });

  final String id;
  final String assetPath;
  final String name;

  /// Never shown in the picker and cannot be selected through the app.
  final bool isHidden;

  final bool isPremiumOnly;
}

const List<AvatarOption> kAvatarOptions = [
  AvatarOption(
    id: 'luxurious_dog',
    assetPath: 'assets/images/luxurious_dog.png',
    name: 'Luxurious Dog',
  ),
  AvatarOption(
    id: 'savvy_monkey',
    assetPath: 'assets/images/savvy_monkey.png',
    name: 'Savvy Monkey',
  ),
  AvatarOption(
    id: 'greedy_cat',
    assetPath: 'assets/images/greedy_cat.png',
    name: 'Greedy Cat',
  ),
  AvatarOption(
    id: 'thrifty_pig',
    assetPath: 'assets/images/thrifty_pig.png',
    name: 'Thrifty Pig',
  ),
  AvatarOption(
    id: 'stingy_turtle',
    assetPath: 'assets/images/stingy_turtle.png',
    name: 'Stingy Turtle',
  ),
  AvatarOption(
    id: 'covetous_snake',
    assetPath: 'assets/images/covetous_snake.png',
    name: 'Covetous Snake',
    isPremiumOnly: true,
  ),

  AvatarOption(
    id: 'prosperous_panda',
    assetPath: 'assets/images/prosperous_panda.png',
    name: 'Prosperous Panda',
    isPremiumOnly: true,
  ),
  AvatarOption(
    id: 'frugal_shark',
    assetPath: 'assets/images/frugal_shark.png',
    name: 'Frugal Shark',
    isPremiumOnly: true,
  ),
  AvatarOption(
    id: 'opulent_walrus',
    assetPath: 'assets/images/opulent_walrus.png',
    name: 'Opulent Walrus',
    isPremiumOnly: true,
  ),
  AvatarOption(
    id: 'broke_eagle',
    assetPath: 'assets/images/broke_eagle.png',
    name: 'Broke Eagle',
    isHidden: true,
  ),
];

/// What the picker screen shows: everything except hidden avatars.
final List<AvatarOption> kSelectableAvatars = List.unmodifiable(
  kAvatarOptions.where((a) => !a.isHidden),
);

AvatarOption? avatarById(String? id) {
  if (id == null) return null;
  for (final a in kAvatarOptions) {
    if (a.id == id) return a;
  }
  return null;
}
