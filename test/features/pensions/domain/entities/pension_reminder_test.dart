import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pensions/domain/entities/pension_reminder.dart';

void main() {
  group('PensionReminder', () {
    test('creates with required fields', () {
      final reminder = PensionReminder(
        id: 'rem-001',
        reminderDate: DateTime(2026, 3, 15),
        isActive: true,
      );

      expect(reminder.id, 'rem-001');
      expect(reminder.reminderDate, DateTime(2026, 3, 15));
      expect(reminder.isActive, true);
      expect(reminder.amount, isNull);
    });

    test('creates with optional amount', () {
      final reminder = PensionReminder(
        id: 'rem-002',
        reminderDate: DateTime(2026, 4),
        isActive: false,
        amount: 5000000,
      );

      expect(reminder.amount, 5000000);
      expect(reminder.isActive, false);
    });

    test('supports equality', () {
      final a = PensionReminder(
        id: 'rem-001',
        reminderDate: DateTime(2026, 3, 15),
        isActive: true,
      );
      final b = PensionReminder(
        id: 'rem-001',
        reminderDate: DateTime(2026, 3, 15),
        isActive: true,
      );

      expect(a, equals(b));
    });

    test('copyWith updates fields', () {
      final original = PensionReminder(
        id: 'rem-001',
        reminderDate: DateTime(2026, 3, 15),
        isActive: true,
      );

      final updated = original.copyWith(isActive: false);

      expect(updated.isActive, false);
      expect(updated.id, 'rem-001');
    });
  });
}
