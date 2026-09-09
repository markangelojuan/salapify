import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/split_bill/domain/entities/activity_entry.dart';
import 'package:salapify/features/split_bill/domain/entities/bill_share.dart';
import 'package:salapify/features/split_bill/domain/entities/payment_status.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';
import 'package:salapify/features/split_bill/domain/split_balance_calculator.dart';
import 'package:salapify/features/split_bill/presentation/controllers/split_bill_controller.dart';
import 'package:salapify/router/routes.dart';
import 'package:salapify/features/split_bill/presentation/screens/bill_form_screen.dart';

class SplitGroupDetailScreen extends ConsumerStatefulWidget {
  const SplitGroupDetailScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<SplitGroupDetailScreen> createState() =>
      _SplitGroupDetailScreenState();
}

class _SplitGroupDetailScreenState
    extends ConsumerState<SplitGroupDetailScreen> {
  final _messageController = TextEditingController();
  final _currency = NumberFormat.currency(symbol: '₱', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    // Clear this user's unread badge for the group now that they're
    // viewing it. Doesn't affect the controller's `state`
    ref.read(splitBillControllerProvider.notifier).markGroupRead(widget.groupId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    await ref
        .read(splitBillControllerProvider.notifier)
        .sendMessage(groupId: widget.groupId, text: text);
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(splitGroupProvider(widget.groupId));

    return groupAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Failed to load group: $err')),
      ),
      data: (group) {
        if (group == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Group not found')),
          );
        }
        return _buildScaffold(context, group);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, SplitGroup group) {
    final billsAsync = ref.watch(splitBillsProvider(group.id));
    final activityAsync = ref.watch(splitActivityProvider(group.id));
    final namesAsync = ref.watch(groupMemberNamesProvider(group.id));
    final currentUid = ref.watch(currentUserProvider)?.uid;

    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: SafeArea(
        child: billsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Failed to load bills: $err')),
          data: (bills) {
            final names = namesAsync.value ?? {};

            return Column(
              children: [
                _BalanceSummary(
                  bills: bills,
                  currentUid: currentUid,
                  currency: _currency,
                ),
                const SizedBox(height: 12),
                _BillsCarousel(
                  bills: bills,
                  group: group,
                  currentUid: currentUid,
                  names: names,
                  currency: _currency,
                ),
                Divider(
                  height: 24,
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: activityAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text('$err')),
                    data: (activity) => _ActivityFeed(
                      activity: activity,
                      currentUid: currentUid,
                      names: names,
                    ),
                  ),
                ),
                _MessageInput(
                  controller: _messageController,
                  onSend: _sendMessage,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BalanceSummary extends StatelessWidget {
  const _BalanceSummary({
    required this.bills,
    required this.currentUid,
    required this.currency,
  });

  final List<SplitBill> bills;
  final String? currentUid;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    if (currentUid == null) return const SizedBox.shrink();

    final balances = SplitBalanceCalculator.forUser(bills, currentUid!);
    final totalYouOwe = balances.youOwe.fold<double>(0, (a, b) => a + b.amount);
    final totalOwedToYou = balances.owedToYou.fold<double>(
      0,
      (a, b) => a + b.amount,
    );

    final settled = totalYouOwe == 0 && totalOwedToYou == 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.10),
            AppColors.primary.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: settled
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.celebration_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'All settled up',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _BalanceItem(
                    icon: Icons.south_west_rounded,
                    label: 'Owed to you',
                    amount: currency.format(totalOwedToYou),
                    color: Colors.green[700]!,
                  ),
                ),
                Container(
                  width: 1,
                  height: 44,
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
                Expanded(
                  child: _BalanceItem(
                    icon: Icons.north_east_rounded,
                    label: 'You owe',
                    amount: currency.format(totalYouOwe),
                    color: Colors.red[600]!,
                  ),
                ),
              ],
            ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  const _BalanceItem({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _BillsCarousel extends ConsumerWidget {
  const _BillsCarousel({
    required this.bills,
    required this.group,
    required this.currentUid,
    required this.names,
    required this.currency,
  });

  final List<SplitBill> bills;
  final SplitGroup group;
  final String? currentUid;
  final Map<String, String> names;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: bills.length + 1,
        itemBuilder: (context, index) {
          if (index == bills.length) {
            return _AddBillCard(group: group);
          }
          final bill = bills[index];
          return _BillCard(
            bill: bill,
            group: group,
            currentUid: currentUid,
            names: names,
            currency: currency,
          );
        },
      ),
    );
  }
}

class _AddBillCard extends StatelessWidget {
  const _AddBillCard({required this.group});

  final SplitGroup group;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.pushNamed(
            AppRoutes.billForm.name,
            extra: BillFormArgs(group: group),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    size: 28,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add Bill',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BillCard extends ConsumerWidget {
  const _BillCard({
    required this.bill,
    required this.group,
    required this.currentUid,
    required this.names,
    required this.currency,
  });

  final SplitBill bill;
  final SplitGroup group;
  final String? currentUid;
  final Map<String, String> names;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPayer = bill.paidBy == currentUid;
    final myShare = bill.shares.firstWhereOrNull((s) => s.userId == currentUid);

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => context.pushNamed(
            AppRoutes.billForm.name,
            extra: BillFormArgs(group: group, existingBill: bill),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.15,
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bill.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Total ${currency.format(bill.totalAmount)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Paid by ${isPayer ? "you" : (names[bill.paidBy] ?? '...')}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
                const Spacer(),
                if (isPayer)
                  _buildPayerStatusRow(context)
                else if (myShare != null)
                  _buildOwerRow(context, ref, myShare),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPayerStatusRow(BuildContext context) {
    final total = bill.shares.length;
    final confirmed = bill.shares
        .where((s) => s.status == PaymentStatus.confirmed)
        .length;
    final disputed = bill.shares
        .where((s) => s.status == PaymentStatus.disputed)
        .length;
    final pendingConfirmation = bill.shares
        .where((s) => s.status == PaymentStatus.markedPaid)
        .length;

    Widget label(String text, Color color) => Text(
      text,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (confirmed == total) {
      return label('All confirmed', Colors.green[700]!);
    }
    if (disputed > 0) {
      return label('$disputed disputed — tap to review', Colors.red[600]!);
    }
    if (pendingConfirmation > 0) {
      return label('$pendingConfirmation waiting on you', Colors.orange[700]!);
    }
    return Text(
      'Waiting on payments',
      style: TextStyle(
        fontSize: 11,
        color: AppColors.textPrimary.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildOwerRow(BuildContext context, WidgetRef ref, BillShare share) {
    final status = share.status;
    final amount = share.amountOwed;

    if (status == PaymentStatus.confirmed) {
      return const _StatusPill(label: 'Settled', color: Colors.green);
    }
    if (status == PaymentStatus.disputed) {
      return Row(
        children: [
          const Expanded(
            child: _StatusPill(label: 'Disputed — recheck', color: Colors.red),
          ),
        ],
      );
    }
    if (status == PaymentStatus.markedPaid) {
      return Text(
        'Waiting on confirmation',
        style: TextStyle(
          fontSize: 11,
          color: AppColors.textPrimary.withValues(alpha: 0.6),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    // unpaid
    return Row(
      children: [
        Expanded(
          child: Text(
            'You owe ${currency.format(amount)}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            foregroundColor: AppColors.primary,
          ),
          onPressed: () => ref
              .read(splitBillControllerProvider.notifier)
              .updateShareStatus(
                groupId: bill.groupId,
                billId: bill.id,
                userId: currentUid!,
                status: PaymentStatus.markedPaid,
              ),
          child: const Text(
            'Mark paid',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/// Small status pill matching the app's chip language (_TypeChip,
/// category picker chips) instead of bare colored text.
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    final shade = color[700]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: shade,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ActivityFeed extends StatelessWidget {
  const _ActivityFeed({
    required this.activity,
    required this.currentUid,
    required this.names,
  });

  final List<ActivityEntry> activity;
  final String? currentUid;
  final Map<String, String> names;

  String _label(ActivityEntry entry) {
    final senderName = names[entry.senderId] ?? '...';
    switch (entry.type) {
      case ActivityType.message:
        return entry.text ?? '';
      case ActivityType.billAdded:
        final title = entry.metadata?['billTitle'] ?? 'a bill';
        final amount = entry.metadata?['amount'];
        return '$senderName added "$title"${amount != null ? ' — ₱$amount' : ''}';
      case ActivityType.paymentMarked:
        return '$senderName marked their share as paid';
      case ActivityType.paymentConfirmed:
        {
          final targetId = entry.metadata?['targetUserId'] as String?;
          final targetName = targetId != null
              ? (names[targetId] ?? '...')
              : null;
          return targetName != null
              ? '$senderName confirmed $targetName\'s payment'
              : '$senderName confirmed a payment';
        }
      case ActivityType.paymentDisputed:
        {
          final targetId = entry.metadata?['targetUserId'] as String?;
          final targetName = targetId != null
              ? (names[targetId] ?? '...')
              : null;
          return targetName != null
              ? '$senderName disputed $targetName\'s payment'
              : '$senderName disputed a payment';
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (activity.isEmpty) {
      return Center(
        child: Text(
          'No activity yet',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: activity.length,
      itemBuilder: (context, index) {
        final entry = activity[index];
        final isMine = entry.senderId == currentUid;
        final isMessage = entry.type == ActivityType.message;

        if (!isMessage) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Center(
              child: _SystemActivityPill(
                type: entry.type,
                label: _label(entry),
              ),
            ),
          );
        }

        final senderName = names[entry.senderId] ?? '...';

        return Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: isMine
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMine)
                  Text(
                    senderName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                Text(_label(entry), style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Icon-badged pill for non-message activity (bill added, payment
/// marked/confirmed/disputed), replacing bare centered gray text with the
/// app's chip/pill language so system events read as distinct events.
class _SystemActivityPill extends StatelessWidget {
  const _SystemActivityPill({required this.type, required this.label});

  final ActivityType type;
  final String label;

  (IconData, Color) get _iconAndColor {
    switch (type) {
      case ActivityType.billAdded:
        return (Icons.receipt_long_rounded, AppColors.primary);
      case ActivityType.paymentMarked:
        return (Icons.hourglass_top_rounded, Colors.orange[700]!);
      case ActivityType.paymentConfirmed:
        return (Icons.check_circle_rounded, Colors.green[700]!);
      case ActivityType.paymentDisputed:
        return (Icons.error_rounded, Colors.red[600]!);
      case ActivityType.message:
        return (Icons.chat_bubble_rounded, AppColors.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _iconAndColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Message the group...',
                hintStyle: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: AppColors.primary.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: AppColors.primary),
            icon: const Icon(Icons.send_rounded, color: Colors.white),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}