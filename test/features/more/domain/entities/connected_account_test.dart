import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/domain/entities/connected_account.dart';

void main() {
  group('ConnectedAccount', () {
    final connectedAt = DateTime(2025, 6, 15);

    test('creates with required fields', () {
      final account = ConnectedAccount(
        id: 'acc1',
        provider: AccountProvider.mtn,
        identifier: '+256770555123',
        connectedAt: connectedAt,
      );

      expect(account.id, 'acc1');
      expect(account.provider, AccountProvider.mtn);
      expect(account.identifier, '+256770555123');
      expect(account.connectedAt, connectedAt);
    });

    test('supports value equality', () {
      final a = ConnectedAccount(
        id: 'acc1',
        provider: AccountProvider.mtn,
        identifier: '+256770555123',
        connectedAt: connectedAt,
      );
      final b = ConnectedAccount(
        id: 'acc1',
        provider: AccountProvider.mtn,
        identifier: '+256770555123',
        connectedAt: connectedAt,
      );

      expect(a, equals(b));
    });

    test('different providers are not equal', () {
      final a = ConnectedAccount(
        id: 'acc1',
        provider: AccountProvider.mtn,
        identifier: '+256770555123',
        connectedAt: connectedAt,
      );
      final b = ConnectedAccount(
        id: 'acc2',
        provider: AccountProvider.stanbic,
        identifier: '1234567890',
        connectedAt: connectedAt,
      );

      expect(a, isNot(equals(b)));
    });
  });
}
