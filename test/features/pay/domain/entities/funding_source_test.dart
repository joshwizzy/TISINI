import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';

void main() {
  group('FundingSource', () {
    test('can be created with required fields', () {
      const source = FundingSource(
        rail: PaymentRail.mobileMoney,
        label: 'MTN Mobile Money',
        identifier: '+256700100200',
        isAvailable: true,
      );

      expect(source.rail, PaymentRail.mobileMoney);
      expect(source.label, 'MTN Mobile Money');
      expect(source.identifier, '+256700100200');
      expect(source.isAvailable, true);
    });

    test('supports equality', () {
      const a = FundingSource(
        rail: PaymentRail.bank,
        label: 'Stanbic Bank',
        identifier: '0100123456',
        isAvailable: true,
      );
      const b = FundingSource(
        rail: PaymentRail.bank,
        label: 'Stanbic Bank',
        identifier: '0100123456',
        isAvailable: true,
      );

      expect(a, equals(b));
    });

    test('unavailable source', () {
      const source = FundingSource(
        rail: PaymentRail.card,
        label: 'Visa *4242',
        identifier: '**** 4242',
        isAvailable: false,
      );

      expect(source.isAvailable, false);
    });
  });
}
