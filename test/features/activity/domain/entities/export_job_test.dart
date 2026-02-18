import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/export_job.dart';

void main() {
  group('ExportJob', () {
    test('creates with required fields', () {
      final job = ExportJob(
        id: 'exp-001',
        startDate: DateTime(2026),
        endDate: DateTime(2026, 2),
        status: PaymentStatus.completed,
        createdAt: DateTime(2026, 2, 18),
      );
      expect(job.id, 'exp-001');
      expect(job.status, PaymentStatus.completed);
      expect(job.downloadUrl, isNull);
    });

    test('creates with optional downloadUrl', () {
      final job = ExportJob(
        id: 'exp-002',
        startDate: DateTime(2026),
        endDate: DateTime(2026, 2),
        status: PaymentStatus.completed,
        createdAt: DateTime(2026, 2, 18),
        downloadUrl: 'https://example.com/export.csv',
      );
      expect(job.downloadUrl, 'https://example.com/export.csv');
    });

    test('equality works', () {
      final a = ExportJob(
        id: 'exp-001',
        startDate: DateTime(2026),
        endDate: DateTime(2026, 2),
        status: PaymentStatus.completed,
        createdAt: DateTime(2026, 2, 18),
      );
      final b = ExportJob(
        id: 'exp-001',
        startDate: DateTime(2026),
        endDate: DateTime(2026, 2),
        status: PaymentStatus.completed,
        createdAt: DateTime(2026, 2, 18),
      );
      expect(a, equals(b));
    });
  });
}
