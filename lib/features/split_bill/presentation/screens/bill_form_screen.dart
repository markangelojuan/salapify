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
import 'package:salapify/features/split_bill/domain/split_balance_calculator.dart';
import 'package:salapify/features/split_bill/presentation/controllers/split_bill_controller.dart';
import 'package:salapify/features/split_bill/domain/entities/payment_status.dart';
import 'package:salapify/features/settings/domain/currency.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';

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

  // groupMemberNamesProvider only knows CURRENT group members. A bill can
  // reference someone who has since left the group, so we resolve those
  // names separately here instead of showing '...' for them forever.
  final Map<String, String> _resolvedNames = {};
  final Set<String> _namesBeingResolved = {};

  bool get _isEditingExisting => widget.existingBill != null;

  /// Only the person who paid for the bill can edit or delete it.
  /// New bills are always editable (there's nothing to protect yet).
  bool get _canEdit {
    if (widget.existingBill == null) return true;
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    return widget.existingBill!.paidBy == uid;
  }

  /// Everyone this bill actually involves — the payer plus everyone with a
  /// share. For an existing bill this is locked to its saved `shares`, so
  /// editing a bill (even just fixing a typo) never silently pulls in
  /// members added to the group afterward, and never drops a share for
  /// someone since removed from the group. Only a brand-new bill uses
  /// current group membership.
  List<String> get _participantIds {
    final existing = widget.existingBill;
    if (existing != null) {
      return {
        existing.paidBy,
        ...existing.shares.map((s) => s.userId),
      }.toList();
    }
    return widget.group.memberIds;
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

    if (_splitType == SplitType.custom) {
      final sum = shares.values.fold<double>(0, (a, b) => a + b);
      if ((sum - _total).abs() > 0.01) {
        // Custom split is intentionally free-form — warn but don't block save.
        CommonSnackbar.showWarning(
          context,
          'Shares add up to ${sum.toStringAsFixed(2)}, but total is ${_total.toStringAsFixed(2)}',
        );
      }
    }

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
      CommonSnackbar.showError(context, 'Failed to save bill: $error');
      return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this bill?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currency =
        ref.watch(currencySettingProvider).value ?? AppCurrency.php;
    final membersAsync = ref.watch(groupMembersProvider(widget.group.id));
    final groupNames = {
      for (final e in (membersAsync.value ?? {}).entries)
        e.key: e.value.username,
    };
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
      backgroundColor: AppColors.background,
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
                              icon: Icons.receipt_long_rounded,
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
                                    color: AppColors.textPrimary.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Locked — payment activity exists',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textPrimary.withValues(
                                        alpha: 0.5,
                                      ),
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
                            Text(
                              'Paid by',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _PaidByField(
                              value: _paidBy,
                              names: names,
                              memberIds: _participantIds,
                              // Payer is fixed once a bill exists —
                              // reassigning it would invalidate how shares
                              // were computed.
                              onChanged: _isEditingExisting
                                  ? null
                                  : (val) => setState(() => _paidBy = val),
                            ),
                            const SizedBox(height: 18),
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
                  btnColor: AppColors.black,
                  labelColor: AppColors.white,
                  isLoading: _isSaving,
                  onPressed: () => _save(names),
                ),
                if (_isEditingExisting) ...[
                  const SizedBox(height: 12),
                  CommonButton(
                    label: 'Delete Bill',
                    btnColor: AppColors.white,
                    labelColor: Colors.red,
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

/// Rounded white "grouped card" shell used to give each form section
/// (bill details, split, payment status) a consistent, modern container
/// instead of loose fields floating directly on the screen background.
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                ],
                Text(
                  title!,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
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
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
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
            color: AppColors.primary.withValues(alpha: 0.10),
          ),
          itemBuilder: itemBuilder,
        ),
      ),
    );
  }
}

/// Restyled "view only" notice as a soft banner chip instead of bare
/// centered icon+text, matching the app's pill/banner language.
class _ReadOnlyBanner extends StatelessWidget {
  const _ReadOnlyBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.textPrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.textPrimary.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dropdown restyled to match the app's primary-tinted field containers
/// (see date fields in Expense/Income forms) instead of the default
/// Material DropdownButtonFormField underline style.
class _PaidByField extends StatelessWidget {
  const _PaidByField({
    required this.value,
    required this.names,
    required this.memberIds,
    required this.onChanged,
  });

  final String? value;
  final Map<String, String> names;
  final List<String> memberIds;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          initialValue: value,
          decoration: const InputDecoration(border: InputBorder.none),
          icon: Icon(
            Icons.expand_more_rounded,
            color: AppColors.primary.withValues(alpha: 0.7),
          ),
          onChanged: onChanged,
          items: memberIds
              .map(
                (id) => DropdownMenuItem(
                  value: id,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        names[id] ?? '...',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
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
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.textPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Former member',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary.withValues(alpha: 0.5),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
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
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
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
              color: AppColors.textPrimary.withValues(alpha: 0.6),
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
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
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

/// Per-member payment status list for an existing bill. Read-only for
/// everyone except the payer, who gets Confirm/Decline actions on any
/// share currently marked paid.
///
/// Uses the same _SectionCard shell as the fields above so the whole form
/// reads as one set of consistent grouped panels, and the same
/// _ScrollablePanel as the Split section so it scrolls internally instead
/// of pushing the Save/Delete buttons further down as group size grows.
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
                color: Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$pendingCount awaiting review',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.orange[700],
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

  (String, Color) get _statusMeta {
    switch (share.status) {
      case PaymentStatus.unpaid:
        return ('Unpaid', AppColors.textPrimary.withValues(alpha: 0.5));
      case PaymentStatus.markedPaid:
        return ('Says paid — review', Colors.orange[700]!);
      case PaymentStatus.confirmed:
        return ('Confirmed', Colors.green[700]!);
      case PaymentStatus.disputed:
        return ('Disputed', Colors.red[600]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, color) = _statusMeta;
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
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
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
              icon: const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
              ),
              tooltip: 'Confirm',
              visualDensity: VisualDensity.compact,
              onPressed: onConfirm,
            ),
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
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
