class AvatarOption {
  const AvatarOption({
    required this.id,
    required this.assetPath,
    required this.name,
    this.isHidden = false,
  });

  final String id;
  final String assetPath;
  final String name;

  /// Never shown in the picker and cannot be selected through the app.
  final bool isHidden;
}

const List<AvatarOption> kAvatarOptions = [
  AvatarOption(id: 'covetous_snake', assetPath: 'assets/images/covetous_snake.png', name: 'Covetous Snake'),
  AvatarOption(id: 'frugal_zebra', assetPath: 'assets/images/frugal_zebra.png', name: 'Frugal Zebra'),
  AvatarOption(id: 'greedy_cat', assetPath: 'assets/images/greedy_cat.png', name: 'Greedy Cat'),
  AvatarOption(id: 'lavish_dog', assetPath: 'assets/images/lavish_dog.png', name: 'Lavish Dog'),
  AvatarOption(id: 'savvy_monkey', assetPath: 'assets/images/savvy_monkey.png', name: 'Savvy Monkey'),
  AvatarOption(id: 'stingy_turtle', assetPath: 'assets/images/stingy_turtle.png', name: 'Stingy Turtle'),
  AvatarOption(id: 'thrifty_pig', assetPath: 'assets/images/thrifty_pig.png', name: 'Thrifty Pig'),
  AvatarOption(id: 'lucrative_panda', assetPath: 'assets/images/lucrative_panda.png', name: 'Lucrative Panda'),
  AvatarOption(id: 'impecunious_eagle', assetPath: 'assets/images/impecunious_eagle.png', name: 'Impecunious Eagle', isHidden: true),
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