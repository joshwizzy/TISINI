import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_request.dart';

part 'payment_request_model.freezed.dart';
part 'payment_request_model.g.dart';

@freezed
class PaymentRequestModel with _$PaymentRequestModel {
  const factory PaymentRequestModel({
    required String id,
    required double amount,
    required String currency,
    @JsonKey(name: 'share_link') required String shareLink,
    required String status,
    @JsonKey(name: 'created_at') required int createdAt,
    String? note,
    @JsonKey(name: 'paid_at') int? paidAt,
  }) = _PaymentRequestModel;

  const PaymentRequestModel._();

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestModelFromJson(json);

  PaymentRequest toEntity() => PaymentRequest(
    id: id,
    amount: amount,
    currency: currency,
    shareLink: shareLink,
    status: _parseStatus(status),
    createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    note: note,
    paidAt: paidAt != null
        ? DateTime.fromMillisecondsSinceEpoch(paidAt!)
        : null,
  );

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
}
