import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';

part 'funding_source_model.freezed.dart';
part 'funding_source_model.g.dart';

@freezed
class FundingSourceModel with _$FundingSourceModel {
  const factory FundingSourceModel({
    required String rail,
    required String label,
    required String identifier,
    @JsonKey(name: 'is_available') required bool isAvailable,
  }) = _FundingSourceModel;

  const FundingSourceModel._();

  factory FundingSourceModel.fromJson(Map<String, dynamic> json) =>
      _$FundingSourceModelFromJson(json);

  FundingSource toEntity() => FundingSource(
    rail: _parseRail(rail),
    label: label,
    identifier: identifier,
    isAvailable: isAvailable,
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
