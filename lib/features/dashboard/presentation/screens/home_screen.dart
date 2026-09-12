import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/layout/app_drawer.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/notification/presentation/screens/notification_screen.dart';
import 'package:salapify/features/budget/presentation/screens/budget_screen.dart';
import 'package:salapify/features/split_bill/presentation/screens/split_bills_screen.dart';
import 'package:salapify/features/transaction/presentation/controllers/transaction_tab_state.dart';
import 'package:salapify/features/transaction/presentation/screens/transaction_screen.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/notification/data/providers/notification_providers.dart';
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

  VoidCallback? _fabActionForIndex(int index) {
    switch (index) {
      case 0:
        return () => context.pushNamed(AppRoutes.categoryForm.name);
      case 1:
        final activeTab = ref.watch(transactionTabStateProvider);
        return activeTab == TransactionTab.expenses
            ? () => context.pushNamed(AppRoutes.expenseForm.name)
            : () => context.pushNamed(AppRoutes.incomeForm.name);
      case 2:
        return () => context.pushNamed(AppRoutes.groupForm.name);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      drawer: const AppDrawer(),
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        fabOnPressed: _fabActionForIndex(_currentIndex),
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? fabOnPressed;

  const _FloatingNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.fabOnPressed,
  });

  static const double _pillHeight = 64;
  static const double _fabSize = 56;
  static const double _fabPopOut = 22; // how far the FAB pokes above the pill

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: SizedBox(
          height: _pillHeight + _fabPopOut,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // The pill itself, pinned to the bottom of the stack
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _pillHeight,
                child: _Pill(
                  currentIndex: currentIndex,
                  onTap: onTap,
                  reserveCenterGap: fabOnPressed != null,
                ),
              ),
              Positioned(
                bottom: _pillHeight - _fabSize / 2.2,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, anim) => ScaleTransition(
                    scale: anim,
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: fabOnPressed == null
                      ? const SizedBox.shrink(key: ValueKey('no_fab'))
                      : _PopOutFab(
                          key: const ValueKey('active_fab'),
                          size: _fabSize,
                          onPressed: fabOnPressed!,
                        ),
                ),
              ),
            ],
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

  const _Pill({
    required this.currentIndex,
    required this.onTap,
    required this.reserveCenterGap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadSplitCount = ref.watch(totalUnreadSplitCountProvider);
    final unreadNotifCount = ref.watch(unreadNotificationCountProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.textPrimary.withValues(alpha: 0.95),
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
            indicatorColor: AppColors.primary.withValues(alpha: 0.25),
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
              const NavigationDestination(
                icon: Icon(Icons.payments_outlined),
                selectedIcon: Icon(Icons.payments_rounded),
                label: 'Transactions',
              ),
              NavigationDestination(
                icon: NavBadge(
                  count: unreadSplitCount,
                  child: const Icon(Icons.receipt_long_outlined),
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
}

class _PopOutFab extends StatelessWidget {
  final double size;
  final VoidCallback onPressed;

  const _PopOutFab({super.key, required this.size, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 4,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}