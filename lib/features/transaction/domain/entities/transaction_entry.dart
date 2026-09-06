class TransactionEntry {
  const TransactionEntry({
    required this.id,
    required this.categoryId,
    required this.amount,
    this.note,
    required this.date,
    required this.createdAt,
    this.updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
  });

  final String id;
  final String categoryId;
  final double amount;
  final String? note;
  final DateTime date;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool isDeleted;

  TransactionEntry copyWith({
    String? id,
    String? categoryId,
    double? amount,
    String? note,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return TransactionEntry(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}