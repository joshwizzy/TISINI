import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/home/domain/entities/badge.dart';

void main() {
  group('Badge', () {
    test('creates with required fields', () {
      const badge = Badge(
        id: 'badge-001',
        label: 'First Payment',
        iconName: 'trophy',
        isEarned: true,
      );

      expect(badge.id, 'badge-001');
      expect(badge.label, 'First Payment');
      expect(badge.iconName, 'trophy');
      expect(badge.isEarned, true);
      expect(badge.earnedAt, isNull);
    });

    test('creates with optional earnedAt', () {
      final now = DateTime(2025, 6, 15);
      final badge = Badge(
        id: 'badge-001',
        label: 'First Payment',
        iconName: 'trophy',
        isEarned: true,
        earnedAt: now,
      );

      expect(badge.earnedAt, now);
    });

    test('supports value equality', () {
      const a = Badge(
        id: 'badge-001',
        label: 'First Payment',
        iconName: 'trophy',
        isEarned: false,
      );
      const b = Badge(
        id: 'badge-001',
        label: 'First Payment',
        iconName: 'trophy',
        isEarned: false,
      );

      expect(a, equals(b));
    });
  });
}
