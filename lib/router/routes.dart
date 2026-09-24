import 'package:salapify/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:salapify/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/presentation/screens/category_form_screen.dart';
import 'package:salapify/features/authentication/presentation/screens/account_screen.dart';
import 'package:salapify/features/settings/presentation/screens/settings_screen.dart';
import 'package:salapify/features/settings/presentation/screens/preferences_setup_screen.dart';
import 'package:salapify/features/settings/presentation/screens/help_screen.dart';
import 'package:salapify/features/shell/presentation/screens/home_screen.dart';
import 'package:salapify/features/transaction/domain/entities/income_source.dart';
import 'package:salapify/features/transaction/presentation/screens/expense_form_screen.dart';
import 'package:salapify/features/transaction/presentation/screens/income_form_screen.dart';
import 'package:salapify/features/authentication/presentation/controllers/guest_controller.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';
import 'package:salapify/features/split_bill/presentation/screens/group_form_screen.dart';
import 'package:salapify/features/split_bill/presentation/screens/split_group_detail_screen.dart';
import 'package:salapify/features/split_bill/presentation/screens/bill_form_screen.dart';
import 'package:salapify/features/authentication/presentation/controllers/app_user_controller.dart';
import 'package:salapify/features/authentication/presentation/screens/avatar_picker_screen.dart';
import 'package:salapify/features/premium/presentation/screens/premium_screen.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salapify/features/authentication/presentation/screens/verify_email_screen.dart';
import 'package:salapify/features/authentication/presentation/controllers/auth_controller.dart';

part 'routes.g.dart';

Widget _withGradientBackground(Widget child) {
  return Builder(
    builder: (context) {
      final colors = Theme.of(context).extension<AppColorsExt>()!;
      return DecoratedBox(
        decoration: BoxDecoration(gradient: colors.backgroundGradient),
        child: child,
      );
    },
  );
}

