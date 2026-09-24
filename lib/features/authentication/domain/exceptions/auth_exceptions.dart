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

class WrongPasswordException implements Exception {
  const WrongPasswordException();
  @override
  String toString() => "That password doesn't look right";
}

class ReauthCancelledException implements Exception {
  const ReauthCancelledException();
  @override
  String toString() => 'Confirmation was cancelled';
}

class AccountDisabledException implements Exception {
  const AccountDisabledException();
  @override
  String toString() => 'This account has been disabled';
}