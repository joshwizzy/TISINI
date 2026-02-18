import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';

part 'payment_receipt_model.freezed.dart';
part 'payment_receipt_model.g.dart';

@freezed
class PaymentReceiptModel with _$PaymentReceiptModel {
  const factory PaymentReceiptModel({
    @JsonKey(name: 'transaction_id') required String transactionId,
    @JsonKey(name: 'receipt_number') required String receiptNumber,
    required String type,
    required String status,
    required double amount,
    required String currency,
    required double fee,
    required double total,
    required String rail,
    @JsonKey(name: 'payee_name') required String payeeName,
    @JsonKey(name: 'payee_identifier') required String payeeIdentifier,
    required int timestamp,
    String? reference,
  }) = _PaymentReceiptModel;

  const PaymentReceiptModel._();

  factory PaymentReceiptModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentReceiptModelFromJson(json);

  PaymentReceipt toEntity() => PaymentReceipt(
    transactionId: transactionId,
    receiptNumber: receiptNumber,
    type: _parsePaymentType(type),
    status: _parseStatus(status),
    amount: amount,
    currency: currency,
    fee: fee,
    total: total,
    rail: _parseRail(rail),
    payeeName: payeeName,
    payeeIdentifier: payeeIdentifier,
    timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
    reference: reference,
  );

  static PaymentType _parsePaymentType(String type) {
    return switch (type) {
      'send' => PaymentType.send,
      'request' => PaymentType.request,
      'scan_pay' => PaymentType.scanPay,
      'business_pay' => PaymentType.businessPay,
      'top_up' => PaymentType.topUp,
      'pension_contribution' => PaymentType.pensionContribution,
      _ => PaymentType.send,
    };
  }

  static PaymentStatus _parseStatus(String status) {
    return switch (status) {
      'pending' => PaymentStatus.pending,
      'processing' => PaymentStatus.processing,
      'completed' => PaymentStatus.completed,
      'failed' => PaymentStatus.failed,
      'reversed' => PaymentStatus.reversed,
      _ => PaymentStatus.pending,
    };
  }

  static PaymentRail _parseRail(String rail) {
    return switch (rail) {
      'bank' => PaymentRail.bank,
      'mobile_money' => PaymentRail.mobileMoney,
      'card' => PaymentRail.card,
      'wallet' => PaymentRail.wallet,
      _ => PaymentRail.mobileMoney,
    };
  }
}
