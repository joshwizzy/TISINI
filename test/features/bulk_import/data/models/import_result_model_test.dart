import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/data/models/import_result_model.dart';

void main() {
  group('ImportResultModel', () {
    final json = <String, dynamic>{
      'job_id': 'job-001',
      'total_imported': 95,
      'categorised': 80,
      'uncategorised': 15,
      'errors': <String>[
        'Row 12: invalid date format',
        'Row 47: missing amount',
      ],
    };

    test('fromJson parses correctly', () {
      final model = ImportResultModel.fromJson(json);
      expect(model.jobId, 'job-001');
      expect(model.totalImported, 95);
      expect(model.categorised, 80);
      expect(model.uncategorised, 15);
      expect(model.errors, hasLength(2));
      expect(model.errors.first, 'Row 12: invalid date format');
      expect(model.errors.last, 'Row 47: missing amount');
    });

    test('toJson produces snake_case keys', () {
      final model = ImportResultModel.fromJson(json);
      final output = model.toJson();
      expect(output['job_id'], 'job-001');
      expect(output['total_imported'], 95);
      expect(output['categorised'], 80);
      expect(output['uncategorised'], 15);
      expect(output['errors'], isA<List<dynamic>>());
      expect((output['errors'] as List).length, 2);
    });

    test('toEntity converts correctly', () {
      final model = ImportResultModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.jobId, 'job-001');
      expect(entity.totalImported, 95);
      expect(entity.categorised, 80);
      expect(entity.uncategorised, 15);
      expect(entity.errors, hasLength(2));
      expect(entity.errors.first, 'Row 12: invalid date format');
    });

    test('toEntity with empty errors list', () {
      final noErrors = Map<String, dynamic>.from(json)..['errors'] = <String>[];
      final entity = ImportResultModel.fromJson(noErrors).toEntity();
      expect(entity.errors, isEmpty);
    });

    test('round-trip serialization preserves data', () {
      final model = ImportResultModel.fromJson(json);
      final roundTrip = ImportResultModel.fromJson(model.toJson());
      expect(roundTrip, equals(model));
    });
  });
}
