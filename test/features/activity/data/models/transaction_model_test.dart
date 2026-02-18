import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/data/models/transaction_model.dart';

void main() {
  group('TransactionModel', () {
    const json = {
      'id': 'tx-001',
      'type': 'send',
      'direction': 'outbound',
      'status': 'completed',
      'amount': 150000.0,
      'currency': 'UGX',
      'counterparty_name': 'Jane Nakamya',
      'counterparty_identifier': '+256700100200',
      'category': 'people',
      'rail': 'mobile_money',
      'created_at': 1718400000000,
    };

    test('fromJson creates correct model', () {
      final model = TransactionModel.fromJson(json);

      expect(model.id, 'tx-001');
      expect(model.type, 'send');
      expect(model.direction, 'outbound');
      expect(model.status, 'completed');
      expect(model.amount, 150000.0);
      expect(model.currency, 'UGX');
      expect(model.counterpartyName, 'Jane Nakamya');
      expect(model.merchantRole, isNull);
      expect(model.note, isNull);
      expect(model.fee, isNull);
    });

    test('fromJson with optional fields', () {
      final fullJson = {
        ...json,
        'merchant_role': 'supplier',
        'note': 'Stock order',
        'fee': 1500.0,
      };

      final model = TransactionModel.fromJson(fullJson);

      expect(model.merchantRole, 'supplier');
      expect(model.note, 'Stock order');
      expect(model.fee, 1500.0);
    });

    test('toJson produces correct map', () {
      final model = TransactionModel.fromJson(json);
      final result = model.toJson();

      expect(result['id'], 'tx-001');
      expect(result['counterparty_name'], 'Jane Nakamya');
      expect(result['created_at'], 1718400000000);
    });

    test('toEntity converts enums correctly', () {
      final model = TransactionModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.type, PaymentType.send);
      expect(entity.direction, TransactionDirection.outbound);
      expect(entity.status, PaymentStatus.completed);
      expect(entity.category, TransactionCategory.people);
      expect(entity.rail, PaymentRail.mobileMoney);
      expect(entity.merchantRole, isNull);
    });

    test('toEntity converts merchant role correctly', () {
      final fullJson = {...json, 'merchant_role': 'supplier'};

      final entity = TransactionModel.fromJson(fullJson).toEntity();

      expect(entity.merchantRole, MerchantRole.supplier);
    });
  });
}
