import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:salapify/core/layout/app_drawer.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/shell/presentation/widgets/app_showcase.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/presentation/controllers/app_user_controller.dart';
import 'package:salapify/features/authentication/presentation/controllers/guest_controller.dart';
import 'package:salapify/features/budget/data/repositories/budget_repository.dart';
import 'package:salapify/features/budget/domain/entities/budget_limits.dart';
import 'package:salapify/features/notification/presentation/screens/notification_screen.dart';
import 'package:salapify/features/budget/presentation/screens/budget_screen.dart';
import 'package:salapify/features/premium/data/repositories/entitlement_repository.dart';
import 'package:salapify/features/premium/presentation/widgets/premium_upsell_sheet.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill_limits.dart';
import 'package:salapify/features/split_bill/presentation/screens/split_bills_screen.dart';
import 'package:salapify/features/transaction/presentation/controllers/transaction_tab_state.dart';
import 'package:salapify/features/transaction/presentation/screens/transaction_screen.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/notification/data/providers/notification_providers.dart';
import 'package:salapify/features/premium/data/services/purchase_service.dart';
import 'package:salapify/core/layout/breakpoints.dart';
import 'package:salapify/core/widgets/nav_badge.dart';

import 'package:salapify/router/routes.dart';

final homeTabIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  // Guards the FAB's async pre-checks (premium/limit lookups) against
  // double-taps and gives visual feedback instead of appearing to do
  // nothing while offline requests are in flight.
  bool _isFabBusy = false;

  // Showcase keys
  final _fabKey = GlobalKey();
  final _txKey = GlobalKey();
  final _splitKey = GlobalKey();
  final _menuKey = GlobalKey();

  static const List<Widget> _screens = [
    BudgetScreen(),
    TransactionScreen(),
    SplitBillsScreen(),
    NotificationScreen(),
  ];

  static const List<String> _titles = [
    'Budget',
    'Transactions',
    'Split Bill',
    'Notifications',
  ];

  @override
  void initState() {
    super.initState();
    ShowcaseView.register();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartTour());
  }

  @override
  void dispose() {
    ShowcaseView.get().unregister();
    super.dispose();
  }

  Future<void> _maybeStartTour() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('seen_home_tour') ?? false) return;
    await Future.delayed(
      const Duration(milliseconds: 600),
    ); // let FAB animate in
    if (!mounted) return;

    // Router may still redirect (sign-in / avatar / preferences) — only
    // start once the user is actually settled on Home.
    final isGuest = ref.read(guestModeProvider);
    var ready = isGuest;

    if (!isGuest) {
      if (ref.read(currentUserProvider) == null) return;
      try {
        final user = await ref
            .read(currentAppUserProvider.future)
            .timeout(const Duration(seconds: 5));
        if (!mounted) return;
        ready = user?.avatarId != null && user?.preferencesCompleted != false;
      } catch (_) {
        return;
      }
    }

    if (!ready || !(ModalRoute.of(context)?.isCurrent ?? false)) return;

    await prefs.setBool('seen_home_tour', true);
    if (!mounted) return;
    ShowcaseView.get().startShowCase([_fabKey, _txKey, _splitKey, _menuKey]);
  }

  VoidCallback? _fabActionForIndex(int index) {
    if (_isFabBusy) return null;

    switch (index) {
      case 0:
        return () => _handleAddCategory(context, ref);
      case 1:
        final activeTab = ref.watch(transactionTabStateProvider);
        return activeTab == TransactionTab.expenses
            ? () => context.pushNamed(AppRoutes.expenseForm.name)
            : () => context.pushNamed(AppRoutes.incomeForm.name);
      case 2:
        if (ref.watch(currentUserProvider) == null) return null;
        return () => _handleCreateGroup(context, ref);
      default:
        return null;
    }
  }

  Future<void> _handleAddCategory(BuildContext context, WidgetRef ref) async {
    setState(() => _isFabBusy = true);
    try {
      final isPremium =
          (await ref.read(entitlementRepositoryProvider).watch().first)
              .isPremium;
      final limit = BudgetLimits.maxActiveCategoriesFor(isPremium: isPremium);
      final currentCount = await ref
          .read(budgetRepositoryProvider)
          .countActive();

      if (currentCount >= limit) {
        if (!context.mounted) return;
        if (isPremium) {
          CommonSnackbar.showWarning(
            context,
            'You\'ve reached the limit of '
            '${BudgetLimits.premiumMaxActiveCategories} active categories. '
            'Delete one to add a new one.',
          );
        } else {
          await _showPremiumUpsell(PremiumLimit.categories);
        }
        return;
      }
      if (context.mounted) {
        context.pushNamed(AppRoutes.categoryForm.name);
      }
    } catch (e) {
      if (context.mounted) CommonSnackbar.showError(context, e);
    } finally {
      if (mounted) setState(() => _isFabBusy = false);
    }
  }

  Future<void> _handleCreateGroup(BuildContext context, WidgetRef ref) async {
    final currentUid = ref.read(currentUserProvider)?.uid;
    if (currentUid == null) return;

    setState(() => _isFabBusy = true);
    try {
      final isPremium =
          (await ref.read(entitlementRepositoryProvider).watch().first)
              .isPremium;

      final limit = SplitBillLimits.maxActiveGroupsFor(isPremium: isPremium);
      final ownedCount = await ref
          .read(splitBillRepositoryProvider)
          .countOwnedGroupsForUser(currentUid);

      if (ownedCount >= limit) {
        if (!context.mounted) return;
        if (isPremium) {
          CommonSnackbar.showWarning(
            context,
            'You\'ve reached the limit of '
            '${SplitBillLimits.premiumMaxActiveGroups} groups. '
            'Delete a group to create a new one.',
          );
        } else {
          await _showPremiumUpsell(PremiumLimit.groups);
        }
        return;
      }
      if (context.mounted) {
        context.pushNamed(AppRoutes.groupForm.name);
      }
    } catch (e) {
      if (context.mounted) CommonSnackbar.showError(context, e);
    } finally {
      if (mounted) setState(() => _isFabBusy = false);
    }
  }

  Future<void> _showPremiumUpsell(PremiumLimit limit) async {
    final purchaseService = ref.read(purchaseServiceProvider);
    final price = await purchaseService.premiumPriceLabel() ?? '₱59';
    if (!context.mounted) return;

    await showPremiumUpsellSheet(
      context,
      limit: limit,
      priceLabel: price,
      onUnlock: () => purchaseService.buyPremium(),
      onRestore: () => purchaseService.restorePurchases(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        leading: Builder(
          builder: (ctx) => AppShowcase(
            showcaseKey: _menuKey,
            title: 'More Options',
            description:
                'Manage your account, budget period,\nother settings, and get help.',
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        fabOnPressed: _fabActionForIndex(_currentIndex),
        fabLoading: _isFabBusy,
        fabKey: _fabKey,
        txKey: _txKey,
        splitKey: _splitKey,
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? fabOnPressed;
  final bool fabLoading;
  final GlobalKey fabKey;
  final GlobalKey txKey;
  final GlobalKey splitKey;

  const _FloatingNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.fabOnPressed,
    required this.fabKey,
    required this.txKey,
    required this.splitKey,
    this.fabLoading = false,
  });

  static const double _pillHeight = 64;
  static const double _fabSize = 50;
  static const double _fabPopOut = 22;
  static const double _maxWidthOnWide = 480;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: SizedBox(
          height: _pillHeight + _fabPopOut, // fixes height first
          child: Center(
            // now safe — parent height is already fixed
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: context.isTabletOrWider
                    ? _maxWidthOnWide
                    : double.infinity,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: _pillHeight,
                    child: _Pill(
                      currentIndex: currentIndex,
                      onTap: onTap,
                      reserveCenterGap: fabOnPressed != null || fabLoading,
                      txKey: txKey,
                      splitKey: splitKey,
                    ),
                  ),
                  Positioned(
                    bottom: _pillHeight - _fabSize / 2.2,
                    // Showcase wraps the whole switcher (not the FAB inside
                    // it) so two children mid-transition never share the key.
                    child: AppShowcase(
                      showcaseKey: fabKey,
                      circle: true,
                      title: 'Quick Add',
                      description:
                          'Tap + to quickly add a category,\ntransaction, or split-bill group.',
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        transitionBuilder: (child, anim) => ScaleTransition(
                          scale: anim,
                          child: FadeTransition(opacity: anim, child: child),
                        ),
                        child: (fabOnPressed == null && !fabLoading)
                            ? const SizedBox.shrink(key: ValueKey('no_fab'))
                            : _PopOutFab(
                                key: ValueKey(
                                  fabLoading ? 'busy_fab' : 'active_fab',
                                ),
                                size: _fabSize,
                                onPressed: fabOnPressed,
                                loading: fabLoading,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool reserveCenterGap;
  final GlobalKey txKey;
  final GlobalKey splitKey;

  const _Pill({
    required this.currentIndex,
    required this.onTap,
    required this.reserveCenterGap,
    required this.txKey,
    required this.splitKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final unreadSplitCount = ref.watch(totalUnreadSplitCountProvider);
    final unreadNotifCount = ref.watch(unreadNotificationCountProvider);
    final isGuest = ref.watch(currentUserProvider) == null;

    return Container(
      decoration: BoxDecoration(
        color: _pillBackground.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            indicatorColor: colors.primary.withValues(alpha: 0.25),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.white60,
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return IconThemeData(
                color: selected ? Colors.white : Colors.white60,
                size: selected ? 24 : 22,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onTap,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet_rounded),
                label: 'Budget',
              ),
              NavigationDestination(
                icon: AppShowcase(
                  showcaseKey: txKey,
                  title: 'Track Your Expenses',
                  description:
                      'Track your income and expenses.\nUse + to add a transaction.',
                  child: const Icon(Icons.payments_outlined),
                ),
                selectedIcon: const Icon(Icons.payments_rounded),
                label: 'Transactions',
              ),
              NavigationDestination(
                icon: AppShowcase(
                  showcaseKey: splitKey,
                  title: 'Split Bills Easily',
                  description: isGuest
                      ? 'Split expenses with friends.\nSign in to unlock this feature.'
                      : "Create a group, add bills,\nand chat with everyone.",
                  child: NavBadge(
                    count: unreadSplitCount,
                    child: const Icon(Icons.receipt_long_outlined),
                  ),
                ),
                selectedIcon: const Icon(Icons.receipt_long_rounded),
                label: 'Split Bill',
              ),
              NavigationDestination(
                icon: NavBadge(
                  count: unreadNotifCount,
                  child: const Icon(Icons.notifications_outlined),
                ),
                selectedIcon: const Icon(Icons.notifications_rounded),
                label: 'Notifications',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _pillBackground = Color(0xFF2E302E);
}

class _PopOutFab extends StatelessWidget {
  final double size;
  final VoidCallback? onPressed;
  final bool loading;

  const _PopOutFab({
    super.key,
    required this.size,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.primary,
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: loading ? null : onPressed,
          child: Center(
            child: loading
                ? SizedBox(
                    width: size * 0.4,
                    height: size * 0.4,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
