// lib/features/split_bill/data/mappers/bill_share_mapper.dart
import 'package:salapify/features/split_bill/domain/entities/bill_share.dart';
import 'package:salapify/features/split_bill/domain/entities/payment_status.dart';

extension BillShareMapper on BillShare {
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amountOwed': amountOwed,
      'status': status.name,
      'statusUpdatedAt': statusUpdatedAt?.toIso8601String(),
    };
  }

  static BillShare fromMap(Map<String, dynamic> data) {
    return BillShare(
      userId: data['userId'] as String,
      amountOwed: (data['amountOwed'] as num).toDouble(),
      status: PaymentStatus.values.byName(data['status'] as String),
      statusUpdatedAt: data['statusUpdatedAt'] != null
          ? DateTime.parse(data['statusUpdatedAt'] as String)
          : null,
    );
  }
}