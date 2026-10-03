
enum PremiumLimit {
  categories("Your budget is growing! You've filled every free category."),
  groups('Your free group is all booked. Only one active at a time.'),
  bills('Your bills are multiplying! The free slots are all used up.');

  const PremiumLimit(this.message);

  final String message;
}