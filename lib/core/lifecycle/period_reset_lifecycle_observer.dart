import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/features/budget/presentation/controllers/budget_controller.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/transaction/presentation/controllers/transaction_controller.dart';


class PeriodResetLifecycleObserver extends ConsumerStatefulWidget {
  const PeriodResetLifecycleObserver({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<PeriodResetLifecycleObserver> createState() =>
      _PeriodResetLifecycleObserverState();
}

class _PeriodResetLifecycleObserverState
    extends ConsumerState<PeriodResetLifecycleObserver>
    with WidgetsBindingObserver {
  Timer? _boundaryTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleNextBoundary();
    // Fire once on cold start too, not just on subsequent resumes.
    ref.read(transactionRetentionGuardProvider);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _boundaryTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(periodResetGuardProvider);
      ref.invalidate(transactionRetentionGuardProvider);
      _scheduleNextBoundary(); 
    }
  }

  void _scheduleNextBoundary() {
    _boundaryTimer?.cancel();

    final globalPeriod =
        ref.read(budgetingPeriodSettingProvider).value ??
        BudgetingPeriod.monthly;
    final firstHalfEndDay =
        ref.read(firstHalfEndDaySettingProvider).value ?? 15;

    final now = DateTime.now();
    final boundary = _nextPeriodBoundary(
      globalPeriod: globalPeriod,
      firstHalfEndDay: firstHalfEndDay,
      now: now,
    );

    final delay = boundary.difference(now) + const Duration(seconds: 1);
    _boundaryTimer = Timer(delay, () {
      ref.invalidate(periodResetGuardProvider);
      _scheduleNextBoundary();
    });
  }


  static DateTime _nextPeriodBoundary({
    required BudgetingPeriod globalPeriod,
    required int firstHalfEndDay,
    required DateTime now,
  }) {
    final startOfNextMonth = DateTime(now.year, now.month + 1, 1);

    if (globalPeriod == BudgetingPeriod.monthly) {
      return startOfNextMonth;
    }

    final startOfSecondHalf = DateTime(
      now.year,
      now.month,
      firstHalfEndDay + 1,
    );
    return startOfSecondHalf.isAfter(now)
        ? startOfSecondHalf
        : startOfNextMonth;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}