import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/data/datasources/mock_kyc_remote_datasource.dart';
import 'package:tisini/features/kyc/data/models/kyc_document_model.dart';

void main() {
  late MockKycRemoteDatasource datasource;

  setUp(() {
    datasource = MockKycRemoteDatasource();
  });

  group('MockKycRemoteDatasource', () {
    group('getStatus', () {
      test('returns null initially', () async {
        final status = await datasource.getStatus();

        expect(status, isNull);
      });

      test('returns stored submission after submitKyc', () async {
        await datasource.submitKyc(
          accountType: KycAccountType.business,
          documents: const [
            KycDocumentModel(id: 'doc-1', type: 'id_front', isUploaded: true),
          ],
        );

        final status = await datasource.getStatus();

        expect(status, isNotNull);
        expect(status!.status, 'pending');
        expect(status.accountType, 'business');
      });
    });

    group('submitKyc', () {
      test('stores and returns submission with status pending', () async {
        final submission = await datasource.submitKyc(
          accountType: KycAccountType.gig,
          documents: const [
            KycDocumentModel(id: 'doc-1', type: 'id_front', isUploaded: true),
            KycDocumentModel(id: 'doc-2', type: 'selfie', isUploaded: true),
          ],
        );

        expect(submission.id, isNotEmpty);
        expect(submission.status, 'pending');
        expect(submission.accountType, 'gig');
        expect(submission.documents, hasLength(2));
        expect(submission.submittedAt, isNotNull);
      });
    });

    group('captureDocument', () {
      test('returns doc with file_path containing the type name', () async {
        final doc = await datasource.captureDocument(
          type: KycDocumentType.idFront,
        );

        expect(doc.id, isNotEmpty);
        expect(doc.type, 'id_front');
        expect(doc.filePath, contains('id_front'));
        expect(doc.isUploaded, isFalse);
      });

      test('returns doc with selfie type name in path', () async {
        final doc = await datasource.captureDocument(
          type: KycDocumentType.selfie,
        );

        expect(doc.type, 'selfie');
        expect(doc.filePath, contains('selfie'));
      });
    });

    group('retryKyc', () {
      test('resets submission to pending', () async {
        // First submit
        await datasource.submitKyc(
          accountType: KycAccountType.business,
          documents: const [
            KycDocumentModel(id: 'doc-1', type: 'id_front', isUploaded: true),
          ],
        );

        // Retry with new documents
        final retried = await datasource.retryKyc(
          submissionId: 'kyc-retry',
          documents: const [
            KycDocumentModel(id: 'doc-3', type: 'id_front', isUploaded: true),
            KycDocumentModel(id: 'doc-4', type: 'selfie', isUploaded: true),
          ],
        );

        expect(retried.id, 'kyc-retry');
        expect(retried.status, 'pending');
        expect(retried.documents, hasLength(2));
        expect(retried.accountType, 'business');
      });
    });
  });
}
