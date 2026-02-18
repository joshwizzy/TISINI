import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_result.dart';

void main() {
  group('ImportResult', () {
    test('creates with required fields', () {
      const result = ImportResult(
        jobId: 'job-001',
        totalImported: 100,
        categorised: 85,
        uncategorised: 15,
        errors: [],
      );

      expect(result.jobId, 'job-001');
      expect(result.totalImported, 100);
      expect(result.categorised, 85);
      expect(result.uncategorised, 15);
      expect(result.errors, isEmpty);
    });

    test('creates with errors list', () {
      const result = ImportResult(
        jobId: 'job-002',
        totalImported: 95,
        categorised: 80,
        uncategorised: 15,
        errors: [
          'Row 12: invalid amount format',
          'Row 45: missing merchant name',
          'Row 78: duplicate reference',
        ],
      );

      expect(result.errors, hasLength(3));
      expect(result.errors.first, 'Row 12: invalid amount format');
      expect(result.errors.last, 'Row 78: duplicate reference');
    });

    test('supports value equality', () {
      const a = ImportResult(
        jobId: 'job-001',
        totalImported: 50,
        categorised: 40,
        uncategorised: 10,
        errors: ['Row 5: invalid date'],
      );
      const b = ImportResult(
        jobId: 'job-001',
        totalImported: 50,
        categorised: 40,
        uncategorised: 10,
        errors: ['Row 5: invalid date'],
      );

      expect(a, equals(b));
    });

    test('different errors lists are not equal', () {
      const a = ImportResult(
        jobId: 'job-001',
        totalImported: 50,
        categorised: 40,
        uncategorised: 10,
        errors: ['Row 5: invalid date'],
      );
      const b = ImportResult(
        jobId: 'job-001',
        totalImported: 50,
        categorised: 40,
        uncategorised: 10,
        errors: ['Row 10: missing amount'],
      );

      expect(a, isNot(equals(b)));
    });
  });
}
