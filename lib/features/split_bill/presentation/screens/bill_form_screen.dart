import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
    ).then((entries) {
      if (!mounted) return;
      setState(() {
        _resolvedNames.addEntries(entries);
        _namesBeingResolved.removeAll(missing);
      });
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
    final namesAsync = ref.watch(groupMemberNamesProvider(widget.group.id));
    final groupNames = namesAsync.value ?? {};
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

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_isEditingExisting && !canEdit)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Only the person who paid can edit this bill.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              AbsorbPointer(
                absorbing: !canEdit,
                child: Opacity(
                  opacity: canEdit ? 1 : 0.6,
                  child: Column(
                    // Matches ExpenseFormScreen / IncomeFormScreen: labels and
                    // controls start-aligned instead of the default centered
                    // Column cross-axis.
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
                      CommonTextField(
                        controller: _totalController,
                        icon: Icons.attach_money_rounded,
                        hint: '0.00',
                        label: 'Total amount',
                        validator: (v) {
                          final val = double.tryParse(v ?? '');
                          if (val == null || val <= 0) {
                            return 'Enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Paid by',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      _PaidByField(
                        value: _paidBy,
                        names: names,
                        memberIds: _participantIds,
                        // Payer is fixed once a bill exists — reassigning it
                        // would invalidate how shares were computed.
                        onChanged: _isEditingExisting
                            ? null
                            : (val) => setState(() => _paidBy = val),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Split',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 12),
                      if (_splitType == SplitType.equal)
                        ...others.map(
                          (id) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _SharePreviewRow(
                              name: names[id] ?? '...',
                              amount: equalPreview[id] ?? 0,
                              isFormerMember: !currentMemberIds.contains(id),
                            ),
                          ),
                        )
                      else
                        ...others.map(
                          (id) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _CustomShareField(
                              name: names[id] ?? '...',
                              controller: _customControllers[id]!,
                              isFormerMember: !currentMemberIds.contains(id),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Per-member payment status + payer confirm/decline actions.
              // Lives here rather than on the bill card since it needs to
              // scale to any number of members.
              if (_isEditingExisting && liveBill != null) ...[
                const SizedBox(height: 24),
                _PaymentStatusSection(
                  bill: liveBill,
                  names: names,
                  isPayer: canEdit,
                  currentMemberIds: currentMemberIds,
                ),
              ],
              if (canEdit) ...[
                const SizedBox(height: 28),
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

/// Read-only equal-split preview row, styled like RecurringIncomeRow's
/// bordered list rows.
class _SharePreviewRow extends StatelessWidget {
  const _SharePreviewRow({
    required this.name,
    required this.amount,
    this.isFormerMember = false,
  });

  final String name;
  final double amount;
  final bool isFormerMember;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
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
            '₱${amount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// Editable custom-split amount row — same bordered shell as
/// _SharePreviewRow, with a compact inline text field instead of a static
/// amount, so equal/custom modes read as the same component.
class _CustomShareField extends StatelessWidget {
  const _CustomShareField({
    required this.name,
    required this.controller,
    this.isFormerMember = false,
  });

  final String name;
  final TextEditingController controller;
  final bool isFormerMember;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
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
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                prefixText: '₱',
                prefixStyle: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                hintText: '0.00',
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
/// Wrapped in a bordered, primary-tinted "panel" (matching the info card
/// style used in IncomeFormScreen) with a capped height. Once the member
/// count exceeds what fits comfortably, the panel scrolls internally
/// instead of pushing the Save/Delete buttons further and further down —
/// keeps the form height predictable regardless of group size.
class _PaymentStatusSection extends ConsumerWidget {
  const _PaymentStatusSection({
    required this.bill,
    required this.names,
    required this.isPayer,
    required this.currentMemberIds,
  });

  final SplitBill bill;
  final Map<String, String> names;
  final bool isPayer;
  final Set<String> currentMemberIds;

  static const _maxPanelHeight = 260.0;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Payment status',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${owerShares.length}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
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
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: _maxPanelHeight),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          clipBehavior: Clip.antiAlias,
          child: Scrollbar(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              shrinkWrap: true,
              itemCount: owerShares.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                indent: 14,
                endIndent: 14,
                color: AppColors.primary.withValues(alpha: 0.10),
              ),
              itemBuilder: (context, i) {
                final share = owerShares[i];
                return _ShareStatusRow(
                  share: share,
                  name: names[share.userId] ?? '...',
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
          ),
        ),
      ],
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
    this.isFormerMember = false,
  });

  final BillShare share;
  final String name;
  final bool canAct;
  final VoidCallback onConfirm;
  final VoidCallback onDispute;
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
                  '₱${share.amountOwed.toStringAsFixed(2)} · $label',
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
