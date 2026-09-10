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
import 'package:salapify/features/authentication/presentation/controllers/guest_controller.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';
import 'package:salapify/features/split_bill/presentation/screens/group_form_screen.dart';
import 'package:salapify/features/split_bill/presentation/screens/split_group_detail_screen.dart';
import 'package:salapify/features/split_bill/presentation/screens/bill_form_screen.dart';
import 'package:salapify/features/authentication/presentation/controllers/app_user_controller.dart';
import 'package:salapify/features/authentication/presentation/screens/avatar_picker_screen.dart';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes.g.dart';

enum AppRoutes {
  home,
  signIn,
  signUp,
  avatarPicker,
  account,
  settings,
  help,
  categoryForm,
  expenseForm,
  incomeForm,
  groupForm,
  splitGroupDetail,
  billForm,
}

/// Notifies GoRouter's `redirect` to re-run whenever auth state, guest mode,
/// or the current user's profile (e.g. avatarId) changes — WITHOUT rebuilding
/// the GoRouter instance itself (that's what was resetting screen state).
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authStateChangesProvider, (_, __) => notifyListeners());
    ref.listen(currentAppUserProvider, (_, __) => notifyListeners());
    ref.listen(guestModeProvider, (_, __) => notifyListeners());
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
      final isLoggedIn = ref.read(authRepositoryProvider).currentUser != null;
      final isGuest = ref.read(guestModeProvider);
      final loc = state.matchedLocation;

      if (!isLoggedIn && !isGuest) {
        return (loc.startsWith("/home") || loc == "/avatar-picker")
            ? "/sign-in"
            : null;
      }

      if (isGuest && !isLoggedIn) {
        return (loc == "/sign-in" || loc == "/sign-up") ? "/home" : null;
      }

      final appUserAsync = ref.read(currentAppUserProvider);
      if (appUserAsync.isLoading || appUserAsync.hasError) {
        return null;
      }

      final needsAvatar = appUserAsync.value?.avatarId == null;

      if (needsAvatar) {
        return loc == "/avatar-picker" ? null : "/avatar-picker";
      }

      // Only block sign-in/sign-up once logged in — /avatar-picker stays
      // freely revisitable (e.g. "Change" button on Account screen).
      if (loc == "/sign-in" || loc == "/sign-up") {
        return "/home";
      }
      return null;
    },
    refreshListenable: refreshNotifier,
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
        path: "/avatar-picker",
        name: AppRoutes.avatarPicker.name,
        builder: (ctx, state) => const AvatarPickerScreen(),
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
      GoRoute(
        path: "/group-form",
        name: AppRoutes.groupForm.name,
        builder: (ctx, state) {
          final existingGroup = state.extra as SplitGroup?;
          return GroupFormScreen(existingGroup: existingGroup);
        },
      ),
      GoRoute(
        path: "/split-group-detail/:groupId",
        name: AppRoutes.splitGroupDetail.name,
        builder: (ctx, state) {
          final groupId = state.pathParameters['groupId']!;
          return SplitGroupDetailScreen(groupId: groupId);
        },
      ),
      GoRoute(
        path: "/bill-form",
        name: AppRoutes.billForm.name,
        builder: (ctx, state) {
          final args = state.extra as BillFormArgs;
          return BillFormScreen(
            group: args.group,
            existingBill: args.existingBill,
          );
        },
      ),
    ],
  );
}
