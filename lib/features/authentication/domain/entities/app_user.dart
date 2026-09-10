class AppUser {
  const AppUser({required this.uid, this.email, this.username, this.avatarId});
  final String uid;
  final String? email;
  final String? username;
  final String? avatarId;
}