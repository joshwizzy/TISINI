import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/data/models/export_job_model.dart';

void main() {
  group('ExportJobModel', () {
    final json = <String, dynamic>{
      'id': 'exp-001',
      'start_date': 1704067200000,
      'end_date': 1706745600000,
      'status': 'completed',
      'created_at': 1708214400000,
      'download_url': 'https://example.com/export.csv',
    };

    test('fromJson parses correctly', () {
      final model = ExportJobModel.fromJson(json);
      expect(model.id, 'exp-001');
      expect(model.status, 'completed');
      expect(model.downloadUrl, 'https://example.com/export.csv');
    });

    test('toJson produces snake_case keys', () {
      final model = ExportJobModel.fromJson(json);
      final output = model.toJson();
      expect(output['start_date'], 1704067200000);
      expect(output['end_date'], 1706745600000);
      expect(output['created_at'], 1708214400000);
      expect(output['download_url'], 'https://example.com/export.csv');
    });

    test('toEntity converts correctly', () {
      final model = ExportJobModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, 'exp-001');
      expect(entity.status, PaymentStatus.completed);
      expect(entity.downloadUrl, 'https://example.com/export.csv');
      expect(entity.startDate, isA<DateTime>());
      expect(entity.endDate, isA<DateTime>());
    });

    test('toEntity without downloadUrl', () {
      final noUrl = Map<String, dynamic>.from(json)..remove('download_url');
      final entity = ExportJobModel.fromJson(noUrl).toEntity();
      expect(entity.downloadUrl, isNull);
    });

    test('toEntity parses unknown status as pending', () {
      final unknown = Map<String, dynamic>.from(json)..['status'] = 'unknown';
      final entity = ExportJobModel.fromJson(unknown).toEntity();
      expect(entity.status, PaymentStatus.pending);
    });

    test('round-trip serialization preserves data', () {
      final model = ExportJobModel.fromJson(json);
      final roundTrip = ExportJobModel.fromJson(model.toJson());
      expect(roundTrip, equals(model));
    });
  });
}
