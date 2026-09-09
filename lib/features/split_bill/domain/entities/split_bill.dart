// lib/features/split_bill/domain/entities/split_bill.dart
import 'package:salapify/features/split_bill/domain/entities/bill_share.dart';
import 'package:salapify/features/split_bill/domain/entities/split_type.dart';

class SplitBill {
  const SplitBill({
    required this.id,
    required this.groupId,
    required this.title,
    required this.totalAmount,
    required this.paidBy,
    required this.splitType,
    required this.shares,
    required this.createdAt,
  });

  final String id;
  final String groupId;
  final String title; // e.g. "Dinner @ KFC"
  final double totalAmount;
  final String paidBy; // userId
  final SplitType splitType;
  final List<BillShare> shares; // excludes the payer themself
  final DateTime createdAt;

  SplitBill copyWith({
    String? id,
    String? groupId,
    String? title,
    double? totalAmount,
    String? paidBy,
    SplitType? splitType,
    List<BillShare>? shares,
    DateTime? createdAt,
  }) {
    return SplitBill(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      totalAmount: totalAmount ?? this.totalAmount,
      paidBy: paidBy ?? this.paidBy,
      splitType: splitType ?? this.splitType,
      shares: shares ?? this.shares,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}