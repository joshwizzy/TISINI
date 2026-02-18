import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/domain/entities/pension_reminder.dart';
import 'package:tisini/features/pensions/domain/entities/pension_status.dart';

void main() {
  group('PensionStatus', () {
    test('creates with required fields', () {
      const status = PensionStatus(
        linkStatus: PensionLinkStatus.linked,
        currency: 'UGX',
        totalContributions: 3,
        totalAmount: 15000000,
        activeReminders: [],
      );

      expect(status.linkStatus, PensionLinkStatus.linked);
      expect(status.currency, 'UGX');
      expect(status.totalContributions, 3);
      expect(status.totalAmount, 15000000);
      expect(status.activeReminders, isEmpty);
      expect(status.nssfNumber, isNull);
      expect(status.nextDueDate, isNull);
      expect(status.nextDueAmount, isNull);
    });

    test('creates with all optional fields', () {
      final status = PensionStatus(
        linkStatus: PensionLinkStatus.linked,
        currency: 'UGX',
        totalContributions: 3,
        totalAmount: 15000000,
        nssfNumber: 'NSSF-UG-123456',
        nextDueDate: DateTime(2026, 4),
        nextDueAmount: 5000000,
        activeReminders: [
          PensionReminder(
            id: 'rem-001',
            reminderDate: DateTime(2026, 3, 30),
            isActive: true,
            amount: 5000000,
          ),
        ],
      );

      expect(status.nssfNumber, 'NSSF-UG-123456');
      expect(status.nextDueDate, DateTime(2026, 4));
      expect(status.nextDueAmount, 5000000);
      expect(status.activeReminders, hasLength(1));
    });

    test('supports equality', () {
      const a = PensionStatus(
        linkStatus: PensionLinkStatus.notLinked,
        currency: 'UGX',
        totalContributions: 0,
        totalAmount: 0,
        activeReminders: [],
      );
      const b = PensionStatus(
        linkStatus: PensionLinkStatus.notLinked,
        currency: 'UGX',
        totalContributions: 0,
        totalAmount: 0,
        activeReminders: [],
      );

      expect(a, equals(b));
    });
  });
}
