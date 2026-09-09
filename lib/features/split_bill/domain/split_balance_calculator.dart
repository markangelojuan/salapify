// lib/features/split_bill/domain/split_balance_calculator.dart
import 'package:salapify/features/split_bill/domain/entities/payment_status.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill.dart';

/// A settled, one-directional balance: [fromUserId] owes [toUserId] [amount].
/// Only ever positive amounts — direction encodes who owes whom.
class NetBalance {
  const NetBalance({
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
  });

  final String fromUserId;
  final String toUserId;
  final double amount;
}

class SplitBalanceCalculator {
  /// Nets all unsettled shares across [bills] into pairwise balances.
  /// Only shares with status != confirmed count as still owed —
  /// confirmed payments are treated as settled and excluded.
  static List<NetBalance> calculate(List<SplitBill> bills) {
    // ledger[a][b] = how much `a` owes `b`, raw (pre-netting)
    final ledger = <String, Map<String, double>>{};

    void add(String from, String to, double amount) {
      if (from == to || amount <= 0) return;
      ledger.putIfAbsent(from, () => {});
      ledger[from]![to] = (ledger[from]![to] ?? 0) + amount;
    }

    for (final bill in bills) {
      for (final share in bill.shares) {
        if (share.status == PaymentStatus.confirmed) continue;
        add(share.userId, bill.paidBy, share.amountOwed);
      }
    }

    // Net each unordered pair (a, b) against each other.
    final seen = <String>{};
    final result = <NetBalance>[];

    for (final from in ledger.keys) {
      for (final to in ledger[from]!.keys) {
        final pairKey = ([from, to]..sort()).join('|');
        if (seen.contains(pairKey)) continue;
        seen.add(pairKey);

        final aOwesB = ledger[from]?[to] ?? 0;
        final bOwesA = ledger[to]?[from] ?? 0;
        final net = aOwesB - bOwesA;

        if (net > 0) {
          result.add(NetBalance(fromUserId: from, toUserId: to, amount: net));
        } else if (net < 0) {
          result.add(NetBalance(fromUserId: to, toUserId: from, amount: -net));
        }
        // net == 0 → fully settled between this pair, omit
      }
    }

    return result;
  }

  /// Convenience: balances involving [userId] only, split into
  /// "you owe" and "owed to you" for direct use in the summary card.
  static ({List<NetBalance> youOwe, List<NetBalance> owedToYou}) forUser(
    List<SplitBill> bills,
    String userId,
  ) {
    final all = calculate(bills);
    return (
      youOwe: all.where((b) => b.fromUserId == userId).toList(),
      owedToYou: all.where((b) => b.toUserId == userId).toList(),
    );
  }

  /// Equal-split helper: divides [totalAmount] among [memberIds] (excluding
  /// the payer), rounding remainders onto the last share so amounts always
  /// sum exactly to totalAmount minus the payer's own share.
  static Map<String, double> splitEqually({
    required double totalAmount,
    required List<String> memberIds, // all members including payer
    required String paidBy,
  }) {
    final others = memberIds.where((id) => id != paidBy).toList();
    if (others.isEmpty) return {};

    final perHead = totalAmount / memberIds.length;
    final rounded = double.parse(perHead.toStringAsFixed(2));

    final shares = <String, double>{};
    double runningTotal = 0;
    for (var i = 0; i < others.length; i++) {
      if (i == others.length - 1) {
        // last member absorbs rounding difference
        final remaining = double.parse(
          (perHead * others.length - runningTotal).toStringAsFixed(2),
        );
        shares[others[i]] = remaining;
      } else {
        shares[others[i]] = rounded;
        runningTotal += rounded;
      }
    }
    return shares;
  }
}