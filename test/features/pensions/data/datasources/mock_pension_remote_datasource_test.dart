import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/data/datasources/mock_pension_remote_datasource.dart';

void main() {
  late MockPensionRemoteDatasource datasource;

  setUp(() {
    datasource = MockPensionRemoteDatasource();
  });

  group('MockPensionRemoteDatasource', () {
    test('getPensionStatus returns linked status', () async {
      final status = await datasource.getPensionStatus();

      expect(status.linkStatus, 'linked');
      expect(status.nssfNumber, 'NSSF-UG-123456');
      expect(status.currency, 'UGX');
      expect(status.totalContributions, 3);
      expect(status.totalAmount, 15000000);
      expect(status.nextDueAmount, 5000000);
      expect(status.nextDueDate, isNotNull);
      expect(status.activeReminders, hasLength(1));
      expect(status.activeReminders.first.isActive, true);
    });

    test('submitContribution returns completed contribution', () async {
      final result = await datasource.submitContribution(
        amount: 5000000,
        currency: 'UGX',
        rail: 'mobile_money',
        reference: 'NSSF Mar 2026',
      );

      expect(result.amount, 5000000);
      expect(result.currency, 'UGX');
      expect(result.status, 'completed');
      expect(result.rail, 'mobile_money');
      expect(result.reference, 'NSSF Mar 2026');
      expect(result.id, isNotEmpty);
    });

    test('getContributions returns history', () async {
      final result = await datasource.getContributions();

      expect(result.contributions, hasLength(3));
      expect(result.hasMore, false);
      expect(result.nextCursor, isNull);
      expect(result.contributions.first.id, 'pc-001');
    });

    test('getContributions respects limit', () async {
      final result = await datasource.getContributions(limit: 2);

      expect(result.contributions, hasLength(3));
    });

    test('linkNssf returns linked status', () async {
      final result = await datasource.linkNssf(nssfNumber: 'NSSF-UG-999999');

      expect(result, PensionLinkStatus.linked);
    });

    test('setReminder returns new reminder', () async {
      final result = await datasource.setReminder(
        reminderDate: DateTime(2026, 4),
        amount: 5000000,
      );

      expect(result.isActive, true);
      expect(result.amount, 5000000);
      expect(result.id, isNotEmpty);
    });

    test('setReminder works without amount', () async {
      final result = await datasource.setReminder(
        reminderDate: DateTime(2026, 5),
      );

      expect(result.isActive, true);
      expect(result.amount, isNull);
    });
  });
}
