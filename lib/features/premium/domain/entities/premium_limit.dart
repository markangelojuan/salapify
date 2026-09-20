
enum PremiumLimit {
  categories("Your budget is growing! You've filled every free category."),
  groups('Look at you, being social! Your free group is all booked.'),
  bills('Your bills are multiplying! The free slots are all used up.');

  const PremiumLimit(this.message);

  final String message;
}