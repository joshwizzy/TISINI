import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';

void main() {
  group('KycDocument', () {
    test('creates with all fields', () {
      const document = KycDocument(
        id: 'doc-001',
        type: KycDocumentType.idFront,
        isUploaded: true,
        filePath: '/path/to/id_front.jpg',
      );

      expect(document.id, 'doc-001');
      expect(document.type, KycDocumentType.idFront);
      expect(document.isUploaded, isTrue);
      expect(document.filePath, '/path/to/id_front.jpg');
    });

    test('creates with optional filePath as null', () {
      const document = KycDocument(
        id: 'doc-002',
        type: KycDocumentType.selfie,
        isUploaded: false,
      );

      expect(document.id, 'doc-002');
      expect(document.type, KycDocumentType.selfie);
      expect(document.isUploaded, isFalse);
      expect(document.filePath, isNull);
    });

    test('supports value equality', () {
      const a = KycDocument(
        id: 'doc-001',
        type: KycDocumentType.idFront,
        isUploaded: true,
        filePath: '/path/to/id_front.jpg',
      );
      const b = KycDocument(
        id: 'doc-001',
        type: KycDocumentType.idFront,
        isUploaded: true,
        filePath: '/path/to/id_front.jpg',
      );

      expect(a, equals(b));
    });

    test('different ids are not equal', () {
      const a = KycDocument(
        id: 'doc-001',
        type: KycDocumentType.idFront,
        isUploaded: true,
      );
      const b = KycDocument(
        id: 'doc-002',
        type: KycDocumentType.idFront,
        isUploaded: true,
      );

      expect(a, isNot(equals(b)));
    });

    test('different types are not equal', () {
      const a = KycDocument(
        id: 'doc-001',
        type: KycDocumentType.idFront,
        isUploaded: true,
      );
      const b = KycDocument(
        id: 'doc-001',
        type: KycDocumentType.idBack,
        isUploaded: true,
      );

      expect(a, isNot(equals(b)));
    });

    test('supports all document types', () {
      for (final type in KycDocumentType.values) {
        final document = KycDocument(
          id: 'doc-${type.name}',
          type: type,
          isUploaded: false,
        );

        expect(document.type, type);
      }
    });
  });
}