enum AppRoutes {
  home,
  signIn,
  signUp,
  verifyEmail,
  avatarPicker,
  preferencesSetup,
  account,
  settings,
  help,
  premium,
  categoryForm,
  expenseForm,
  incomeForm,
  groupForm,
  splitGroupDetail,
  billForm,
}

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authStateChangesProvider, (_, __) => notifyListeners());
    ref.listen(currentAppUserProvider, (_, __) => notifyListeners());
    ref.listen(guestModeProvider, (_, __) => notifyListeners());
    ref.listen(authControllerProvider, (_, __) => notifyListeners());
  }
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: "/home",
    debugLogDiagnostics: true,
    redirect: (ctx, state) {
      final authControllerState = ref.read(authControllerProvider);
      if (authControllerState.isLoading) return null;
      final authAsync = ref.read(authStateChangesProvider);
      if (authAsync.isLoading) return null;
      final authRepository = ref.read(authRepositoryProvider);
      final isLoggedIn = authAsync.value != null;
      final isGuest = ref.read(guestModeProvider);
      final loc = state.matchedLocation;

      if (!isLoggedIn && !isGuest) {
        return (loc.startsWith("/home") ||
                loc == "/avatar-picker" ||
                loc == "/verify-email")
            ? "/sign-in"
            : null;
      }

      if (isGuest && !isLoggedIn) {
        return (loc == "/sign-in" || loc == "/sign-up") ? "/home" : null;
      }

      if (isLoggedIn && !authRepository.isEmailVerified) {
        return loc == "/verify-email" ? null : "/verify-email";
      }

      if (loc == "/verify-email") {
        return "/home";
      }

      final appUserAsync = ref.read(currentAppUserProvider);
      if (appUserAsync.isLoading || appUserAsync.hasError) {
        return null;
      }

      final needsAvatar = appUserAsync.value?.avatarId == null;

      if (needsAvatar) {
        return loc == "/avatar-picker" ? null : "/avatar-picker";
      }

      final needsPrefs = appUserAsync.value?.preferencesCompleted == false;
      if (needsPrefs) {
        return loc == "/preferences-setup" ? null : "/preferences-setup";
      }

      if (loc == "/sign-in" ||
          loc == "/sign-up" ||
          loc == "/preferences-setup") {
        return "/home";
      }
      return null;
    },
    refreshListenable: refreshNotifier,
    routes: [
      GoRoute(
        path: "/home",
        name: AppRoutes.home.name,
        builder: (ctx, state) => _withGradientBackground(const HomeScreen()),
      ),
      GoRoute(
        path: "/sign-in",
        name: AppRoutes.signIn.name,
        builder: (ctx, state) => _withGradientBackground(const SignInScreen()),
      ),
      GoRoute(
        path: "/sign-up",
        name: AppRoutes.signUp.name,
        builder: (ctx, state) => _withGradientBackground(const SignUpScreen()),
      ),
      GoRoute(
        path: "/verify-email",
        name: AppRoutes.verifyEmail.name,
        builder: (ctx, state) =>
            _withGradientBackground(const VerifyEmailScreen()),
      ),
      GoRoute(
        path: "/avatar-picker",
        name: AppRoutes.avatarPicker.name,
        builder: (ctx, state) =>
            _withGradientBackground(const AvatarPickerScreen()),
      ),
      GoRoute(
        path: "/preferences-setup",
        name: AppRoutes.preferencesSetup.name,
        builder: (ctx, state) =>
            _withGradientBackground(const PreferencesSetupScreen()),
      ),
      GoRoute(
        path: "/premium",
        name: AppRoutes.premium.name,
        builder: (ctx, state) => _withGradientBackground(const PremiumScreen()),
      ),
      GoRoute(
        path: "/account",
        name: AppRoutes.account.name,
        builder: (ctx, state) => _withGradientBackground(const AccountScreen()),
      ),
      GoRoute(
        path: "/settings",
        name: AppRoutes.settings.name,
        builder: (ctx, state) =>
            _withGradientBackground(const SettingsScreen()),
      ),
      GoRoute(
        path: "/help",
        name: AppRoutes.help.name,
        builder: (ctx, state) => _withGradientBackground(const HelpScreen()),
      ),
      GoRoute(
        path: "/category-form",
        name: AppRoutes.categoryForm.name,
        builder: (ctx, state) {
          final existingCategory = state.extra as BudgetCategory?;
          return _withGradientBackground(
            CategoryFormScreen(existingCategory: existingCategory),
          );
        },
      ),
      GoRoute(
        path: "/expense-form",
        name: AppRoutes.expenseForm.name,
        builder: (ctx, state) {
          final existingTransaction = state.extra as TransactionEntry?;
          return _withGradientBackground(
            ExpenseFormScreen(existingTransaction: existingTransaction),
          );
        },
      ),
      GoRoute(
        path: "/income-form",
        name: AppRoutes.incomeForm.name,
        builder: (ctx, state) {
          final existingSource = state.extra as IncomeSource?;
          return _withGradientBackground(
            IncomeFormScreen(existingSource: existingSource),
          );
        },
      ),
      GoRoute(
        path: "/group-form",
        name: AppRoutes.groupForm.name,
        builder: (ctx, state) {
          final existingGroup = state.extra as SplitGroup?;
          return _withGradientBackground(
            GroupFormScreen(existingGroup: existingGroup),
          );
        },
      ),
      GoRoute(
        path: "/split-group-detail/:groupId",
        name: AppRoutes.splitGroupDetail.name,
        builder: (ctx, state) {
          final groupId = state.pathParameters['groupId']!;
          return _withGradientBackground(
            SplitGroupDetailScreen(groupId: groupId),
          );
        },
      ),
      GoRoute(
        path: "/bill-form",
        name: AppRoutes.billForm.name,
        builder: (ctx, state) {
          final args = state.extra as BillFormArgs;
          return _withGradientBackground(
            BillFormScreen(group: args.group, existingBill: args.existingBill),
          );
        },
      ),
    ],
  );
}
