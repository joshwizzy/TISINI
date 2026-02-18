import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_submission.dart';

void main() {
  const documents = [
    KycDocument(
      id: 'doc-001',
      type: KycDocumentType.idFront,
      isUploaded: true,
      filePath: '/path/to/id_front.jpg',
    ),
    KycDocument(
      id: 'doc-002',
      type: KycDocumentType.idBack,
      isUploaded: true,
      filePath: '/path/to/id_back.jpg',
    ),
  ];

  const submission = KycSubmission(
    id: 'sub-001',
    accountType: KycAccountType.business,
    status: KycStatus.pending,
    documents: documents,
  );

  group('KycFlowState', () {
    test('idle creates idle state', () {
      const state = KycFlowState.idle();

      expect(state, isA<KycIdle>());
    });

    test('selectingAccountType creates selecting state', () {
      const state = KycFlowState.selectingAccountType();

      expect(state, isA<KycSelectingAccountType>());
    });

    test('capturingDocuments holds accountType and documents', () {
      const state = KycFlowState.capturingDocuments(
        accountType: KycAccountType.business,
        documents: documents,
      );

      expect(state, isA<KycCapturingDocuments>());
      const capturing = state as KycCapturingDocuments;
      expect(capturing.accountType, KycAccountType.business);
      expect(capturing.documents, documents);
      expect(capturing.documents, hasLength(2));
    });

    test('capturingDocuments with empty documents list', () {
      const state = KycFlowState.capturingDocuments(
        accountType: KycAccountType.gig,
        documents: [],
      );

      const capturing = state as KycCapturingDocuments;
      expect(capturing.accountType, KycAccountType.gig);
      expect(capturing.documents, isEmpty);
    });

    test('reviewing holds submission', () {
      const state = KycFlowState.reviewing(submission: submission);

      expect(state, isA<KycReviewing>());
      const reviewing = state as KycReviewing;
      expect(reviewing.submission, submission);
      expect(reviewing.submission.id, 'sub-001');
      expect(reviewing.submission.accountType, KycAccountType.business);
    });

    test('submitting creates submitting state', () {
      const state = KycFlowState.submitting();

      expect(state, isA<KycSubmitting>());
    });

    test('success holds submissionId', () {
      const state = KycFlowState.success(submissionId: 'sub-001');

      expect(state, isA<KycSuccess>());
      const success = state as KycSuccess;
      expect(success.submissionId, 'sub-001');
    });

    test('failed holds message', () {
      const state = KycFlowState.failed(message: 'Document upload failed');

      expect(state, isA<KycFailed>());
      const failed = state as KycFailed;
      expect(failed.message, 'Document upload failed');
    });

    test('equality works for identical states', () {
      const a = KycFlowState.idle();
      const b = KycFlowState.idle();

      expect(a, equals(b));
    });

    test('inequality works for different states', () {
      const idle = KycFlowState.idle();
      const submitting = KycFlowState.submitting();

      expect(idle, isNot(equals(submitting)));
    });

    test('equality works for states with data', () {
      const a = KycFlowState.success(submissionId: 'sub-001');
      const b = KycFlowState.success(submissionId: 'sub-001');

      expect(a, equals(b));
    });

    test('different submissionIds are not equal', () {
      const a = KycFlowState.success(submissionId: 'sub-001');
      const b = KycFlowState.success(submissionId: 'sub-002');

      expect(a, isNot(equals(b)));
    });
  });
}
