import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/data/models/payment_model.dart';

void main() {
  group('PaymentModel', () {
    const json = {
      'id': 'pay-001',
      'type': 'send',
      'status': 'completed',
      'direction': 'outbound',
      'amount': 150000.0,
      'currency': 'UGX',
      'rail': 'mobile_money',
      'payee': {
        'id': 'p-001',
        'name': 'Jane Nakamya',
        'identifier': '+256700100200',
        'rail': 'mobile_money',
        'is_pinned': false,
      },
      'fee': 500.0,
      'total': 150500.0,
      'category': 'people',
      'created_at': 1718400000000,
    };

    test('fromJson creates correct model', () {
      final model = PaymentModel.fromJson(json);

      expect(model.id, 'pay-001');
      expect(model.type, 'send');
      expect(model.status, 'completed');
      expect(model.amount, 150000.0);
      expect(model.fee, 500.0);
      expect(model.total, 150500.0);
      expect(model.payee.name, 'Jane Nakamya');
      expect(model.reference, isNull);
      expect(model.note, isNull);
      expect(model.completedAt, isNull);
    });

    test('fromJson with optional fields', () {
      final fullJson = {
        ...json,
        'reference': 'INV-001',
        'note': 'Monthly payment',
        'completed_at': 1718400100000,
      };

      final model = PaymentModel.fromJson(fullJson);

      expect(model.reference, 'INV-001');
      expect(model.note, 'Monthly payment');
      expect(model.completedAt, 1718400100000);
    });

    test('toEntity converts enums correctly', () {
      final model = PaymentModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.type, PaymentType.send);
      expect(entity.status, PaymentStatus.completed);
      expect(entity.direction, TransactionDirection.outbound);
      expect(entity.rail, PaymentRail.mobileMoney);
      expect(entity.category, TransactionCategory.people);
      expect(entity.payee.name, 'Jane Nakamya');
    });

    test('toEntity converts completed timestamp', () {
      final fullJson = {...json, 'completed_at': 1718400100000};

      final entity = PaymentModel.fromJson(fullJson).toEntity();

      expect(entity.completedAt, isNotNull);
    });
  });
}
