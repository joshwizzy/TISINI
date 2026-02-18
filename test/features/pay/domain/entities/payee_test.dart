import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';

void main() {
  group('Payee', () {
    test('creates with required fields', () {
      const payee = Payee(
        id: 'p-001',
        name: 'Jane Nakamya',
        identifier: '+256700100200',
        rail: PaymentRail.mobileMoney,
        isPinned: false,
      );

      expect(payee.id, 'p-001');
      expect(payee.name, 'Jane Nakamya');
      expect(payee.identifier, '+256700100200');
      expect(payee.rail, PaymentRail.mobileMoney);
      expect(payee.isPinned, false);
      expect(payee.avatarUrl, isNull);
      expect(payee.role, isNull);
      expect(payee.lastPaidAt, isNull);
    });

    test('creates with all optional fields', () {
      final now = DateTime.now();
      final payee = Payee(
        id: 'p-002',
        name: 'ABC Supplies',
        identifier: 'BIZ-ABC-001',
        rail: PaymentRail.bank,
        avatarUrl: 'https://example.com/avatar.png',
        role: MerchantRole.supplier,
        isPinned: true,
        lastPaidAt: now,
      );

      expect(payee.avatarUrl, 'https://example.com/avatar.png');
      expect(payee.role, MerchantRole.supplier);
      expect(payee.isPinned, true);
      expect(payee.lastPaidAt, now);
    });

    test('supports value equality', () {
      const a = Payee(
        id: 'p-001',
        name: 'Jane',
        identifier: '+256700100200',
        rail: PaymentRail.mobileMoney,
        isPinned: false,
      );
      const b = Payee(
        id: 'p-001',
        name: 'Jane',
        identifier: '+256700100200',
        rail: PaymentRail.mobileMoney,
        isPinned: false,
      );

      expect(a, equals(b));
    });
  });
}
