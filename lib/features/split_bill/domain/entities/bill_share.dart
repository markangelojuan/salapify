// lib/features/split_bill/domain/entities/bill_share.dart
import 'package:salapify/features/split_bill/domain/entities/payment_status.dart';

class BillShare {
  const BillShare({
    required this.userId,
    required this.amountOwed,
    this.status = PaymentStatus.unpaid,
    this.statusUpdatedAt,
  });

  final String userId;
  final double amountOwed;
  final PaymentStatus status;
  final DateTime? statusUpdatedAt;

  BillShare copyWith({
    String? userId,
    double? amountOwed,
    PaymentStatus? status,
    DateTime? statusUpdatedAt,
  }) {
    return BillShare(
      userId: userId ?? this.userId,
      amountOwed: amountOwed ?? this.amountOwed,
      status: status ?? this.status,
      statusUpdatedAt: statusUpdatedAt ?? this.statusUpdatedAt,
    );
  }
}