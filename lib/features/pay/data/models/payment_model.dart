import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/data/models/payee_model.dart';
import 'package:tisini/features/pay/domain/entities/payment.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String type,
    required String status,
    required String direction,
    required double amount,
    required String currency,
    required String rail,
    required PayeeModel payee,
    required double fee,
    required double total,
    required String category,
    @JsonKey(name: 'created_at') required int createdAt,
    String? reference,
    String? note,
    @JsonKey(name: 'completed_at') int? completedAt,
  }) = _PaymentModel;

  const PaymentModel._();

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Payment toEntity() => Payment(
    id: id,
    type: _parsePaymentType(type),
    status: _parseStatus(status),
    direction: _parseDirection(direction),
    amount: amount,
    currency: currency,
    rail: _parseRail(rail),
    payee: payee.toEntity(),
    fee: fee,
    total: total,
    category: _parseCategory(category),
    createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    reference: reference,
    note: note,
    completedAt: completedAt != null
        ? DateTime.fromMillisecondsSinceEpoch(completedAt!)
        : null,
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

  static TransactionDirection _parseDirection(String direction) {
    return switch (direction) {
      'inbound' => TransactionDirection.inbound,
      'outbound' => TransactionDirection.outbound,
      _ => TransactionDirection.outbound,
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

  static TransactionCategory _parseCategory(String category) {
    return switch (category) {
      'sales' => TransactionCategory.sales,
      'inventory' => TransactionCategory.inventory,
      'bills' => TransactionCategory.bills,
      'people' => TransactionCategory.people,
      'compliance' => TransactionCategory.compliance,
      'agency' => TransactionCategory.agency,
      'uncategorised' => TransactionCategory.uncategorised,
      _ => TransactionCategory.uncategorised,
    };
  }
}
