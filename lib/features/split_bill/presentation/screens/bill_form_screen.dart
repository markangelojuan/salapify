import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/core/widgets/common_text_field.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/split_bill/domain/entities/bill_share.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';
import 'package:salapify/features/split_bill/domain/entities/split_type.dart';
import 'package:salapify/features/split_bill/domain/exceptions/bill_limit_exceeded_exception.dart';
import 'package:salapify/features/split_bill/domain/split_balance_calculator.dart';
import 'package:salapify/features/split_bill/presentation/controllers/split_bill_controller.dart';
import 'package:salapify/features/split_bill/domain/entities/payment_status.dart';
import 'package:salapify/features/settings/domain/currency.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/core/widgets/common_confirmation_dialog.dart';

class BillFormArgs {
  const BillFormArgs({required this.group, this.existingBill});

  final SplitGroup group;
  final SplitBill? existingBill;
}

class BillFormScreen extends ConsumerStatefulWidget {
  const BillFormScreen({super.key, required this.group, this.existingBill});

  final SplitGroup group;
  final SplitBill? existingBill;

  @override
  ConsumerState<BillFormScreen> createState() => _BillFormScreenState();
}

class _BillFormScreenState extends ConsumerState<BillFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _totalController = TextEditingController();

  SplitType _splitType = SplitType.equal;
  String? _paidBy;
  final Map<String, TextEditingController> _customControllers = {};
  bool _isSaving = false;

  final Map<String, String> _resolvedNames = {};
  final Set<String> _namesBeingResolved = {};

  Set<String>? _knownMemberIds;

  bool get _isEditingExisting => widget.existingBill != null;

  bool get _canEdit {
    if (widget.existingBill == null) return true;
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    return widget.existingBill!.paidBy == uid;
  }

  List<String> get _participantIds {
    final existing = widget.existingBill;
    if (existing != null) {
      return {
        existing.paidBy,
        ...existing.shares.map((s) => s.userId),
      }.toList();
    }
    final known = _knownMemberIds;

    if (known == null) return widget.group.memberIds;
    return widget.group.memberIds.where(known.contains).toList();
  }

  @override
  void initState() {
    super.initState();
    final existing = widget.existingBill;

    if (existing != null) {
      _paidBy = existing.paidBy;
      _titleController.text = existing.title;
      _totalController.text = existing.totalAmount.toString();
      _splitType = existing.splitType;
    } else {
      _paidBy = ref.read(authRepositoryProvider).currentUser?.uid;
    }

    for (final id in _participantIds) {
      final controller = TextEditingController();
      if (existing != null && existing.splitType == SplitType.custom) {
        final share = existing.shares.firstWhereOrNull((s) => s.userId == id);
        if (share != null) {
          controller.text = share.amountOwed.toString();
        }
      }
      _customControllers[id] = controller;
    }

    _totalController.addListener(
      () => setState(() {}),
    ); // live equal-split preview
  }

  @override
  void dispose() {
    _titleController.dispose();
    _totalController.dispose();
    for (final c in _customControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  double get _total => double.tryParse(_totalController.text) ?? 0;

  void _syncCustomControllers(Iterable<String> participantIds) {
    for (final id in participantIds) {
      _customControllers.putIfAbsent(id, () => TextEditingController());
    }
  }

  /// Fetches usernames for participants missing from [knownNames] (i.e.
  /// people who've left the group since this bill was created) and merges
  /// them in via setState once resolved. Guarded against re-fetching the
  /// same id on every rebuild.
  void _resolveMissingNames(
    Iterable<String> participantIds,
    Map<String, String> knownNames,
  ) {
    final missing = participantIds
        .where(
          (id) =>
              !knownNames.containsKey(id) &&
              !_resolvedNames.containsKey(id) &&
              !_namesBeingResolved.contains(id),
        )
        .toSet(); // snapshot now — `where` is lazy and re-evaluates the
    // predicate on every traversal, which would otherwise see its own
    // `_namesBeingResolved.addAll` below and think there's nothing left
    // to fetch.
    if (missing.isEmpty) return;

    _namesBeingResolved.addAll(missing);
    final userRepo = ref.read(userRepositoryProvider);
    Future.wait(
          missing.map((id) async {
            final username = await userRepo.getUsername(id);
            return MapEntry(id, username ?? 'Unknown');
          }),
        )
        .then((entries) {
          if (!mounted) return;
          setState(() {
            _resolvedNames.addEntries(entries);
            _namesBeingResolved.removeAll(missing);
          });
        })
        .catchError((e) {
          if (!mounted) return;
          setState(() => _namesBeingResolved.removeAll(missing));
          CommonSnackbar.showError(context, e);
        });
  }

  Map<String, double> _computeShares() {
    final others = _participantIds.where((id) => id != _paidBy).toList();

    if (_splitType == SplitType.equal) {
      return SplitBalanceCalculator.splitEqually(
        totalAmount: _total,
        memberIds: _participantIds,
        paidBy: _paidBy!,
      );
    }

    return {
      for (final id in others)
        id: double.tryParse(_customControllers[id]!.text) ?? 0,
    };
  }

  Future<void> _save(Map<String, String> names) async {
    if (!_formKey.currentState!.validate()) return;
    if (_paidBy == null) return;

    final shares = _computeShares();

    setState(() => _isSaving = true);
    final controller = ref.read(splitBillControllerProvider.notifier);

    if (widget.existingBill != null) {
      final existing = widget.existingBill!;
      final updatedBill = existing.copyWith(
        title: _titleController.text.trim(),
        totalAmount: _total,
        splitType: _splitType,
        shares: shares.entries.map((e) {
          // Preserve payment status/timestamp for shares that already existed.
          final existingShare = existing.shares.firstWhereOrNull(
            (s) => s.userId == e.key,
          );
          return BillShare(
            userId: e.key,
            amountOwed: e.value,
            status: existingShare?.status ?? PaymentStatus.unpaid,
            statusUpdatedAt: existingShare?.statusUpdatedAt,
          );
        }).toList(),
      );
      await controller.updateBill(updatedBill);
    } else {
      final bill = SplitBill(
        id: '',
        groupId: widget.group.id,
        title: _titleController.text.trim(),
        totalAmount: _total,
        paidBy: _paidBy!,
        splitType: _splitType,
        shares: shares.entries
            .map((e) => BillShare(userId: e.key, amountOwed: e.value))
            .toList(),
        createdAt: DateTime.now(),
      );
      await controller.createBill(bill);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    final error = ref.read(splitBillControllerProvider).error;
    if (error != null) {
      if (error is BillLimitExceededException) {
        CommonSnackbar.showError(
          context,
          'This group has reached its limit of ${error.limit} bills.',
        );
      } else {
        CommonSnackbar.showError(context, 'Failed to save bill: $error');
      }
      return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final confirmed = await CommonConfirmationDialog.show(
      context,
      title: 'Delete this bill?',
      message: 'This cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (!confirmed) return;

    setState(() => _isSaving = true);
    await ref
        .read(splitBillControllerProvider.notifier)
        .deleteBill(groupId: widget.group.id, billId: widget.existingBill!.id);

    if (!mounted) return;
    setState(() => _isSaving = false);

    final error = ref.read(splitBillControllerProvider).error;
    if (error != null) {
      CommonSnackbar.showError(context, 'Failed to delete bill: $error');
      return;
    }

    final creatorIsPremium = await ref
        .read(userRepositoryProvider)
        .isPremiumUser(widget.group.createdBy);

    if (!mounted) return;

    if (creatorIsPremium) {
      CommonSnackbar.showSuccess(
        context,
        'Bill deleted. You can add a new one anytime.',
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final currency =
        ref.watch(currencySettingProvider).value ?? AppCurrency.php;
    final membersAsync = ref.watch(groupMembersProvider(widget.group.id));
    final groupNames = {
      for (final e in (membersAsync.value ?? {}).entries)
        e.key: e.value.username,
    };

    _knownMemberIds = membersAsync.value?.keys.toSet();
    if (!_isEditingExisting) {
      _syncCustomControllers(_participantIds);
    }

    if (_isEditingExisting) {
      _resolveMissingNames(_participantIds, groupNames);
    }
    final names = {...groupNames, ..._resolvedNames};
    final others = _participantIds.where((id) => id != _paidBy).toList();
    final currentMemberIds = widget.group.memberIds.toSet();
    final equalPreview = _splitType == SplitType.equal && _total > 0
        ? SplitBalanceCalculator.splitEqually(
            totalAmount: _total,
            memberIds: _participantIds,
            paidBy: _paidBy ?? '',
          )
        : <String, double>{};

    final canEdit = _canEdit;
    final title = !_isEditingExisting
        ? 'Add Bill'
        : (canEdit ? 'Edit Bill' : 'Bill Details');

    // Live bill lookup so payment-status changes (confirm/decline) made
    // from this same screen are reflected immediately, instead of relying
    // on the static widget.existingBill snapshot passed in via router extra.
    final liveBill = _isEditingExisting
        ? (ref
                  .watch(splitBillsProvider(widget.group.id))
                  .value
                  ?.firstWhereOrNull((b) => b.id == widget.existingBill!.id) ??
              widget.existingBill)
        : null;

    // Once any share has been marked paid, confirmed, or disputed,
    // changing the total (or the split) would silently change what each
    // person owes without touching their recorded status — e.g. someone's
    // "confirmed ₱500" could quietly become "confirmed ₱750". Lock those
    // two fields once that's happened; the title is still safe to edit.
    final hasPaymentActivity =
        liveBill?.shares.any((s) => s.status != PaymentStatus.unpaid) ?? false;
    final lockTotalAndSplit = _isEditingExisting && hasPaymentActivity;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              if (_isEditingExisting && !canEdit) ...[
                _ReadOnlyBanner(
                  text: 'Only the person who paid can edit this bill.',
                ),
                const SizedBox(height: 16),
              ],
              if (_isEditingExisting && canEdit && lockTotalAndSplit) ...[
                _ReadOnlyBanner(
                  text:
                      'Total amount and split are locked — someone already '
                      'has payment activity on this bill.',
                ),
                const SizedBox(height: 16),
              ],
              AbsorbPointer(
                absorbing: !canEdit,
                child: Opacity(
                  opacity: canEdit ? 1 : 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionCard(
                        title: 'Bill details',
                        icon: Icons.receipt_long_rounded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextField(
                              controller: _titleController,
                              textInputAction: TextInputAction.done,
                              icon: Icons.receipt_long_rounded,
                              maxCharacters: 55,
                              hint: 'e.g. Dinner @ KFC',
                              label: 'Title',
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Enter a title'
                                  : null,
                            ),
                            const SizedBox(height: 18),
                            AbsorbPointer(
                              absorbing: lockTotalAndSplit,
                              child: Opacity(
                                opacity: lockTotalAndSplit ? 0.55 : 1,
                                child: CommonTextField(
                                  controller: _totalController,
                                  icon: Icons.attach_money_rounded,
                                  prefixText: currency.symbol,
                                  hint: '0.00',
                                  label: 'Total amount',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d{0,2}'),
                                    ),
                                  ],
                                  validator: (v) {
                                    final val = double.tryParse(v ?? '');
                                    if (val == null || val <= 0) {
                                      return 'Enter a valid amount';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            if (lockTotalAndSplit) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.lock_outline_rounded,
                                    size: 12,
                                    color: colors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Locked — payment activity exists',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      _SectionCard(
                        title: 'Split',
                        icon: Icons.call_split_rounded,
                        trailing: others.isEmpty
                            ? null
                            : _CountPill(count: others.length),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // "Paid by" is only shown once editing an
                            // existing bill — the bill creator is always
                            // the payer, so on a brand-new bill this would
                            // just echo the current user's own name back
                            // at them.
                            if (_isEditingExisting) ...[
                              Text(
                                'Paid by',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _PaidByDisplay(name: names[_paidBy] ?? '...'),
                              const SizedBox(height: 18),
                            ],
                            AbsorbPointer(
                              absorbing: lockTotalAndSplit,
                              child: Opacity(
                                opacity: lockTotalAndSplit ? 0.55 : 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Kept as the app's standard pill-style
                                    // choice control, matching other option
                                    // pickers.
                                    SegmentedButton<SplitType>(
                                      segments: const [
                                        ButtonSegment(
                                          value: SplitType.equal,
                                          label: Text('Equally'),
                                        ),
                                        ButtonSegment(
                                          value: SplitType.custom,
                                          label: Text('Custom'),
                                        ),
                                      ],
                                      selected: {_splitType},
                                      onSelectionChanged: (s) =>
                                          setState(() => _splitType = s.first),
                                    ),
                                    if (others.isNotEmpty) ...[
                                      const SizedBox(height: 14),
                                      _ScrollablePanel(
                                        itemCount: others.length,
                                        itemBuilder: (context, i) {
                                          final id = others[i];
                                          final isFormerMember =
                                              !currentMemberIds.contains(id);
                                          return _splitType == SplitType.equal
                                              ? _SharePreviewRow(
                                                  name: names[id] ?? '...',
                                                  amount: equalPreview[id] ?? 0,
                                                  currency: currency,
                                                  isFormerMember:
                                                      isFormerMember,
                                                )
                                              : _CustomShareField(
                                                  name: names[id] ?? '...',
                                                  controller:
                                                      _customControllers[id]!,
                                                  currency: currency,
                                                  isFormerMember:
                                                      isFormerMember,
                                                );
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Per-member payment status + payer confirm/decline actions.
              // Lives here rather than on the bill card since it needs to
              // scale to any number of members.
              if (_isEditingExisting && liveBill != null)
                _PaymentStatusSection(
                  bill: liveBill,
                  names: names,
                  isPayer: canEdit,
                  currentMemberIds: currentMemberIds,
                  currency: currency,
                ),
              if (canEdit) ...[
                const SizedBox(height: 8),
                CommonButton(
                  label: _isEditingExisting ? 'Save Changes' : 'Add Bill',
                  btnColor: colors.textPrimary,
                  labelColor: colors.background,
                  isLoading: _isSaving,
                  onPressed: () => _save(names),
                ),
                if (_isEditingExisting) ...[
                  const SizedBox(height: 12),
                  CommonButton(
                    label: 'Delete Bill',
                    btnColor: colors.surface,
                    labelColor: colors.error,
                    isLoading: _isSaving,
                    onPressed: _delete,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Grouped section shell for each form section (bill details, split,
/// payment status). Uses the same gradient-tint + border recipe as
/// BudgetSummaryCard / CashFlowSummaryStrip instead of a flat white card,
/// so forms match the rest of the app's visual language.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.title,
    this.icon,
    this.trailing,
  });

  final Widget child;
  final String? title;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withValues(alpha: 0.07),
            colors.primary.withValues(alpha: 0.015),
          ],
        ),
        border: Border.all(color: colors.primary.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: colors.primary),
                  const SizedBox(width: 6),
                ],
                Text(
                  title!,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: colors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}

/// Small numeric pill used next to section titles (e.g. participant count),
/// matching the pill language already used elsewhere in this feature.
class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: colors.primary,
        ),
      ),
    );
  }
}

/// Shared bounded, internally-scrollable list panel. Used by both the
/// Split section and the Payment Status section so neither one grows
/// unbounded as group membership grows — keeps the Save/Delete buttons at
/// a predictable position regardless of group size.
class _ScrollablePanel extends StatelessWidget {
  const _ScrollablePanel({
    required this.itemCount,
    required this.itemBuilder,
    this.maxHeight = 260,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.04),
        border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Scrollbar(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          shrinkWrap: true,
          itemCount: itemCount,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            indent: 14,
            endIndent: 14,
            color: colors.primary.withValues(alpha: 0.10),
          ),
          itemBuilder: itemBuilder,
        ),
      ),
    );
  }
}

/// Soft banner chip for "view only" / "locked" notices.
class _ReadOnlyBanner extends StatelessWidget {
  const _ReadOnlyBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.textSecondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: colors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Read-only "paid by" row shown when editing an existing bill. Styled to
/// match the app's primary-tinted field containers (see date fields in
/// Expense/Income forms). Replaces the old editable dropdown now that the
/// bill creator is always the payer.
class _PaidByDisplay extends StatelessWidget {
  const _PaidByDisplay({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.05),
        border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline_rounded, size: 16, color: colors.primary),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small tag shown next to a participant's name when they're no longer in
/// the group (kicked or left) but still have a share on this bill.
class _FormerMemberBadge extends StatelessWidget {
  const _FormerMemberBadge();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.textSecondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Former member',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}

/// Read-only equal-split preview row. No border of its own — separation
/// comes from _ScrollablePanel's Divider — so rows read as one continuous
/// list rather than stacked cards.
class _SharePreviewRow extends StatelessWidget {
  const _SharePreviewRow({
    required this.name,
    required this.amount,
    required this.currency,
    this.isFormerMember = false,
  });

  final String name;
  final double amount;
  final AppCurrency currency;
  final bool isFormerMember;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isFormerMember) const _FormerMemberBadge(),
              ],
            ),
          ),
          Text(
            '${currency.symbol}${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Editable custom-split amount row — same borderless shell as
/// _SharePreviewRow, with a compact inline text field instead of a static
/// amount, so equal/custom modes read as the same component.
class _CustomShareField extends StatelessWidget {
  const _CustomShareField({
    required this.name,
    required this.controller,
    required this.currency,
    this.isFormerMember = false,
  });

  final String name;
  final TextEditingController controller;
  final AppCurrency currency;
  final bool isFormerMember;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isFormerMember) const _FormerMemberBadge(),
              ],
            ),
          ),
          Text(
            currency.symbol,
            style: TextStyle(
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 2),
          IntrinsicWidth(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 40, maxWidth: 90),
              child: TextFormField(
                controller: controller,
                textAlign: TextAlign.right,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: colors.textPrimary,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: '0.00',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentStatusSection extends ConsumerWidget {
  const _PaymentStatusSection({
    required this.bill,
    required this.names,
    required this.isPayer,
    required this.currentMemberIds,
    required this.currency,
  });

  final SplitBill bill;
  final Map<String, String> names;
  final bool isPayer;
  final Set<String> currentMemberIds;
  final AppCurrency currency;

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    String userId,
    PaymentStatus status,
  ) async {
    final actorId = ref.read(authRepositoryProvider).currentUser?.uid;
    await ref
        .read(splitBillControllerProvider.notifier)
        .updateShareStatus(
          groupId: bill.groupId,
          billId: bill.id,
          userId: userId,
          status: status,
          actorId: actorId,
          payerId: bill.paidBy,
        );

    final error = ref.read(splitBillControllerProvider).error;
    if (error != null && context.mounted) {
      CommonSnackbar.showError(context, 'Failed to update status: $error');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final owerShares = bill.shares
        .where((s) => s.userId != bill.paidBy)
        .toList();
    if (owerShares.isEmpty) return const SizedBox.shrink();

    final pendingCount = owerShares
        .where((s) => s.status == PaymentStatus.markedPaid)
        .length;

    return _SectionCard(
      title: 'Payment status',
      icon: Icons.fact_check_rounded,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CountPill(count: owerShares.length),
          if (isPayer && pendingCount > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$pendingCount awaiting review',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.warning,
                ),
              ),
            ),
          ],
        ],
      ),
      child: _ScrollablePanel(
        itemCount: owerShares.length,
        itemBuilder: (context, i) {
          final share = owerShares[i];
          return _ShareStatusRow(
            share: share,
            name: names[share.userId] ?? '...',
            currency: currency,
            isFormerMember: !currentMemberIds.contains(share.userId),
            canAct: isPayer && share.status == PaymentStatus.markedPaid,
            onConfirm: () => _updateStatus(
              context,
              ref,
              share.userId,
              PaymentStatus.confirmed,
            ),
            onDispute: () => _updateStatus(
              context,
              ref,
              share.userId,
              PaymentStatus.disputed,
            ),
          );
        },
      ),
    );
  }
}

/// Single row inside the payment status panel. No border of its own —
/// separation comes from the panel's Divider — so it reads as one
/// continuous list rather than stacked cards.
class _ShareStatusRow extends StatelessWidget {
  const _ShareStatusRow({
    required this.share,
    required this.name,
    required this.canAct,
    required this.onConfirm,
    required this.onDispute,
    required this.currency,
    this.isFormerMember = false,
  });

  final BillShare share;
  final String name;
  final bool canAct;
  final VoidCallback onConfirm;
  final VoidCallback onDispute;
  final AppCurrency currency;
  final bool isFormerMember;

  (String, Color) _statusMeta(AppColorsExt colors) {
    switch (share.status) {
      case PaymentStatus.unpaid:
        return ('Unpaid', colors.textSecondary);
      case PaymentStatus.markedPaid:
        return ('Says paid — review', colors.warning);
      case PaymentStatus.confirmed:
        return ('Confirmed', colors.primary);
      case PaymentStatus.disputed:
        return ('Disputed', colors.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final (label, color) = _statusMeta(colors);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isFormerMember) const _FormerMemberBadge(),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${currency.symbol}${share.amountOwed.toStringAsFixed(2)} · $label',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          if (canAct) ...[
            IconButton(
              icon: Icon(
                Icons.check_circle_outline_rounded,
                color: colors.primary,
              ),
              tooltip: 'Confirm',
              visualDensity: VisualDensity.compact,
              onPressed: onConfirm,
            ),
            IconButton(
              icon: Icon(Icons.cancel_outlined, color: colors.error),
              tooltip: 'Decline',
              visualDensity: VisualDensity.compact,
              onPressed: onDispute,
            ),
          ],
        ],
      ),
    );
  }
}
