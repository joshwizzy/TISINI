import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/data/models/import_job_model.dart';

void main() {
  group('ImportJobModel', () {
    final json = <String, dynamic>{
      'id': 'job-001',
      'source': 'bank',
      'status': 'processing',
      'total_rows': 100,
      'processed_rows': 45,
      'success_rows': 40,
      'error_rows': 5,
      'created_at': 1718409600000,
      'completed_at': 1718413200000,
    };

    test('fromJson parses correctly', () {
      final model = ImportJobModel.fromJson(json);
      expect(model.id, 'job-001');
      expect(model.source, 'bank');
      expect(model.status, 'processing');
      expect(model.totalRows, 100);
      expect(model.processedRows, 45);
      expect(model.successRows, 40);
      expect(model.errorRows, 5);
      expect(model.createdAt, 1718409600000);
      expect(model.completedAt, 1718413200000);
    });

    test('toJson produces snake_case keys', () {
      final model = ImportJobModel.fromJson(json);
      final output = model.toJson();
      expect(output['id'], 'job-001');
      expect(output['source'], 'bank');
      expect(output['status'], 'processing');
      expect(output['total_rows'], 100);
      expect(output['processed_rows'], 45);
      expect(output['success_rows'], 40);
      expect(output['error_rows'], 5);
      expect(output['created_at'], 1718409600000);
      expect(output['completed_at'], 1718413200000);
    });

    test('toEntity converts correctly', () {
      final model = ImportJobModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, 'job-001');
      expect(entity.source, ImportSource.bank);
      expect(entity.status, ImportJobStatus.processing);
      expect(entity.totalRows, 100);
      expect(entity.processedRows, 45);
      expect(entity.successRows, 40);
      expect(entity.errorRows, 5);
      expect(entity.createdAt, isA<DateTime>());
      expect(
        entity.createdAt,
        DateTime.fromMillisecondsSinceEpoch(1718409600000),
      );
      expect(entity.completedAt, isA<DateTime>());
      expect(
        entity.completedAt,
        DateTime.fromMillisecondsSinceEpoch(1718413200000),
      );
    });

    test('toEntity parses mobile_money source', () {
      final mmJson = Map<String, dynamic>.from(json)
        ..['source'] = 'mobile_money';
      final entity = ImportJobModel.fromJson(mmJson).toEntity();
      expect(entity.source, ImportSource.mobileMoney);
    });

    test('toEntity parses unknown source as bank', () {
      final unknown = Map<String, dynamic>.from(json)..['source'] = 'unknown';
      final entity = ImportJobModel.fromJson(unknown).toEntity();
      expect(entity.source, ImportSource.bank);
    });

    test('toEntity parses all status values', () {
      for (final entry in <String, ImportJobStatus>{
        'uploading': ImportJobStatus.uploading,
        'mapping': ImportJobStatus.mapping,
        'processing': ImportJobStatus.processing,
        'completed': ImportJobStatus.completed,
        'failed': ImportJobStatus.failed,
      }.entries) {
        final statusJson = Map<String, dynamic>.from(json)
          ..['status'] = entry.key;
        final entity = ImportJobModel.fromJson(statusJson).toEntity();
        expect(entity.status, entry.value);
      }
    });

    test('toEntity parses unknown status as uploading', () {
      final unknown = Map<String, dynamic>.from(json)..['status'] = 'unknown';
      final entity = ImportJobModel.fromJson(unknown).toEntity();
      expect(entity.status, ImportJobStatus.uploading);
    });

    test('toEntity without completedAt', () {
      final noCompleted = Map<String, dynamic>.from(json)
        ..remove('completed_at');
      final entity = ImportJobModel.fromJson(noCompleted).toEntity();
      expect(entity.completedAt, isNull);
    });

    test('round-trip serialization preserves data', () {
      final model = ImportJobModel.fromJson(json);
      final roundTrip = ImportJobModel.fromJson(model.toJson());
      expect(roundTrip, equals(model));
    });
  });
}
