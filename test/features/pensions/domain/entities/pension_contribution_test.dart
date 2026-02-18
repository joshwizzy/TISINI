import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribution.dart';

void main() {
  group('PensionContribution', () {
    test('creates with required fields', () {
      final contribution = PensionContribution(
        id: 'pc-001',
        amount: 5000000,
        currency: 'UGX',
        status: ContributionStatus.completed,
        rail: PaymentRail.mobileMoney,
        createdAt: DateTime(2026),
      );

      expect(contribution.id, 'pc-001');
      expect(contribution.amount, 5000000);
      expect(contribution.currency, 'UGX');
      expect(contribution.status, ContributionStatus.completed);
      expect(contribution.rail, PaymentRail.mobileMoney);
      expect(contribution.reference, isNull);
      expect(contribution.completedAt, isNull);
    });

    test('creates with optional fields', () {
      final contribution = PensionContribution(
        id: 'pc-002',
        amount: 5000000,
        currency: 'UGX',
        status: ContributionStatus.completed,
        rail: PaymentRail.mobileMoney,
        reference: 'NSSF Feb 2026',
        createdAt: DateTime(2026, 2),
        completedAt: DateTime(2026, 2),
      );

      expect(contribution.reference, 'NSSF Feb 2026');
      expect(contribution.completedAt, isNotNull);
    });

    test('supports equality', () {
      final a = PensionContribution(
        id: 'pc-001',
        amount: 5000000,
        currency: 'UGX',
        status: ContributionStatus.pending,
        rail: PaymentRail.bank,
        createdAt: DateTime(2026),
      );
      final b = PensionContribution(
        id: 'pc-001',
        amount: 5000000,
        currency: 'UGX',
        status: ContributionStatus.pending,
        rail: PaymentRail.bank,
        createdAt: DateTime(2026),
      );

      expect(a, equals(b));
    });
  });
}
