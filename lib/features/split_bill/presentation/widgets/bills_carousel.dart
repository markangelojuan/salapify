import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/split_bill/domain/entities/bill_share.dart';
import 'package:salapify/features/split_bill/domain/entities/payment_status.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';
import 'package:salapify/features/split_bill/presentation/controllers/split_bill_controller.dart';
import 'package:salapify/features/split_bill/presentation/screens/bill_form_screen.dart';
import 'package:salapify/router/routes.dart';

class BillsCarousel extends ConsumerWidget {
  const BillsCarousel({
    super.key,
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
          Expanded(
            child: Text(
              'Disputed',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.red[600],
              ),
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
                  payerId: bill.paidBy,
                ),
            child: const Text(
              'Mark paid again',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
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
                payerId: bill.paidBy,
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