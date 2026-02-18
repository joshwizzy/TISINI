import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String type,
    required String direction,
    required String status,
    required double amount,
    required String currency,
    @JsonKey(name: 'counterparty_name') required String counterpartyName,
    @JsonKey(name: 'counterparty_identifier')
    required String counterpartyIdentifier,
    required String category,
    required String rail,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'merchant_role') String? merchantRole,
    String? note,
    double? fee,
  }) = _TransactionModel;

  const TransactionModel._();

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Transaction toEntity() => Transaction(
    id: id,
    type: _parsePaymentType(type),
    direction: _parseDirection(direction),
    status: _parseStatus(status),
    amount: amount,
    currency: currency,
    counterpartyName: counterpartyName,
    counterpartyIdentifier: counterpartyIdentifier,
    category: _parseCategory(category),
    rail: _parseRail(rail),
    createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    merchantRole: merchantRole != null
        ? _parseMerchantRole(merchantRole!)
        : null,
    note: note,
    fee: fee,
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

  static TransactionDirection _parseDirection(String direction) {
    return switch (direction) {
      'inbound' => TransactionDirection.inbound,
      'outbound' => TransactionDirection.outbound,
      _ => TransactionDirection.outbound,
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

  static PaymentRail _parseRail(String rail) {
    return switch (rail) {
      'bank' => PaymentRail.bank,
      'mobile_money' => PaymentRail.mobileMoney,
      'card' => PaymentRail.card,
      'wallet' => PaymentRail.wallet,
      _ => PaymentRail.mobileMoney,
    };
  }

  static MerchantRole _parseMerchantRole(String role) {
    return switch (role) {
      'supplier' => MerchantRole.supplier,
      'rent' => MerchantRole.rent,
      'wages' => MerchantRole.wages,
      'tax' => MerchantRole.tax,
      'pension' => MerchantRole.pension,
      'utilities' => MerchantRole.utilities,
      _ => MerchantRole.supplier,
    };
  }
}
