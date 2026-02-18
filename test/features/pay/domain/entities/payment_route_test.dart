import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';

void main() {
  group('PaymentRoute', () {
    test('creates with required fields', () {
      const route = PaymentRoute(
        rail: PaymentRail.mobileMoney,
        label: 'Mobile Money',
        isAvailable: true,
      );

      expect(route.rail, PaymentRail.mobileMoney);
      expect(route.label, 'Mobile Money');
      expect(route.isAvailable, true);
      expect(route.fee, isNull);
      expect(route.estimatedTime, isNull);
    });

    test('creates with optional fields', () {
      const route = PaymentRoute(
        rail: PaymentRail.bank,
        label: 'Bank Transfer',
        isAvailable: true,
        fee: 1500,
        estimatedTime: '1-2 hours',
      );

      expect(route.fee, 1500);
      expect(route.estimatedTime, '1-2 hours');
    });

    test('supports unavailable route', () {
      const route = PaymentRoute(
        rail: PaymentRail.card,
        label: 'Card Payment',
        isAvailable: false,
      );

      expect(route.isAvailable, false);
    });

    test('supports value equality', () {
      const a = PaymentRoute(
        rail: PaymentRail.mobileMoney,
        label: 'Mobile Money',
        isAvailable: true,
      );
      const b = PaymentRoute(
        rail: PaymentRail.mobileMoney,
        label: 'Mobile Money',
        isAvailable: true,
      );

      expect(a, equals(b));
    });
  });
}
