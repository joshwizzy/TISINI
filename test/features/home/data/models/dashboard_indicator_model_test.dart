import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/home/data/models/dashboard_indicator_model.dart';

void main() {
  group('DashboardIndicatorModel', () {
    const json = {
      'type': 'payment_consistency',
      'label': 'Payment Consistency',
      'value': 72,
      'max_value': 90,
      'percentage': 0.8,
    };

    test('fromJson creates correct model', () {
      final model = DashboardIndicatorModel.fromJson(json);

      expect(model.type, 'payment_consistency');
      expect(model.label, 'Payment Consistency');
      expect(model.value, 72);
      expect(model.maxValue, 90);
      expect(model.percentage, 0.8);
    });

    test('toJson produces correct map', () {
      final model = DashboardIndicatorModel.fromJson(json);
      expect(model.toJson(), json);
    });

    test('toEntity converts indicator type correctly', () {
      final model = DashboardIndicatorModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.type, IndicatorType.paymentConsistency);
      expect(entity.label, 'Payment Consistency');
      expect(entity.value, 72);
      expect(entity.maxValue, 90);
    });
  });
}
