import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/home/data/models/wallet_balance_model.dart';

void main() {
  group('WalletBalanceModel', () {
    const json = {'balance': 1250000.0, 'currency': 'UGX'};

    test('fromJson creates correct model', () {
      final model = WalletBalanceModel.fromJson(json);

      expect(model.balance, 1250000.0);
      expect(model.currency, 'UGX');
    });

    test('toJson produces correct map', () {
      final model = WalletBalanceModel.fromJson(json);
      expect(model.toJson(), json);
    });

    test('toEntity converts correctly', () {
      final entity = WalletBalanceModel.fromJson(json).toEntity();

      expect(entity.balance, 1250000.0);
      expect(entity.currency, 'UGX');
    });
  });
}
