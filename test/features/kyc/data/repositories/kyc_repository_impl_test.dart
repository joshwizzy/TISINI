import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/kyc/data/datasources/mock_kyc_remote_datasource.dart';
import 'package:tisini/features/kyc/data/repositories/kyc_repository_impl.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';

void main() {
  late KycRepositoryImpl repository;

  setUp(() {
    repository = KycRepositoryImpl(datasource: MockKycRemoteDatasource());
  });

  group('KycRepositoryImpl', () {
    test('getStatus returns null initially', () async {
      final status = await repository.getStatus();

      expect(status, isNull);
    });

    test(
      'submitKyc returns KycSubmission entity with pending status',
      () async {
        const docs = [
          KycDocument(
            id: 'doc-1',
            type: KycDocumentType.idFront,
            isUploaded: true,
          ),
          KycDocument(
            id: 'doc-2',
            type: KycDocumentType.selfie,
            isUploaded: true,
          ),
        ];

        final submission = await repository.submitKyc(
          accountType: KycAccountType.business,
          documents: docs,
        );

        expect(submission.id, isNotEmpty);
        expect(submission.status, KycStatus.pending);
        expect(submission.accountType, KycAccountType.business);
        expect(submission.documents, hasLength(2));
        expect(submission.submittedAt, isA<DateTime>());
      },
    );

    test('captureDocument returns KycDocument entity', () async {
      final doc = await repository.captureDocument(
        type: KycDocumentType.idBack,
      );

      expect(doc.id, isNotEmpty);
      expect(doc.type, KycDocumentType.idBack);
      expect(doc.filePath, contains('id_back'));
      expect(doc.isUploaded, isFalse);
    });

    test('retryKyc returns KycSubmission entity', () async {
      // First submit so there is a stored submission
      await repository.submitKyc(
        accountType: KycAccountType.gig,
        documents: const [
          KycDocument(
            id: 'doc-1',
            type: KycDocumentType.idFront,
            isUploaded: true,
          ),
        ],
      );

      const retryDocs = [
        KycDocument(
          id: 'doc-3',
          type: KycDocumentType.idFront,
          isUploaded: true,
        ),
        KycDocument(
          id: 'doc-4',
          type: KycDocumentType.selfie,
          isUploaded: true,
        ),
      ];

      final submission = await repository.retryKyc(
        submissionId: 'kyc-retry',
        documents: retryDocs,
      );

      expect(submission.id, 'kyc-retry');
      expect(submission.status, KycStatus.pending);
      expect(submission.documents, hasLength(2));
      expect(submission.submittedAt, isA<DateTime>());
    });
  });
}
