import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/l10n/app_localizations.dart';
import 'package:salapify/features/settings/domain/currency.dart';
import 'package:salapify/core/localization/app_languages.dart';
import 'package:salapify/core/localization/locale_controller.dart';
import 'package:salapify/features/settings/domain/settings_warning.dart';
import 'package:salapify/features/settings/presentation/widgets/settings_warning_text.dart';
import 'package:salapify/router/routes.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmAndSetPeriod(
    BuildContext context,
    WidgetRef ref,
    BudgetingPeriod newPeriod,
  ) async {
    if (ref.read(budgetingPeriodSettingProvider).value == newPeriod) return;
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.changePeriodTitle),
        content: Text(l10n.changePeriodMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonContinue),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(budgetingPeriodSettingProvider.notifier).set(newPeriod);
    }
  }

  Future<void> _openCurrencyPicker(
    BuildContext context,
    WidgetRef ref,
    AppCurrency selected,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CurrencyPickerSheet(
        selected: selected,
        onSelect: (c) {
          ref.read(currencySettingProvider.notifier).set(c);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  Future<void> _openLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    Locale? selected,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _LanguagePickerSheet(
        selected: selected,
        onSelect: (l) {
          ref.read(localeControllerProvider.notifier).set(l);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodAsync = ref.watch(budgetingPeriodSettingProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    ref.listen<AsyncValue<BudgetingPeriod>>(budgetingPeriodSettingProvider, (
      previous,
      next,
    ) {
      if (next.hasError) {
        CommonSnackbar.showError(context, next.error!);
      }
    });
    ref.listen<SettingsWarning?>(settingsSyncWarningProvider, (previous, next) {
      if (next != null) {
        CommonSnackbar.showWarning(context, next.text(l10n));
        ref.read(settingsSyncWarningProvider.notifier).set(null);
      }
    });

    final period = periodAsync.asData?.value;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: Text(AppLocalizations.of(context).settingsTitle)),
      body: period == null
          ? (periodAsync.hasError
                ? Center(
                    child: Text(
                      l10n.settingsLoadFailed('${periodAsync.error}'),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()))
          : ListView(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              children: [
                _SectionLabel(
                  icon: Icons.calendar_today_rounded,
                  title: l10n.settingsBudgetingPeriod,
                ),
                _SettingsCard(
                  children: [
                    _SelectableOptionTile(
                      label: l10n.budgetingPeriodMonthly,
                      subtitle: l10n.budgetingPeriodMonthlyDesc,
                      selected: period == BudgetingPeriod.monthly,
                      onTap: () => _confirmAndSetPeriod(
                        context,
                        ref,
                        BudgetingPeriod.monthly,
                      ),
                    ),
                    _CardDivider(colorScheme: colorScheme),
                    _SelectableOptionTile(
                      label: l10n.budgetingPeriodBiMonthly,
                      subtitle: l10n.budgetingPeriodBiMonthlyDesc,
                      selected: period == BudgetingPeriod.biMonthly,
                      onTap: () => _confirmAndSetPeriod(
                        context,
                        ref,
                        BudgetingPeriod.biMonthly,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      alignment: Alignment.topCenter,
                      child: period == BudgetingPeriod.biMonthly
                          ? _NestedPanel(
                              child: Consumer(
                                builder: (context, ref, _) {
                                  final dayAsync = ref.watch(
                                    firstHalfEndDaySettingProvider,
                                  );
                                  ref.listen<AsyncValue<int>>(
                                    firstHalfEndDaySettingProvider,
                                    (previous, next) {
                                      if (next.hasError) {
                                        CommonSnackbar.showError(
                                          context,
                                          next.error!,
                                        );
                                      }
                                    },
                                  );
                                  final day = dayAsync.asData?.value;
                                  if (day == null) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          4,
                                          4,
                                          4,
                                          10,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.event_repeat_rounded,
                                              size: 14,
                                              color: colorScheme.onSurface
                                                  .withValues(alpha: 0.55),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              l10n.settingsFirstHalfEndsOn,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: colorScheme.onSurface
                                                    .withValues(alpha: 0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _DaySelector(
                                        selectedDay: day,
                                        onChanged: (v) => ref
                                            .read(
                                              firstHalfEndDaySettingProvider
                                                  .notifier,
                                            )
                                            .set(v),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
                _SectionLabel(
                  icon: Icons.payments_rounded,
                  title: l10n.settingsCurrency,
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final currencyAsync = ref.watch(currencySettingProvider);
                    ref.listen<AsyncValue<AppCurrency>>(
                      currencySettingProvider,
                      (previous, next) {
                        if (next.hasError) {
                          CommonSnackbar.showError(context, next.error!);
                        }
                      },
                    );
                    final currency = currencyAsync.asData?.value;
                    if (currency == null) {
                      return const _SettingsCard(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      );
                    }
                    return _SettingsCard(
                      children: [
                        _CurrencyTile(
                          currency: currency,
                          onTap: () =>
                              _openCurrencyPicker(context, ref, currency),
                        ),
                      ],
                    );
                  },
                ),
                _SectionLabel(
                  icon: Icons.language_rounded,
                  title: l10n.settingsLanguage,
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final locale = ref.watch(localeControllerProvider);
                    return _SettingsCard(
                      children: [
                        InkWell(
                          onTap: () =>
                              _openLanguagePicker(context, ref, locale),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    nativeNameFor(locale) ??
                                        l10n.languageSystemDefault,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                _SectionLabel(
                  icon: Icons.notifications_active_rounded,
                  title: l10n.settingsReminders,
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final remindersAsync = ref.watch(
                      reminderNotificationsSettingProvider,
                    );
                    ref.listen<AsyncValue<bool>>(
                      reminderNotificationsSettingProvider,
                      (previous, next) {
                        if (next.hasError) {
                          CommonSnackbar.showError(context, next.error!);
                        }
                      },
                    );
                    final enabled = remindersAsync.asData?.value;
                    if (enabled == null) {
                      return const _SettingsCard(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      );
                    }
                    return _SettingsCard(
                      children: [
                        SwitchListTile(
                          title: Text(
                            l10n.settingsAppReminders,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            l10n.settingsAppRemindersDesc,
                            style: const TextStyle(fontSize: 12),
                          ),
                          value: enabled,
                          activeThumbColor: AppColors.primary,
                          onChanged: (v) => ref
                              .read(
                                reminderNotificationsSettingProvider.notifier,
                              )
                              .set(v),
                        ),
                      ],
                    );
                  },
                ),
                _SectionLabel(
                  icon: Icons.block_rounded,
                  title: l10n.settingsPrivacy,
                ),
                _SettingsCard(
                  children: [
                    InkWell(
                      onTap: () =>
                          context.pushNamed(AppRoutes.blockedUsers.name),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.settingsBlockedUsers,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

/// Small caps section label sitting above its card, iOS-grouped-list style.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 10),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.6,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded, softly-shadowed container that groups related rows into one
/// visually distinct block — replaces the flat divider-only separation.
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
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
      child: Column(children: children),
    );
  }
}

/// Thin inset divider used *between rows inside* a card.
class _CardDivider extends StatelessWidget {
  const _CardDivider({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
    );
  }
}

/// Tinted, inset panel used to nest a dependent setting (e.g. the first-half
/// day picker) *inside* its parent card, instead of breaking it out into a
/// visually equal, same-level section.
class _NestedPanel extends StatelessWidget {
  const _NestedPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 6),
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

/// A tappable row with a label/subtitle and a check-style indicator.
class _SelectableOptionTile extends StatelessWidget {
  const _SelectableOptionTile({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : colorScheme.onSurface.withValues(alpha: 0.25),
                  width: 1.6,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        key: ValueKey('checked'),
                        size: 16,
                        color: Colors.white,
                      )
                    : const SizedBox.shrink(key: ValueKey('unchecked')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontally scrollable day-picker (1-28) styled as pill chips.
class _DaySelector extends StatelessWidget {
  const _DaySelector({required this.selectedDay, required this.onChanged});

  final int selectedDay;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 28,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = index + 1;
          final selected = day == selectedDay;
          return GestureDetector(
            onTap: () => onChanged(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                '$day',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: selected ? Colors.white : colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The currency row shown on the main screen — current selection with a
/// colored symbol avatar, opens the picker sheet on tap.
class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({required this.currency, required this.onTap});

  final AppCurrency currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              // Wide symbols (NZ$, HK$, NT$, NRs, KSh) shrink to fit.
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    currency.symbol,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.code,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.currencyTapToChange,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet listing every currency as a proper scrollable list with a
/// symbol avatar and a check indicator — replaces the flat Wrap of chips.
class _CurrencyPickerSheet extends StatelessWidget {
  const _CurrencyPickerSheet({required this.selected, required this.onSelect});

  final AppCurrency selected;
  final ValueChanged<AppCurrency> onSelect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    l10n.currencyChoose,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: AppCurrency.values.length,
                separatorBuilder: (_, _) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final currency = AppCurrency.values[index];
                  final isSelected = currency == selected;
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onSelect(currency),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : colorScheme.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                            // Wide symbols shrink to fit the circle.
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  currency.symbol,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              currency.code,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet({required this.selected, required this.onSelect});

  final Locale? selected;
  final ValueChanged<Locale?> onSelect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    final options = <(Locale?, String)>[
      (null, l10n.languageSystemDefault),
      for (final l in supportedLanguages) (l.locale, l.nativeName),
    ];

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.languageChoose,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            for (final (locale, label) in options)
              InkWell(
                onTap: () => onSelect(locale),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (locale == selected)
                        const Icon(
                          Icons.check_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
