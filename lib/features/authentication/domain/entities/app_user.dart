class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.username,
  });

  final String uid;
  final String? email;
  final String? username;
}