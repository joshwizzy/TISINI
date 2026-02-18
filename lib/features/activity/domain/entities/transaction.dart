import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required PaymentType type,
    required TransactionDirection direction,
    required PaymentStatus status,
    required double amount,
    required String currency,
    required String counterpartyName,
    required String counterpartyIdentifier,
    required TransactionCategory category,
    required PaymentRail rail,
    required DateTime createdAt,
    MerchantRole? merchantRole,
    String? note,
    double? fee,
  }) = _Transaction;
}
