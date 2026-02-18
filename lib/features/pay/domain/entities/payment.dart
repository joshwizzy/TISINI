import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';

part 'payment.freezed.dart';

@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required PaymentType type,
    required PaymentStatus status,
    required TransactionDirection direction,
    required double amount,
    required String currency,
    required PaymentRail rail,
    required Payee payee,
    required double fee,
    required double total,
    required TransactionCategory category,
    required DateTime createdAt,
    String? reference,
    String? note,
    DateTime? completedAt,
  }) = _Payment;
}
