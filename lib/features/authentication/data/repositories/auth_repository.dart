import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/data/mappers/app_user_mapper.dart';
import 'package:salapify/features/authentication/domain/entities/app_user.dart';
import 'package:salapify/features/authentication/domain/exceptions/auth_exceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw const EmailAlreadyInUseException();
      }
      rethrow;
    }
  }

  AppUser? get currentUser {
    return _auth.currentUser?.toDomain();
  }

  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map((user) => user?.toDomain());
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> reloadCurrentUser() async {
    await _auth.currentUser?.reload();
  }

  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn.instance.authenticate();
    final idToken = googleUser.authentication.idToken;
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _auth.signInWithCredential(credential);
  }

  String? get currentUserProviderId {
    final providerData = _auth.currentUser?.providerData;
    if (providerData == null || providerData.isEmpty) return null;
    return providerData.first.providerId; // 'password' or 'google.com'
  }

  Future<void> reauthenticateWithPassword(String password) async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      throw StateError('No current user to reauthenticate');
    }
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  Future<void> reauthenticateWithGoogle() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No current user to reauthenticate');
    }
    final googleUser = await GoogleSignIn.instance.authenticate();
    final idToken = googleUser.authentication.idToken;
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    await user.reauthenticateWithCredential(credential);
  }

  Future<void> deleteCurrentUser() async {
    await _auth.currentUser?.delete();
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(FirebaseAuth.instance);
}

@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}

@Riverpod(keepAlive: true)
AppUser? currentUser(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.value;
}
