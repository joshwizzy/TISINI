import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/home/domain/entities/tisini_index.dart';

part 'tisini_index_model.freezed.dart';
part 'tisini_index_model.g.dart';

@freezed
class TisiniIndexModel with _$TisiniIndexModel {
  const factory TisiniIndexModel({
    required int score,
    @JsonKey(name: 'payment_consistency') required int paymentConsistency,
    @JsonKey(name: 'compliance_readiness') required int complianceReadiness,
    @JsonKey(name: 'business_momentum') required int businessMomentum,
    @JsonKey(name: 'data_completeness') required int dataCompleteness,
    @JsonKey(name: 'change_reason') required String changeReason,
    @JsonKey(name: 'change_amount') required double changeAmount,
    @JsonKey(name: 'updated_at') required int updatedAt,
  }) = _TisiniIndexModel;

  const TisiniIndexModel._();

  factory TisiniIndexModel.fromJson(Map<String, dynamic> json) =>
      _$TisiniIndexModelFromJson(json);

  TisiniIndex toEntity() => TisiniIndex(
    score: score,
    paymentConsistency: paymentConsistency,
    complianceReadiness: complianceReadiness,
    businessMomentum: businessMomentum,
    dataCompleteness: dataCompleteness,
    changeReason: changeReason,
    changeAmount: changeAmount,
    updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
  );
}
