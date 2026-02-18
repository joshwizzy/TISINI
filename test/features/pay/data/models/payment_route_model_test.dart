import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/data/models/payment_route_model.dart';

void main() {
  group('PaymentRouteModel', () {
    const json = {
      'rail': 'mobile_money',
      'label': 'Mobile Money',
      'is_available': true,
    };

    test('fromJson creates correct model', () {
      final model = PaymentRouteModel.fromJson(json);

      expect(model.rail, 'mobile_money');
      expect(model.label, 'Mobile Money');
      expect(model.isAvailable, true);
      expect(model.fee, isNull);
      expect(model.estimatedTime, isNull);
    });

    test('fromJson with optional fields', () {
      final fullJson = {...json, 'fee': 1500.0, 'estimated_time': '1-2 hours'};

      final model = PaymentRouteModel.fromJson(fullJson);

      expect(model.fee, 1500.0);
      expect(model.estimatedTime, '1-2 hours');
    });

    test('toJson produces correct map', () {
      final model = PaymentRouteModel.fromJson(json);
      final result = model.toJson();

      expect(result['rail'], 'mobile_money');
      expect(result['is_available'], true);
    });

    test('toEntity converts rail correctly', () {
      final model = PaymentRouteModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.rail, PaymentRail.mobileMoney);
      expect(entity.label, 'Mobile Money');
      expect(entity.isAvailable, true);
    });

    test('toEntity converts bank rail', () {
      final bankJson = {
        ...json,
        'rail': 'bank',
        'label': 'Bank Transfer',
        'fee': 1500.0,
      };

      final entity = PaymentRouteModel.fromJson(bankJson).toEntity();

      expect(entity.rail, PaymentRail.bank);
      expect(entity.fee, 1500.0);
    });
  });
}
