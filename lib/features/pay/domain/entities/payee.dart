import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'payee.freezed.dart';

@freezed
class Payee with _$Payee {
  const factory Payee({
    required String id,
    required String name,
    required String identifier,
    required PaymentRail rail,
    required bool isPinned,
    String? avatarUrl,
    MerchantRole? role,
    DateTime? lastPaidAt,
  }) = _Payee;
}
