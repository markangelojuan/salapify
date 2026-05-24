import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/features/notification/presentation/screens/notification_screen.dart';
import 'package:salapify/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:salapify/features/authentication/presentation/screens/account_screen.dart';
import 'package:salapify/features/budget/presentation/screens/budget_screen.dart';
import 'package:salapify/features/budget/presentation/screens/split_bills_screen.dart';
import 'package:salapify/features/budget/presentation/screens/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = currentIndex;
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          BudgetScreen(),
          TransactionScreen(),
          SplitBillsScreen(),
          NotificationScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            label: 'Transactions',
            activeIcon: Icon(Icons.payment),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            label: 'Split Bill',
            activeIcon: Icon(Icons.receipt),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
            activeIcon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Account',
            activeIcon: Icon(Icons.person),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        iconSize: 20.0,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
