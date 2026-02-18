import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/data/models/funding_source_model.dart';

void main() {
  group('FundingSourceModel', () {
    const json = <String, dynamic>{
      'rail': 'mobile_money',
      'label': 'MTN Mobile Money',
      'identifier': '+256700100200',
      'is_available': true,
    };

    test('fromJson creates model', () {
      final model = FundingSourceModel.fromJson(json);

      expect(model.rail, 'mobile_money');
      expect(model.label, 'MTN Mobile Money');
      expect(model.identifier, '+256700100200');
      expect(model.isAvailable, true);
    });

    test('toJson produces valid map', () {
      const model = FundingSourceModel(
        rail: 'bank',
        label: 'Stanbic Bank',
        identifier: '0100123456',
        isAvailable: true,
      );

      final result = model.toJson();
      expect(result['rail'], 'bank');
      expect(result['is_available'], true);
    });

    test('toEntity converts to FundingSource', () {
      final model = FundingSourceModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.rail, PaymentRail.mobileMoney);
      expect(entity.label, 'MTN Mobile Money');
      expect(entity.identifier, '+256700100200');
      expect(entity.isAvailable, true);
    });

    test('toEntity parses bank rail', () {
      const bankJson = <String, dynamic>{
        'rail': 'bank',
        'label': 'Stanbic',
        'identifier': '0100123456',
        'is_available': true,
      };

      final entity = FundingSourceModel.fromJson(bankJson).toEntity();
      expect(entity.rail, PaymentRail.bank);
    });
  });
}
