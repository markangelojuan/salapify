import 'package:flutter/material.dart';
import 'package:salapify/core/layout/app_drawer.dart';
import 'package:salapify/features/notification/presentation/screens/notification_screen.dart';
import 'package:salapify/features/budget/presentation/screens/budget_screen.dart';
import 'package:salapify/features/budget/presentation/screens/split_bills_screen.dart';
import 'package:salapify/features/budget/presentation/screens/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> _screens = const [
    BudgetScreen(),
    TransactionScreen(),
    SplitBillsScreen(),
    NotificationScreen(),
  ];

  static const _titles = ['Budget', 'Transactions', 'Split Bill', 'Notifications'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[currentIndex])),
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            activeIcon: Icon(Icons.payment),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            activeIcon: Icon(Icons.receipt),
            label: 'Split Bill',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
        iconSize: 20.0,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}