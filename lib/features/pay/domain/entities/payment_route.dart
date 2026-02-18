import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'payment_route.freezed.dart';

@freezed
class PaymentRoute with _$PaymentRoute {
  const factory PaymentRoute({
    required PaymentRail rail,
    required String label,
    required bool isAvailable,
    double? fee,
    String? estimatedTime,
  }) = _PaymentRoute;
}
