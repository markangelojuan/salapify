import 'package:salapify/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:salapify/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:salapify/features/budget_management/presentation/screens/home_screen.dart';
import 'package:salapify/router/go_router_refresh_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes.g.dart';

enum AppRoutes {
  home, signIn, signUp
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

@riverpod
GoRouter goRouter(Ref ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return GoRouter(
    initialLocation: "/home",
    debugLogDiagnostics: true,
    redirect: (ctx, state) {
      final isLoggedIn = firebaseAuth.currentUser != null;

      if (isLoggedIn && (state.uri.toString() == "/sign-in" || state.uri.toString() == "/sign-up" )) {
        return "/home";
      } else if (!isLoggedIn && state.uri.toString() == "/home") {
        return "/sign-in";
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    routes: [
      GoRoute(path: "/home", name: AppRoutes.home.name, builder: (ctx, state) => const HomeScreen()),
      GoRoute(path: "/sign-in", name: AppRoutes.signIn.name, builder: (ctx, state) => const SignInScreen()),
      GoRoute(path: "/sign-up", name: AppRoutes.signUp.name, builder: (ctx, state) => const SignUpScreen()),
    ],
  );
}