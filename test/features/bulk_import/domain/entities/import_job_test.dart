import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_job.dart';

void main() {
  group('ImportJob', () {
    test('creates with required fields and null completedAt', () {
      final job = ImportJob(
        id: 'job-001',
        source: ImportSource.bank,
        status: ImportJobStatus.processing,
        totalRows: 100,
        processedRows: 50,
        successRows: 45,
        errorRows: 5,
        createdAt: DateTime(2026, 2, 18),
      );

      expect(job.id, 'job-001');
      expect(job.source, ImportSource.bank);
      expect(job.status, ImportJobStatus.processing);
      expect(job.totalRows, 100);
      expect(job.processedRows, 50);
      expect(job.successRows, 45);
      expect(job.errorRows, 5);
      expect(job.createdAt, DateTime(2026, 2, 18));
      expect(job.completedAt, isNull);
    });

    test('creates with optional completedAt', () {
      final job = ImportJob(
        id: 'job-002',
        source: ImportSource.mobileMoney,
        status: ImportJobStatus.completed,
        totalRows: 200,
        processedRows: 200,
        successRows: 195,
        errorRows: 5,
        createdAt: DateTime(2026, 2, 18),
        completedAt: DateTime(2026, 2, 18, 14, 30),
      );

      expect(job.completedAt, DateTime(2026, 2, 18, 14, 30));
      expect(job.source, ImportSource.mobileMoney);
      expect(job.status, ImportJobStatus.completed);
    });

    test('supports value equality', () {
      final a = ImportJob(
        id: 'job-001',
        source: ImportSource.bank,
        status: ImportJobStatus.uploading,
        totalRows: 50,
        processedRows: 0,
        successRows: 0,
        errorRows: 0,
        createdAt: DateTime(2026, 2, 18),
      );
      final b = ImportJob(
        id: 'job-001',
        source: ImportSource.bank,
        status: ImportJobStatus.uploading,
        totalRows: 50,
        processedRows: 0,
        successRows: 0,
        errorRows: 0,
        createdAt: DateTime(2026, 2, 18),
      );

      expect(a, equals(b));
    });

    test('creates with each ImportJobStatus value', () {
      for (final status in ImportJobStatus.values) {
        final job = ImportJob(
          id: 'job-status',
          source: ImportSource.bank,
          status: status,
          totalRows: 10,
          processedRows: 0,
          successRows: 0,
          errorRows: 0,
          createdAt: DateTime(2026),
        );

        expect(job.status, status);
      }
    });
  });
}
