import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/home/domain/entities/dashboard_indicator.dart';

part 'dashboard_indicator_model.freezed.dart';
part 'dashboard_indicator_model.g.dart';

@freezed
class DashboardIndicatorModel with _$DashboardIndicatorModel {
  const factory DashboardIndicatorModel({
    required String type,
    required String label,
    required int value,
    @JsonKey(name: 'max_value') required int maxValue,
    required double percentage,
  }) = _DashboardIndicatorModel;

  const DashboardIndicatorModel._();

  factory DashboardIndicatorModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardIndicatorModelFromJson(json);

  DashboardIndicator toEntity() => DashboardIndicator(
    type: _parseIndicatorType(type),
    label: label,
    value: value,
    maxValue: maxValue,
    percentage: percentage,
  );

  static IndicatorType _parseIndicatorType(String type) {
    return switch (type) {
      'payment_consistency' => IndicatorType.paymentConsistency,
      'compliance_readiness' => IndicatorType.complianceReadiness,
      'business_momentum' => IndicatorType.businessMomentum,
      'data_completeness' => IndicatorType.dataCompleteness,
      _ => IndicatorType.paymentConsistency,
    };
  }
}
