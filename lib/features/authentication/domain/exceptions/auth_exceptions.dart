class UsernameTakenException implements Exception {
  const UsernameTakenException();
  @override
  String toString() => 'Username is already taken';
}

class EmailAlreadyInUseException implements Exception {
  const EmailAlreadyInUseException();
  @override
  String toString() => 'Email is already registered';
}