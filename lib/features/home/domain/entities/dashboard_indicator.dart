import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'dashboard_indicator.freezed.dart';

@freezed
class DashboardIndicator with _$DashboardIndicator {
  const factory DashboardIndicator({
    required IndicatorType type,
    required String label,
    required int value,
    required int maxValue,
    required double percentage,
  }) = _DashboardIndicator;
}
