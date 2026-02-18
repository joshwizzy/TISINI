import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/data/models/import_mapping_model.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_mapping.dart';

void main() {
  group('ImportMappingModel', () {
    final json = <String, dynamic>{
      'date_column': 'Transaction Date',
      'amount_column': 'Amount',
      'merchant_column': 'Description',
      'reference_column': 'Ref No',
    };

    test('fromJson parses correctly', () {
      final model = ImportMappingModel.fromJson(json);
      expect(model.dateColumn, 'Transaction Date');
      expect(model.amountColumn, 'Amount');
      expect(model.merchantColumn, 'Description');
      expect(model.referenceColumn, 'Ref No');
    });

    test('toJson produces snake_case keys', () {
      final model = ImportMappingModel.fromJson(json);
      final output = model.toJson();
      expect(output['date_column'], 'Transaction Date');
      expect(output['amount_column'], 'Amount');
      expect(output['merchant_column'], 'Description');
      expect(output['reference_column'], 'Ref No');
    });

    test('toEntity converts correctly', () {
      final model = ImportMappingModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity, isA<ImportMapping>());
      expect(entity.dateColumn, 'Transaction Date');
      expect(entity.amountColumn, 'Amount');
      expect(entity.merchantColumn, 'Description');
      expect(entity.referenceColumn, 'Ref No');
    });

    test('fromEntity creates model from entity', () {
      const entity = ImportMapping(
        dateColumn: 'Date',
        amountColumn: 'Value',
        merchantColumn: 'Payee',
        referenceColumn: 'Reference',
      );
      final model = ImportMappingModel.fromEntity(entity);
      expect(model.dateColumn, 'Date');
      expect(model.amountColumn, 'Value');
      expect(model.merchantColumn, 'Payee');
      expect(model.referenceColumn, 'Reference');
    });

    test('fromEntity then toEntity round-trip preserves data', () {
      const entity = ImportMapping(
        dateColumn: 'Date',
        amountColumn: 'Value',
        merchantColumn: 'Payee',
        referenceColumn: 'Reference',
      );
      final roundTrip = ImportMappingModel.fromEntity(entity).toEntity();
      expect(roundTrip, equals(entity));
    });

    test('round-trip serialization preserves data', () {
      final model = ImportMappingModel.fromJson(json);
      final roundTrip = ImportMappingModel.fromJson(model.toJson());
      expect(roundTrip, equals(model));
    });
  });
}
