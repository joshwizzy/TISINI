import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';

part 'payee_model.freezed.dart';
part 'payee_model.g.dart';

@freezed
class PayeeModel with _$PayeeModel {
  const factory PayeeModel({
    required String id,
    required String name,
    required String identifier,
    required String rail,
    @JsonKey(name: 'is_pinned') required bool isPinned,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'merchant_role') String? merchantRole,
    @JsonKey(name: 'last_paid_at') int? lastPaidAt,
  }) = _PayeeModel;

  const PayeeModel._();

  factory PayeeModel.fromJson(Map<String, dynamic> json) =>
      _$PayeeModelFromJson(json);

  Payee toEntity() => Payee(
    id: id,
    name: name,
    identifier: identifier,
    rail: _parseRail(rail),
    isPinned: isPinned,
    avatarUrl: avatarUrl,
    role: merchantRole != null ? _parseMerchantRole(merchantRole!) : null,
    lastPaidAt: lastPaidAt != null
        ? DateTime.fromMillisecondsSinceEpoch(lastPaidAt!)
        : null,
  );

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
