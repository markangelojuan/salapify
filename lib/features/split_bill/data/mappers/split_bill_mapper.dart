// lib/features/split_bill/data/mappers/split_bill_mapper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salapify/features/split_bill/data/mappers/bill_share_mapper.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill.dart';
import 'package:salapify/features/split_bill/domain/entities/split_type.dart';

extension SplitBillMapper on SplitBill {
  Map<String, dynamic> toFirestore() {
    return {
      'groupId': groupId,
      'title': title,
      'totalAmount': totalAmount,
      'paidBy': paidBy,
      'splitType': splitType.name,
      'shares': shares.map((s) => s.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static SplitBill fromFirestore(String id, Map<String, dynamic> data) {
    return SplitBill(
      id: id,
      groupId: data['groupId'] as String,
      title: data['title'] as String,
      totalAmount: (data['totalAmount'] as num).toDouble(),
      paidBy: data['paidBy'] as String,
      splitType: SplitType.values.byName(data['splitType'] as String),
      shares: (data['shares'] as List)
          .map((s) => BillShareMapper.fromMap(s as Map<String, dynamic>))
          .toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}