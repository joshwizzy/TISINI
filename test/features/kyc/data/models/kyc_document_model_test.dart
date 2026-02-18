import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/data/models/kyc_document_model.dart';

void main() {
  group('KycDocumentModel', () {
    final json = <String, dynamic>{
      'id': 'doc-001',
      'type': 'id_front',
      'is_uploaded': true,
      'file_path': '/uploads/id_front.jpg',
    };

    test('fromJson parses correctly', () {
      final model = KycDocumentModel.fromJson(json);
      expect(model.id, 'doc-001');
      expect(model.type, 'id_front');
      expect(model.isUploaded, true);
      expect(model.filePath, '/uploads/id_front.jpg');
    });

    test('toJson produces snake_case keys', () {
      final model = KycDocumentModel.fromJson(json);
      final output = model.toJson();
      expect(output['id'], 'doc-001');
      expect(output['type'], 'id_front');
      expect(output['is_uploaded'], true);
      expect(output['file_path'], '/uploads/id_front.jpg');
    });

    test('toEntity converts correctly', () {
      final model = KycDocumentModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, 'doc-001');
      expect(entity.type, KycDocumentType.idFront);
      expect(entity.isUploaded, true);
      expect(entity.filePath, '/uploads/id_front.jpg');
    });

    test('toEntity parses all document types', () {
      for (final entry in <String, KycDocumentType>{
        'id_front': KycDocumentType.idFront,
        'id_back': KycDocumentType.idBack,
        'selfie': KycDocumentType.selfie,
        'business_registration': KycDocumentType.businessRegistration,
        'licence': KycDocumentType.licence,
        'tin': KycDocumentType.tin,
      }.entries) {
        final typeJson = Map<String, dynamic>.from(json)..['type'] = entry.key;
        final entity = KycDocumentModel.fromJson(typeJson).toEntity();
        expect(entity.type, entry.value);
      }
    });

    test('toEntity parses unknown type as idFront', () {
      final unknown = Map<String, dynamic>.from(json)..['type'] = 'unknown';
      final entity = KycDocumentModel.fromJson(unknown).toEntity();
      expect(entity.type, KycDocumentType.idFront);
    });

    test('toEntity without filePath', () {
      final noPath = Map<String, dynamic>.from(json)..remove('file_path');
      final entity = KycDocumentModel.fromJson(noPath).toEntity();
      expect(entity.filePath, isNull);
    });

    test('fromJson with isUploaded false', () {
      final notUploaded = Map<String, dynamic>.from(json)
        ..['is_uploaded'] = false
        ..remove('file_path');
      final model = KycDocumentModel.fromJson(notUploaded);
      expect(model.isUploaded, false);
      expect(model.filePath, isNull);
    });

    test('round-trip serialization preserves data', () {
      final model = KycDocumentModel.fromJson(json);
      final roundTrip = KycDocumentModel.fromJson(model.toJson());
      expect(roundTrip, equals(model));
    });
  });
}
