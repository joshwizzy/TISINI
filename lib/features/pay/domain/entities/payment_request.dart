import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'payment_request.freezed.dart';

@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required String id,
    required double amount,
    required String currency,
    required String shareLink,
    required PaymentStatus status,
    required DateTime createdAt,
    String? note,
    DateTime? paidAt,
  }) = _PaymentRequest;
}
