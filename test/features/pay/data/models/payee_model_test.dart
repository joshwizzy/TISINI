import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/data/models/payee_model.dart';

void main() {
  group('PayeeModel', () {
    const json = {
      'id': 'p-001',
      'name': 'Jane Nakamya',
      'identifier': '+256700100200',
      'rail': 'mobile_money',
      'is_pinned': false,
    };

    test('fromJson creates correct model', () {
      final model = PayeeModel.fromJson(json);

      expect(model.id, 'p-001');
      expect(model.name, 'Jane Nakamya');
      expect(model.identifier, '+256700100200');
      expect(model.rail, 'mobile_money');
      expect(model.isPinned, false);
      expect(model.avatarUrl, isNull);
      expect(model.merchantRole, isNull);
      expect(model.lastPaidAt, isNull);
    });

    test('fromJson with optional fields', () {
      final fullJson = {
        ...json,
        'avatar_url': 'https://example.com/avatar.png',
        'merchant_role': 'supplier',
        'is_pinned': true,
        'last_paid_at': 1718400000000,
      };

      final model = PayeeModel.fromJson(fullJson);

      expect(model.avatarUrl, 'https://example.com/avatar.png');
      expect(model.merchantRole, 'supplier');
      expect(model.isPinned, true);
      expect(model.lastPaidAt, 1718400000000);
    });

    test('toJson produces correct map', () {
      final model = PayeeModel.fromJson(json);
      final result = model.toJson();

      expect(result['id'], 'p-001');
      expect(result['is_pinned'], false);
    });

    test('toEntity converts enums correctly', () {
      final model = PayeeModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.id, 'p-001');
      expect(entity.rail, PaymentRail.mobileMoney);
      expect(entity.isPinned, false);
      expect(entity.role, isNull);
      expect(entity.lastPaidAt, isNull);
    });

    test('toEntity converts merchant role correctly', () {
      final fullJson = {
        ...json,
        'merchant_role': 'supplier',
        'last_paid_at': 1718400000000,
      };

      final entity = PayeeModel.fromJson(fullJson).toEntity();

      expect(entity.role, MerchantRole.supplier);
      expect(entity.lastPaidAt, isNotNull);
    });
  });
}
