class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.username,
    this.avatarId,
    this.preferencesCompleted = true,
    this.emailVerified = false,
    this.isDisabled = false,
  });
  final String uid;
  final String? email;
  final String? username;
  final String? avatarId;
  final bool preferencesCompleted;
  final bool emailVerified;
  final bool isDisabled;
}