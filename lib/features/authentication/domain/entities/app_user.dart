class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.username,
    this.avatarId,
    this.preferencesCompleted = true,
  });
  final String uid;
  final String? email;
  final String? username;
  final String? avatarId;
  final bool preferencesCompleted;
}
