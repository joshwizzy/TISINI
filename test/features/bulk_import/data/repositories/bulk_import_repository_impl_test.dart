import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/data/datasources/mock_bulk_import_remote_datasource.dart';
import 'package:tisini/features/bulk_import/data/repositories/bulk_import_repository_impl.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_mapping.dart';

void main() {
  late BulkImportRepositoryImpl repository;

  setUp(() {
    repository = BulkImportRepositoryImpl(
      datasource: MockBulkImportRemoteDatasource(),
    );
  });

  group('BulkImportRepositoryImpl', () {
    test('uploadCsv returns entity with correct fields', () async {
      final result = await repository.uploadCsv(source: ImportSource.bank);

      expect(result.job.id, isNotEmpty);
      expect(result.job.source, ImportSource.bank);
      expect(result.job.status, ImportJobStatus.mapping);
      expect(result.job.totalRows, 142);
      expect(result.columns, hasLength(5));
      expect(result.sampleRows, hasLength(3));
      expect(result.job.createdAt, isA<DateTime>());
    });

    test('submitMapping returns record with correct values', () async {
      const mapping = ImportMapping(
        dateColumn: 'Date',
        amountColumn: 'Amount (UGX)',
        merchantColumn: 'Description',
        referenceColumn: 'Reference',
      );

      final result = await repository.submitMapping(
        jobId: 'imp-123',
        mapping: mapping,
      );

      expect(result.jobId, 'imp-123');
      expect(result.totalRows, 142);
      expect(result.autoCategorised, 89);
      expect(result.uncategorised, 53);
    });

    test('getJobStatus returns ImportJob entity', () async {
      final job = await repository.getJobStatus('imp-123');

      expect(job.id, 'imp-123');
      expect(job.source, ImportSource.bank);
      expect(job.status, ImportJobStatus.processing);
      expect(job.totalRows, 142);
      expect(job.processedRows, 72);
      expect(job.createdAt, isA<DateTime>());
    });

    test('getJobResult returns ImportResult entity', () async {
      final result = await repository.getJobResult('imp-123');

      expect(result.jobId, 'imp-123');
      expect(result.totalImported, 138);
      expect(result.categorised, 89);
      expect(result.uncategorised, 49);
      expect(result.errors, hasLength(4));
    });
  });
}
