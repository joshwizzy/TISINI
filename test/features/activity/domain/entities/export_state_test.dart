import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/export_job.dart';
import 'package:tisini/features/activity/domain/entities/export_state.dart';

void main() {
  group('ExportState', () {
    test('choosingPeriod creates correct variant', () {
      const state = ExportState.choosingPeriod();
      expect(state, isA<ExportChoosingPeriod>());
    });

    test('confirming creates correct variant with fields', () {
      final state = ExportState.confirming(
        startDate: DateTime(2026),
        endDate: DateTime(2026, 2),
        estimatedRows: 47,
      );
      expect(state, isA<ExportConfirming>());
      final confirming = state as ExportConfirming;
      expect(confirming.estimatedRows, 47);
    });

    test('exporting creates correct variant', () {
      const state = ExportState.exporting();
      expect(state, isA<ExportExporting>());
    });

    test('success creates correct variant with job', () {
      final job = ExportJob(
        id: 'exp-001',
        startDate: DateTime(2026),
        endDate: DateTime(2026, 2),
        status: PaymentStatus.completed,
        createdAt: DateTime(2026, 2, 18),
        downloadUrl: 'https://example.com/export.csv',
      );
      final state = ExportState.success(job: job);
      expect(state, isA<ExportSuccess>());
      expect((state as ExportSuccess).job.id, 'exp-001');
    });

    test('failed creates correct variant with message', () {
      const state = ExportState.failed(message: 'Export failed');
      expect(state, isA<ExportFailed>());
      expect((state as ExportFailed).message, 'Export failed');
    });
  });
}
