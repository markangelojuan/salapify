// lib/features/split_bill/domain/entities/payment_status.dart
enum PaymentStatus {
  unpaid,       // default state
  markedPaid,   // ower says "I paid"
  confirmed,    // payer confirmed receipt
  disputed,     // payer says "I didn't receive this"
}