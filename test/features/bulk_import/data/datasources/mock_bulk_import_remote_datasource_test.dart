import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/data/datasources/mock_bulk_import_remote_datasource.dart';
import 'package:tisini/features/bulk_import/data/models/import_mapping_model.dart';

void main() {
  late MockBulkImportRemoteDatasource datasource;

  setUp(() {
    datasource = MockBulkImportRemoteDatasource();
  });

  group('MockBulkImportRemoteDatasource', () {
    group('uploadCsv', () {
      test('bank source returns bank columns and 3 sample rows', () async {
        final result = await datasource.uploadCsv(source: ImportSource.bank);

        expect(result.columns, [
          'Date',
          'Description',
          'Amount (UGX)',
          'Reference',
          'Balance',
        ]);
        expect(result.sampleRows, hasLength(3));
        expect(result.job.source, 'bank');
        expect(result.job.status, 'mapping');
        expect(result.job.totalRows, 142);
      });

      test(
        'mobileMoney source returns momo columns and 3 sample rows',
        () async {
          final result = await datasource.uploadCsv(
            source: ImportSource.mobileMoney,
          );

          expect(result.columns, [
            'Date',
            'Transaction',
            'Amount',
            'Phone Number',
            'Ref ID',
          ]);
          expect(result.sampleRows, hasLength(3));
          expect(result.job.source, 'mobile_money');
          expect(result.job.status, 'mapping');
          expect(result.job.totalRows, 142);
        },
      );
    });

    group('submitMapping', () {
      test(
        'returns jobId, totalRows, autoCategorised, uncategorised',
        () async {
          const mapping = ImportMappingModel(
            dateColumn: 'Date',
            amountColumn: 'Amount (UGX)',
            merchantColumn: 'Description',
            referenceColumn: 'Reference',
          );

          final result = await datasource.submitMapping(
            jobId: 'imp-123',
            mapping: mapping,
          );

          expect(result.jobId, 'imp-123');
          expect(result.totalRows, 142);
          expect(result.autoCategorised, 89);
          expect(result.uncategorised, 53);
        },
      );
    });

    group('getJobStatus', () {
      test('first call returns processing with 72/142 processed', () async {
        final status = await datasource.getJobStatus('imp-123');

        expect(status.id, 'imp-123');
        expect(status.status, 'processing');
        expect(status.processedRows, 72);
        expect(status.totalRows, 142);
      });

      test('second call returns completed with 142/142 processed', () async {
        // First call — processing
        await datasource.getJobStatus('imp-123');

        // Second call — completed
        final status = await datasource.getJobStatus('imp-123');

        expect(status.id, 'imp-123');
        expect(status.status, 'completed');
        expect(status.processedRows, 142);
        expect(status.totalRows, 142);
        expect(status.successRows, 138);
        expect(status.errorRows, 4);
        expect(status.completedAt, isNotNull);
      });
    });

    group('getJobResult', () {
      test('returns correct import result summary', () async {
        final result = await datasource.getJobResult('imp-123');

        expect(result.jobId, 'imp-123');
        expect(result.totalImported, 138);
        expect(result.categorised, 89);
        expect(result.uncategorised, 49);
        expect(result.errors, hasLength(4));
      });
    });
  });
}
