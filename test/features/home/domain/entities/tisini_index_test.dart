import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/home/domain/entities/tisini_index.dart';

void main() {
  group('TisiniIndex', () {
    test('creates with required fields', () {
      final now = DateTime(2025, 6, 15);
      final index = TisiniIndex(
        score: 72,
        paymentConsistency: 80,
        complianceReadiness: 65,
        businessMomentum: 70,
        dataCompleteness: 73,
        changeReason: 'Improved payment consistency',
        changeAmount: 3.5,
        updatedAt: now,
      );

      expect(index.score, 72);
      expect(index.paymentConsistency, 80);
      expect(index.complianceReadiness, 65);
      expect(index.businessMomentum, 70);
      expect(index.dataCompleteness, 73);
      expect(index.changeReason, 'Improved payment consistency');
      expect(index.changeAmount, 3.5);
      expect(index.updatedAt, now);
    });

    test('supports value equality', () {
      final now = DateTime(2025, 6, 15);
      final a = TisiniIndex(
        score: 72,
        paymentConsistency: 80,
        complianceReadiness: 65,
        businessMomentum: 70,
        dataCompleteness: 73,
        changeReason: 'Reason',
        changeAmount: 3.5,
        updatedAt: now,
      );
      final b = TisiniIndex(
        score: 72,
        paymentConsistency: 80,
        complianceReadiness: 65,
        businessMomentum: 70,
        dataCompleteness: 73,
        changeReason: 'Reason',
        changeAmount: 3.5,
        updatedAt: now,
      );

      expect(a, equals(b));
    });

    test('supports copyWith', () {
      final now = DateTime(2025, 6, 15);
      final index = TisiniIndex(
        score: 72,
        paymentConsistency: 80,
        complianceReadiness: 65,
        businessMomentum: 70,
        dataCompleteness: 73,
        changeReason: 'Reason',
        changeAmount: 3.5,
        updatedAt: now,
      );

      final updated = index.copyWith(score: 75);
      expect(updated.score, 75);
      expect(updated.paymentConsistency, 80);
    });
  });
}
