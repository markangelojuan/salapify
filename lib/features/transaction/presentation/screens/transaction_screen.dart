import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/transaction/domain/income_totals_calculator.dart';
import 'package:salapify/features/transaction/domain/transaction_totals_calculator.dart';
import 'package:salapify/features/transaction/presentation/controllers/income_source_controller.dart';
import 'package:salapify/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:salapify/features/transaction/presentation/controllers/transaction_tab_state.dart';
import 'package:salapify/features/transaction/presentation/widgets/cash_flow_summary_strip.dart';
import 'package:salapify/features/transaction/presentation/widgets/expenses_tab.dart';
import 'package:salapify/features/transaction/presentation/widgets/income_tab.dart';
import 'package:salapify/features/transaction/presentation/widgets/transaction_tab_bar.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    // Only report on settle, not on every frame of a swipe drag.
    if (_tabController.indexIsChanging) return;
    final tab = _tabController.index == 0
        ? TransactionTab.expenses
        : TransactionTab.income;
    ref.read(transactionTabStateProvider.notifier).set(tab);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final globalPeriod =
        ref.watch(budgetingPeriodSettingProvider).value ??
        BudgetingPeriod.monthly;
    final firstHalfEndDay =
        ref.watch(firstHalfEndDaySettingProvider).value ?? 15;

    final incomeSourcesAsync = ref.watch(incomeSourcesProvider);
    final transactionsAsync = ref.watch(transactionsProvider);

    final income = IncomeTotalsCalculator.totalRecurring(
      sources: incomeSourcesAsync.value ?? [],
      globalPeriod: globalPeriod,
      firstHalfEndDay: firstHalfEndDay,
    );
    final spent = TransactionTotalsCalculator.totalSpent(
      transactions: transactionsAsync.value ?? [],
      globalPeriod: globalPeriod,
      firstHalfEndDay: firstHalfEndDay,
    );
    final savings = income - spent;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: CashFlowSummaryStrip(
              income: income,
              spent: spent,
              savings: savings,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TransactionTabBar(controller: _tabController),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ExpensesTab(),
                IncomeTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}