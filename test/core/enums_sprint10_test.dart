import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';

void main() {
  group('ImportSource', () {
    test('has bank value', () {
      expect(ImportSource.bank, isNotNull);
    });

    test('has mobileMoney value', () {
      expect(ImportSource.mobileMoney, isNotNull);
    });

    test('has 2 values', () {
      expect(ImportSource.values.length, 2);
    });
  });

  group('ImportJobStatus', () {
    test('has all 5 values', () {
      expect(ImportJobStatus.values.length, 5);
      expect(ImportJobStatus.uploading, isNotNull);
      expect(ImportJobStatus.mapping, isNotNull);
      expect(ImportJobStatus.processing, isNotNull);
      expect(ImportJobStatus.completed, isNotNull);
      expect(ImportJobStatus.failed, isNotNull);
    });
  });

  group('KycDocumentType', () {
    test('has all 6 values', () {
      expect(KycDocumentType.values.length, 6);
      expect(KycDocumentType.idFront, isNotNull);
      expect(KycDocumentType.idBack, isNotNull);
      expect(KycDocumentType.selfie, isNotNull);
      expect(KycDocumentType.businessRegistration, isNotNull);
      expect(KycDocumentType.licence, isNotNull);
      expect(KycDocumentType.tin, isNotNull);
    });
  });
}
