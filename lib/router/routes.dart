import 'package:salapify/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:salapify/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:salapify/features/authentication/data/auth_repository.dart';
import 'package:salapify/core/screens/home_screen.dart';
import 'package:salapify/router/go_router_refresh_stream.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes.g.dart';

enum AppRoutes {
  home, signIn, signUp
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: "/home",
    debugLogDiagnostics: true,
    redirect: (ctx, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final loc = state.matchedLocation;

      if (isLoggedIn && (loc == "/sign-in" || loc == "/sign-up")) {
        return "/home";
      } else if (!isLoggedIn && loc.startsWith("/home")) {
        return "/sign-in";
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: "/home",
        name: AppRoutes.home.name,
        builder: (ctx, state) => const HomeScreen(),
      ),
      GoRoute(
        path: "/sign-in",
        name: AppRoutes.signIn.name,
        builder: (ctx, state) => const SignInScreen(),
      ),
      GoRoute(
        path: "/sign-up",
        name: AppRoutes.signUp.name,
        builder: (ctx, state) => const SignUpScreen(),
      ),
    ],
  );
}