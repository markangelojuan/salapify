import 'package:salapify/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:salapify/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/presentation/screens/category_form_screen.dart';
import 'package:salapify/features/settings/presentation/screens/account_screen.dart';
import 'package:salapify/features/settings/presentation/screens/settings_screen.dart';
import 'package:salapify/features/settings/presentation/screens/help_screen.dart';
import 'package:salapify/features/dashboard/presentation/screens/home_screen.dart';
import 'package:salapify/features/transaction/domain/entities/income_source.dart';
import 'package:salapify/features/transaction/presentation/screens/expense_form_screen.dart';
import 'package:salapify/features/transaction/presentation/screens/income_form_screen.dart';
import 'package:salapify/router/go_router_refresh_stream.dart';
import 'package:salapify/features/authentication/presentation/controllers/guest_controller.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes.g.dart';

enum AppRoutes {
  home, signIn, signUp, account, settings, help, categoryForm, expenseForm, incomeForm
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: "/home",
    debugLogDiagnostics: true,
    redirect: (ctx, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final isGuest = ref.watch(guestModeProvider);
      final loc = state.matchedLocation;

      if ((isLoggedIn || isGuest) && (loc == "/sign-in" || loc == "/sign-up")) {
        return "/home";
      } else if (!isLoggedIn && !isGuest && loc.startsWith("/home")) {
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
      GoRoute(
        path: "/account",
        name: AppRoutes.account.name,
        builder: (ctx, state) => const AccountScreen(),
      ),
      GoRoute(
        path: "/settings",
        name: AppRoutes.settings.name,
        builder: (ctx, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: "/help",
        name: AppRoutes.help.name,
        builder: (ctx, state) => const HelpScreen(),
      ),
      GoRoute(
        path: "/category-form",
        name: AppRoutes.categoryForm.name,
        builder: (ctx, state) {
          final existingCategory = state.extra as BudgetCategory?;
          return CategoryFormScreen(existingCategory: existingCategory);
        },
      ),
            GoRoute(
        path: "/expense-form",
        name: AppRoutes.expenseForm.name,
        builder: (ctx, state) {
          final existingTransaction = state.extra as TransactionEntry?;
          return ExpenseFormScreen(existingTransaction: existingTransaction);
        },
      ),
      GoRoute(
        path: "/income-form",
        name: AppRoutes.incomeForm.name,
        builder: (ctx, state) {
          final existingSource = state.extra as IncomeSource?;
          return IncomeFormScreen(existingSource: existingSource);
        },
      ),
    ],
  );
}