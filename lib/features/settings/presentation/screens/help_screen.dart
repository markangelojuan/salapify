import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/l10n/app_localizations.dart';
import 'package:salapify/core/localization/locale_text.dart';

class FaqEntry {
  const FaqEntry({required this.question, required this.answer});
  final String question;
  final String answer;
}

class FaqSection {
  const FaqSection({
    required this.icon,
    required this.title,
    required this.entries,
  });

  final IconData icon;
  final String title;
  final List<FaqEntry> entries;
}

List<FaqSection> buildSalapifyFaqs(AppLocalizations l10n) => [
  FaqSection(
    icon: Icons.rocket_launch_rounded,
    title: l10n.faqSectionStarted,
    entries: [
      FaqEntry(question: l10n.faqStartedQ1, answer: l10n.faqStartedA1),
    ],
  ),
  FaqSection(
    icon: Icons.pie_chart_rounded,
    title: l10n.faqSectionBudgeting,
    entries: [
      FaqEntry(question: l10n.faqBudgetQ1, answer: l10n.faqBudgetA1),
      FaqEntry(question: l10n.faqBudgetQ2, answer: l10n.faqBudgetA2),
      FaqEntry(question: l10n.faqBudgetQ3, answer: l10n.faqBudgetA3),
      FaqEntry(question: l10n.faqBudgetQ4, answer: l10n.faqBudgetA4),
    ],
  ),
  FaqSection(
    icon: Icons.receipt_long_rounded,
    title: l10n.faqSectionTransactions,
    entries: [
      FaqEntry(question: l10n.faqTxQ1, answer: l10n.faqTxA1),
      FaqEntry(question: l10n.faqTxQ2, answer: l10n.faqTxA2),
      FaqEntry(question: l10n.faqTxQ3, answer: l10n.faqTxA3),
      FaqEntry(question: l10n.faqTxQ4, answer: l10n.faqTxA4),
    ],
  ),
  FaqSection(
    icon: Icons.groups_rounded,
    title: l10n.faqSectionSplit,
    entries: [
      FaqEntry(question: l10n.faqSplitQ1, answer: l10n.faqSplitA1),
      FaqEntry(question: l10n.faqSplitQ2, answer: l10n.faqSplitA2),
      FaqEntry(question: l10n.faqSplitQ3, answer: l10n.faqSplitA3),
      FaqEntry(question: l10n.faqSplitQ4, answer: l10n.faqSplitA4),
      FaqEntry(question: l10n.faqSplitQ5, answer: l10n.faqSplitA5),
      FaqEntry(question: l10n.faqSplitQ6, answer: l10n.faqSplitA6),
    ],
  ),
  FaqSection(
    icon: Icons.event_repeat_rounded,
    title: l10n.faqSectionPeriods,
    entries: [
      FaqEntry(question: l10n.faqPeriodQ1, answer: l10n.faqPeriodA1),
      FaqEntry(question: l10n.faqPeriodQ2, answer: l10n.faqPeriodA2),
      FaqEntry(question: l10n.faqPeriodQ3, answer: l10n.faqPeriodA3),
    ],
  ),
  FaqSection(
    icon: Icons.notifications_active_rounded,
    title: l10n.faqSectionNotifications,
    entries: [
      FaqEntry(question: l10n.faqNotifQ1, answer: l10n.faqNotifA1),
      FaqEntry(question: l10n.faqNotifQ2, answer: l10n.faqNotifA2),
    ],
  ),
];

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key, this.sections});

  /// Optional override (e.g. for tests). Defaults to the localized FAQs.
  final List<FaqSection>? sections;

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FaqSection> _filtered(List<FaqSection> all) {
    if (_query.trim().isEmpty) return all;

    final q = _query.toLowerCase();

    return all
        .map((s) {
          final matches = s.entries
              .where(
                (e) =>
                    e.question.toLowerCase().contains(q) ||
                    e.answer.toLowerCase().contains(q),
              )
              .toList();

          return FaqSection(icon: s.icon, title: s.title, entries: matches);
        })
        .where((s) => s.entries.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final all = widget.sections ?? buildSalapifyFaqs(l10n);
    final sections = _filtered(all);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: Text(l10n.helpTitle)),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: _SearchField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          if (sections.isEmpty)
            _NoResults(query: _query)
          else ...[
            for (final section in sections) ...[
              _SectionLabel(icon: section.icon, title: section.title),
              _FaqCard(entries: section.entries),
            ],
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

/// -------------------------------------------
/// Pieces

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: l10n.helpSearchHint,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.45),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colorScheme.onSurface.withValues(alpha: 0.45),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

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
            title.toUpperCaseL(context),
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

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.entries});

  final List<FaqEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
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
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            _FaqTile(entry: entries[i]),
            if (i != entries.length - 1)
              Divider(
                height: 1,
                indent: 20,
                endIndent: 20,
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
          ],
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.entry});

  final FaqEntry entry;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.entry.question,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _expanded
                        ? AppColors.primary
                        : colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        widget.entry.answer,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.5,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 40,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.helpNoResults(query),
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}