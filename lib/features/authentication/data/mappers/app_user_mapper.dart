import 'package:firebase_auth/firebase_auth.dart';
import 'package:salapify/features/authentication/domain/entities/app_user.dart';

extension FirebaseUserMapper on User {
  AppUser toDomain() {
    return AppUser(
      uid: uid,
      email: email,
    );
  }
}