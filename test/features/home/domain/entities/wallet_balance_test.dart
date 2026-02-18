import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/home/domain/entities/wallet_balance.dart';

void main() {
  group('WalletBalance', () {
    test('creates with required fields', () {
      const balance = WalletBalance(balance: 125000, currency: 'UGX');

      expect(balance.balance, 125000);
      expect(balance.currency, 'UGX');
    });

    test('supports value equality', () {
      const a = WalletBalance(balance: 125000, currency: 'UGX');
      const b = WalletBalance(balance: 125000, currency: 'UGX');

      expect(a, equals(b));
    });

    test('supports zero balance', () {
      const balance = WalletBalance(balance: 0, currency: 'KES');

      expect(balance.balance, 0);
      expect(balance.currency, 'KES');
    });
  });
}
