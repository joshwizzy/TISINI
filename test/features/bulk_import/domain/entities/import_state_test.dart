import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_mapping.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_result.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';

void main() {
  group('ImportState', () {
    test('choosingSource creates initial state', () {
      const state = ImportState.choosingSource();

      expect(state, isA<ImportChoosingSource>());
    });

    test('uploading holds source', () {
      const state = ImportState.uploading(source: ImportSource.bank);

      expect(state, isA<ImportUploading>());
      const uploading = state as ImportUploading;
      expect(uploading.source, ImportSource.bank);
    });

    test('uploading with mobileMoney source', () {
      const state = ImportState.uploading(source: ImportSource.mobileMoney);

      const uploading = state as ImportUploading;
      expect(uploading.source, ImportSource.mobileMoney);
    });

    test('mapping holds columns and sampleRows', () {
      const state = ImportState.mapping(
        columns: ['Date', 'Amount', 'Merchant', 'Reference'],
        sampleRows: [
          ['2026-01-15', '50000', 'ABC Supplies', 'TXN-001'],
          ['2026-01-16', '25000', 'City Mart', 'TXN-002'],
        ],
      );

      expect(state, isA<ImportMapping_>());
      const mapping = state as ImportMapping_;
      expect(mapping.columns, hasLength(4));
      expect(mapping.columns.first, 'Date');
      expect(mapping.sampleRows, hasLength(2));
      expect(mapping.sampleRows.first.last, 'TXN-001');
    });

    test('reviewing holds mapping and row counts', () {
      const mapping = ImportMapping(
        dateColumn: 'Date',
        amountColumn: 'Amount',
        merchantColumn: 'Merchant',
        referenceColumn: 'Reference',
      );

      const state = ImportState.reviewing(
        mapping: mapping,
        totalRows: 100,
        autoCategorised: 85,
        uncategorised: 15,
      );

      expect(state, isA<ImportReviewing>());
      const reviewing = state as ImportReviewing;
      expect(reviewing.mapping, mapping);
      expect(reviewing.totalRows, 100);
      expect(reviewing.autoCategorised, 85);
      expect(reviewing.uncategorised, 15);
    });

    test('processing holds jobId', () {
      const state = ImportState.processing(jobId: 'job-001');

      expect(state, isA<ImportProcessing>());
      const processing = state as ImportProcessing;
      expect(processing.jobId, 'job-001');
    });

    test('completed holds ImportResult', () {
      const result = ImportResult(
        jobId: 'job-001',
        totalImported: 100,
        categorised: 85,
        uncategorised: 15,
        errors: ['Row 12: invalid amount'],
      );

      const state = ImportState.completed(result: result);

      expect(state, isA<ImportCompleted>());
      const completed = state as ImportCompleted;
      expect(completed.result, result);
      expect(completed.result.jobId, 'job-001');
      expect(completed.result.totalImported, 100);
      expect(completed.result.errors, hasLength(1));
    });

    test('failed holds message', () {
      const state = ImportState.failed(message: 'File format not supported');

      expect(state, isA<ImportFailed>());
      const failed = state as ImportFailed;
      expect(failed.message, 'File format not supported');
    });
  });
}
