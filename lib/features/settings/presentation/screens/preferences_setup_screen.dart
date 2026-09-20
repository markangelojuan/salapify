import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/domain/currency.dart';
import 'package:salapify/features/settings/presentation/controllers/preferences_controller.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/settings/presentation/widgets/currency_option_tile.dart';
import 'package:salapify/features/settings/presentation/widgets/day_selector.dart';
import 'package:salapify/features/settings/presentation/widgets/selectable_option_tile.dart';

/// Shown once, right after the avatar picker, for brand-new accounts.
/// The router forces users here until `preferencesCompleted` is true.
class PreferencesSetupScreen extends ConsumerStatefulWidget {
  const PreferencesSetupScreen({super.key});

  @override
  ConsumerState<PreferencesSetupScreen> createState() =>
      _PreferencesSetupScreenState();
}

class _PreferencesSetupScreenState
    extends ConsumerState<PreferencesSetupScreen> {
  static const _stepCount = 2;

  final _pageController = PageController();
  int _step = 0;

  late BudgetingPeriod _period;
  late int _day;
  late AppCurrency _currency;

  @override
  void initState() {
    super.initState();
    // Start from whatever is stored locally (defaults for a fresh install,
    // or the guest's choices if they upgraded from guest mode).
    _period =
        ref.read(budgetingPeriodSettingProvider).value ??
        BudgetingPeriod.monthly;
    _day = ref.read(firstHalfEndDaySettingProvider).value ?? 15;
    _currency = ref.read(currencySettingProvider).value ?? AppCurrency.php;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isLastStep => _step == _stepCount - 1;

  void _goToStep(int step) {
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _onPrimaryPressed() async {
    if (!_isLastStep) {
      _goToStep(_step + 1);
      return;
    }
    if (ref.read(preferencesControllerProvider).isLoading) return;
    await ref
        .read(preferencesControllerProvider.notifier)
        .complete(
          period: _period,
          firstHalfEndDay: _day,
          currency: _currency,
        );
    // No navigation here: the router redirects to /home once
    // currentAppUserProvider reports preferencesCompleted == true.
  }

  Future<void> _onSkipPressed() async {
    if (ref.read(preferencesControllerProvider).isLoading) return;
    await ref.read(preferencesControllerProvider.notifier).skip();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final saveState = ref.watch(preferencesControllerProvider);

    ref.listen<AsyncValue<void>>(preferencesControllerProvider, (prev, next) {
      next.whenOrNull(error: (e, _) => CommonSnackbar.showError(context, e));
    });

    return PopScope(
      canPop: false, // no escaping onboarding with the system back button
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                child: _StepProgress(
                  step: _step,
                  count: _stepCount,
                  colors: colors,
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _StepPage(
                      icon: Icons.calendar_today_rounded,
                      title: 'How do you budget?',
                      description:
                          'Your budget period decides when your category '
                          'budgets reset.',
                      colors: colors,
                      child: _PeriodStep(
                        period: _period,
                        day: _day,
                        onPeriodChanged: (p) => setState(() => _period = p),
                        onDayChanged: (d) => setState(() => _day = d),
                      ),
                    ),
                    _StepPage(
                      icon: Icons.payments_rounded,
                      title: 'Pick your currency',
                      description:
                          'This is the symbol shown across your budgets and '
                          'transactions.',
                      colors: colors,
                      child: _CardContainer(
                        child: Column(
                          children: [
                            for (final c in AppCurrency.values)
                              CurrencyOptionTile(
                                currency: c,
                                selected: c == _currency,
                                onTap: () => setState(() => _currency = c),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 12),
                child: Column(
                  children: [
                    CommonButton(
                      label: _isLastStep ? 'Get started' : 'Next',
                      btnColor: colors.textPrimary,
                      labelColor: colors.background,
                      onPressed: _onPrimaryPressed,
                      isLoading: saveState.isLoading,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_step > 0)
                          TextButton(
                            onPressed: saveState.isLoading
                                ? null
                                : () => _goToStep(_step - 1),
                            child: Text(
                              'Back',
                              style: TextStyle(color: colors.textSecondary),
                            ),
                          ),
                        TextButton(
                          onPressed: saveState.isLoading
                              ? null
                              : _onSkipPressed,
                          child: Text(
                            'Use defaults',
                            style: TextStyle(color: colors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'You can change these anytime in Settings',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Slim segmented progress bar: completed and current steps are filled.
class _StepProgress extends StatelessWidget {
  const _StepProgress({
    required this.step,
    required this.count,
    required this.colors,
  });

  final int step;
  final int count;
  final AppColorsExt colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 5,
              decoration: BoxDecoration(
                color: i <= step
                    ? colors.primary
                    : colors.textSecondary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Shared layout for one wizard step: icon, title, one-line explanation,
/// then the step's content.
class _StepPage extends StatelessWidget {
  const _StepPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.colors,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String description;
  final AppColorsExt colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.primary, size: 30),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class _PeriodStep extends StatelessWidget {
  const _PeriodStep({
    required this.period,
    required this.day,
    required this.onPeriodChanged,
    required this.onDayChanged,
  });

  final BudgetingPeriod period;
  final int day;
  final ValueChanged<BudgetingPeriod> onPeriodChanged;
  final ValueChanged<int> onDayChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _CardContainer(
      child: Column(
        children: [
          SelectableOptionTile(
            label: 'Monthly',
            subtitle: 'One budget for the whole month',
            selected: period == BudgetingPeriod.monthly,
            onTap: () => onPeriodChanged(BudgetingPeriod.monthly),
          ),
          Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          SelectableOptionTile(
            label: 'Twice a month',
            subtitle: 'Split into two halves, great if you get paid twice',
            selected: period == BudgetingPeriod.biMonthly,
            onTap: () => onPeriodChanged(BudgetingPeriod.biMonthly),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: period == BudgetingPeriod.biMonthly
                ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
                          child: Text(
                            'First half ends on',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
                          child: Text(
                            'Day $day means the first half runs from the 1st '
                            'to the ${_ordinal(day)}.',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                        DaySelector(selectedDay: day, onChanged: onDayChanged),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  static String _ordinal(int n) {
    if (n >= 11 && n <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }
}

/// Same rounded, softly-shadowed card used by the Settings screen.
class _CardContainer extends StatelessWidget {
  const _CardContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}