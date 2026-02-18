import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/home/domain/entities/dashboard_indicator.dart';

void main() {
  group('DashboardIndicator', () {
    test('creates with required fields', () {
      const indicator = DashboardIndicator(
        type: IndicatorType.paymentConsistency,
        label: 'Payment Consistency',
        value: 80,
        maxValue: 100,
        percentage: 0.8,
      );

      expect(indicator.type, IndicatorType.paymentConsistency);
      expect(indicator.label, 'Payment Consistency');
      expect(indicator.value, 80);
      expect(indicator.maxValue, 100);
      expect(indicator.percentage, 0.8);
    });

    test('supports value equality', () {
      const a = DashboardIndicator(
        type: IndicatorType.complianceReadiness,
        label: 'Compliance',
        value: 65,
        maxValue: 100,
        percentage: 0.65,
      );
      const b = DashboardIndicator(
        type: IndicatorType.complianceReadiness,
        label: 'Compliance',
        value: 65,
        maxValue: 100,
        percentage: 0.65,
      );

      expect(a, equals(b));
    });
  });
}
