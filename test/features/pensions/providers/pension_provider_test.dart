import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/providers/pension_provider.dart';

void main() {
  group('pensionRepositoryProvider', () {
    test('provides PensionRepository instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repo = container.read(pensionRepositoryProvider);

      expect(repo, isNotNull);
    });
  });

  group('pensionStatusProvider', () {
    test('returns pension status', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final status = await container.read(pensionStatusProvider.future);

      expect(status.linkStatus, PensionLinkStatus.linked);
      expect(status.currency, 'UGX');
      expect(status.nssfNumber, 'NSSF-UG-123456');
      expect(status.totalContributions, 3);
    });
  });

  group('pensionHistoryProvider', () {
    test('returns contribution list', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final history = await container.read(pensionHistoryProvider.future);

      expect(history, hasLength(3));
      expect(history.first.id, 'pc-001');
    });
  });

  group('pensionRemindersProvider', () {
    test('returns active reminders', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final reminders = await container.read(pensionRemindersProvider.future);

      expect(reminders, hasLength(1));
      expect(reminders.first.isActive, true);
    });
  });
}
