import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';

part 'payment_route_model.freezed.dart';
part 'payment_route_model.g.dart';

@freezed
class PaymentRouteModel with _$PaymentRouteModel {
  const factory PaymentRouteModel({
    required String rail,
    required String label,
    @JsonKey(name: 'is_available') required bool isAvailable,
    double? fee,
    @JsonKey(name: 'estimated_time') String? estimatedTime,
  }) = _PaymentRouteModel;

  const PaymentRouteModel._();

  factory PaymentRouteModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentRouteModelFromJson(json);

  PaymentRoute toEntity() => PaymentRoute(
    rail: _parseRail(rail),
    label: label,
    isAvailable: isAvailable,
    fee: fee,
    estimatedTime: estimatedTime,
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
}
