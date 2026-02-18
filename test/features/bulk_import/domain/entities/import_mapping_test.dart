import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_mapping.dart';

void main() {
  group('ImportMapping', () {
    test('creates with required fields', () {
      const mapping = ImportMapping(
        dateColumn: 'Date',
        amountColumn: 'Amount',
        merchantColumn: 'Merchant',
        referenceColumn: 'Reference',
      );

      expect(mapping.dateColumn, 'Date');
      expect(mapping.amountColumn, 'Amount');
      expect(mapping.merchantColumn, 'Merchant');
      expect(mapping.referenceColumn, 'Reference');
    });

    test('supports value equality', () {
      const a = ImportMapping(
        dateColumn: 'Transaction Date',
        amountColumn: 'Total',
        merchantColumn: 'Payee',
        referenceColumn: 'Ref No',
      );
      const b = ImportMapping(
        dateColumn: 'Transaction Date',
        amountColumn: 'Total',
        merchantColumn: 'Payee',
        referenceColumn: 'Ref No',
      );

      expect(a, equals(b));
    });

    test('different column names are not equal', () {
      const a = ImportMapping(
        dateColumn: 'Date',
        amountColumn: 'Amount',
        merchantColumn: 'Merchant',
        referenceColumn: 'Reference',
      );
      const b = ImportMapping(
        dateColumn: 'Transaction Date',
        amountColumn: 'Amount',
        merchantColumn: 'Merchant',
        referenceColumn: 'Reference',
      );

      expect(a, isNot(equals(b)));
    });
  });
}
