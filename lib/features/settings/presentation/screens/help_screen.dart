import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

/// ---------------------------------------------------------------------
/// Content model
/// ---------------------------------------------------------------------

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


const List<FaqSection> kSalapifyFaqs = [
  FaqSection(
    icon: Icons.rocket_launch_rounded,
    title: 'Getting Started',
    entries: [
      FaqEntry(
        question: 'What does Salapify actually do?',
        answer:
            'Salapify combines budget tracking with bill splitting. Use the '
            'Budget tab to allocate money into categories, the Transactions '
            'tab to log income and spending, and the Split Bills tab to '
            'settle shared expenses with friends or strangers — all in one '
            'place.',
      ),
    ],
  ),
  FaqSection(
    icon: Icons.pie_chart_rounded,
    title: 'Budgeting',
    entries: [
      FaqEntry(
        question: 'How do I create a budget category?',
        answer:
            'Tap the FAB on the Budget tab. Give it a name (like '
            'Internet Bill or Groceries), choose whether it\'s Fixed or '
            'Variable. Then complete other fields',
      ),
      FaqEntry(
        question: 'What\'s the difference between Fixed and Variable?',
        answer:
            'Fixed is for predictable costs like an Internet Bill — you set '
            'one amount. Variable is for spending that changes, like '
            'Groceries — you set a target ceiling instead of an exact '
            'amount. Both can be marked as recurring every period or as a '
            'one-time category.',
      ),
      FaqEntry(
        question: 'What happens when I check off a category as completed?',
        answer:
            'Marking a category\'s checkbox as done automatically logs it '
            'as a transaction for the current period, so a Fixed bill like '
            'Internet doesn\'t need to be entered twice.',
      ),
      FaqEntry(
        question: 'Why are some categories dimmed on my Budget tab?',
        answer:
            'Dimmed categories belong to a different half of the period '
            '(under bi-monthly budgeting) than the one currently active. '
            'They\'ll come back into focus automatically once their'
            'half starts.',
      ),
    ],
  ),
  FaqSection(
    icon: Icons.receipt_long_rounded,
    title: 'Transactions & Income',
    entries: const [
      FaqEntry(
        question: 'How do I add income?',
        answer:
            'From the Transactions tab, add an income entry and mark it as '
            'One-time or Recurring. Recurring income is automatically '
            'added again at the start of each new period.',
      ),
      FaqEntry(
        question: 'How do transactions affect my budget?',
        answer:
            'When you log a transaction, you assign it to a budget '
            'category. The amount is automatically deducted from that '
            'category\'s allocation, so your Budget tab always reflects '
            'what\'s left to spend.',
      ),
      FaqEntry(
        question: 'Why don\'t I see last period\'s transactions?',
        answer:
            'The Budget and Transactions tabs only show totals for the '
            'current period, based on the budgeting period you\'ve set in '
            'Settings. This keeps the numbers focused on what you can '
            'still act on.',
      ),
    ],
  ),
  FaqSection(
    icon: Icons.groups_rounded,
    title: 'Split Bills',
    entries: [
      FaqEntry(
        question: 'How do I split a bill with friends?',
        answer:
            'Create a group and add members by their usernames. Inside the '
            'group, create a bill (e.g. "Dinner @ KFC"), enter the amount '
            'you paid, and split it equally or with custom shares per '
            'member.',
      ),
      FaqEntry(
        question: 'Can I share receipts or chat with my group?',
        answer:
            'Yes. Every group has an Activity section for messaging '
            'members and sharing photos, like receipts, right alongside '
            'the bill history.',
      ),
      FaqEntry(
        question: 'Do split bills affect my personal budget?',
        answer:
            'No — Split Bills is kept separate from your Budget and '
            'Transactions tabs. If you want a settled bill reflected in '
            'your spending, log it manually as a transaction.',
      ),
    ],
  ),
  FaqSection(
    icon: Icons.event_repeat_rounded,
    title: 'Periods & Settings',
    entries: [
      FaqEntry(
        question: 'What\'s the difference between Monthly and Bi-Monthly?',
        answer:
            'Monthly resets your budget on the 1st of every month. '
            'Bi-Monthly splits the month into two halves — you choose the '
            'day the first half ends, and the rest of the month becomes '
            'the second half.',
      ),
      FaqEntry(
        question: 'What happens to my categories if I change the period?',
        answer:
            'Existing categories are converted to match the new period and '
            'keep their amounts. Categories tied to a specific half will '
            'now count toward the full month, or vice versa, so it\'s '
            'worth reviewing them afterward for duplicates.',
      ),
      FaqEntry(
        question: 'How does recurrence work with bi-monthly budgeting?',
        answer:
            'A recurring category or income repeats every half you\'ve '
            'set it for. Switch to Monthly and the same item simply '
            'repeats once a month instead.',
      ),
    ],
  ),
  FaqSection(
    icon: Icons.notifications_active_rounded,
    title: 'Notifications',
    entries: [
      FaqEntry(
        question: 'What shows up in the Notifications tab?',
        answer:
            'Reminders for budget, updates on split '
            'bill activity, and alerts when a payer disputes or confirms '
            'one of your shares.',
      ),
      FaqEntry(
        question: 'Can I turn off notifications?',
        answer:
            'Yes, from your device Settings > Apps > Salapify > '
            'Notifications, you can turn off alerts entirely or fine-tune '
            'which categories of alerts you want to receive.',
      ),
    ],
  ),
];


class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key, this.sections = kSalapifyFaqs});

  final List<FaqSection> sections;

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

  List<FaqSection> get _filtered {
    if (_query.trim().isEmpty) return widget.sections;
    final q = _query.toLowerCase();
    return widget.sections
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
    final colorScheme = Theme.of(context).colorScheme;
    final sections = _filtered;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: const Text('Help & FAQ')),
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
          hintText: 'Search for a topic...',
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
              'No results for "$query"',
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