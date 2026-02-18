import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/data/datasources/mock_pension_remote_datasource.dart';
import 'package:tisini/features/pensions/data/repositories/pension_repository_impl.dart';

void main() {
  late PensionRepositoryImpl repository;

  setUp(() {
    repository = PensionRepositoryImpl(
      datasource: MockPensionRemoteDatasource(),
    );
  });

  group('PensionRepositoryImpl', () {
    test('getPensionStatus returns domain entity', () async {
      final status = await repository.getPensionStatus();

      expect(status.linkStatus, PensionLinkStatus.linked);
      expect(status.nssfNumber, 'NSSF-UG-123456');
      expect(status.currency, 'UGX');
      expect(status.totalContributions, 3);
      expect(status.totalAmount, 15000000);
      expect(status.nextDueAmount, 5000000);
      expect(status.nextDueDate, isA<DateTime>());
      expect(status.activeReminders, hasLength(1));
    });

    test('submitContribution returns domain entity', () async {
      final contribution = await repository.submitContribution(
        amount: 5000000,
        currency: 'UGX',
        rail: 'mobile_money',
        reference: 'NSSF Mar 2026',
      );

      expect(contribution.amount, 5000000);
      expect(contribution.status, ContributionStatus.completed);
      expect(contribution.rail, PaymentRail.mobileMoney);
      expect(contribution.reference, 'NSSF Mar 2026');
    });

    test('getContributions returns domain entities', () async {
      final result = await repository.getContributions();

      expect(result.contributions, hasLength(3));
      expect(result.hasMore, false);
      expect(result.nextCursor, isNull);

      final first = result.contributions.first;
      expect(first.id, 'pc-001');
      expect(first.status, ContributionStatus.completed);
      expect(first.rail, PaymentRail.mobileMoney);
      expect(first.createdAt, isA<DateTime>());
    });

    test('linkNssf returns status', () async {
      final result = await repository.linkNssf(nssfNumber: 'NSSF-UG-123456');

      expect(result, PensionLinkStatus.linked);
    });

    test('setReminder returns domain entity', () async {
      final reminder = await repository.setReminder(
        reminderDate: DateTime(2026, 4),
        amount: 5000000,
      );

      expect(reminder.isActive, true);
      expect(reminder.amount, 5000000);
      expect(reminder.reminderDate, isA<DateTime>());
    });
  });
}
