import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'payment_receipt.freezed.dart';

@freezed
class PaymentReceipt with _$PaymentReceipt {
  const factory PaymentReceipt({
    required String transactionId,
    required String receiptNumber,
    required PaymentType type,
    required PaymentStatus status,
    required double amount,
    required String currency,
    required double fee,
    required double total,
    required PaymentRail rail,
    required String payeeName,
    required String payeeIdentifier,
    required DateTime timestamp,
    String? reference,
  }) = _PaymentReceipt;
}
