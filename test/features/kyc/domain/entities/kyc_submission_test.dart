import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_submission.dart';

void main() {
  group('KycSubmission', () {
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
      KycDocument(
        id: 'doc-003',
        type: KycDocumentType.selfie,
        isUploaded: true,
        filePath: '/path/to/selfie.jpg',
      ),
    ];

    test('creates with required fields only', () {
      const submission = KycSubmission(
        id: 'sub-001',
        accountType: KycAccountType.business,
        status: KycStatus.inProgress,
        documents: documents,
      );

      expect(submission.id, 'sub-001');
      expect(submission.accountType, KycAccountType.business);
      expect(submission.status, KycStatus.inProgress);
      expect(submission.documents, documents);
      expect(submission.documents, hasLength(3));
      expect(submission.rejectionReason, isNull);
      expect(submission.submittedAt, isNull);
      expect(submission.reviewedAt, isNull);
    });

    test('creates with all optional fields', () {
      final submittedAt = DateTime(2026, 1, 10, 9, 30);
      final reviewedAt = DateTime(2026, 1, 11, 14);

      final submission = KycSubmission(
        id: 'sub-002',
        accountType: KycAccountType.gig,
        status: KycStatus.failed,
        documents: documents,
        rejectionReason: 'ID photo is blurry',
        submittedAt: submittedAt,
        reviewedAt: reviewedAt,
      );

      expect(submission.rejectionReason, 'ID photo is blurry');
      expect(submission.submittedAt, submittedAt);
      expect(submission.reviewedAt, reviewedAt);
    });

    test('creates with empty documents list', () {
      const submission = KycSubmission(
        id: 'sub-003',
        accountType: KycAccountType.business,
        status: KycStatus.notStarted,
        documents: [],
      );

      expect(submission.documents, isEmpty);
    });

    test('supports value equality', () {
      const a = KycSubmission(
        id: 'sub-001',
        accountType: KycAccountType.business,
        status: KycStatus.pending,
        documents: documents,
      );
      const b = KycSubmission(
        id: 'sub-001',
        accountType: KycAccountType.business,
        status: KycStatus.pending,
        documents: documents,
      );

      expect(a, equals(b));
    });

    test('different statuses are not equal', () {
      const a = KycSubmission(
        id: 'sub-001',
        accountType: KycAccountType.business,
        status: KycStatus.pending,
        documents: documents,
      );
      const b = KycSubmission(
        id: 'sub-001',
        accountType: KycAccountType.business,
        status: KycStatus.approved,
        documents: documents,
      );

      expect(a, isNot(equals(b)));
    });

    test('approved submission without rejection reason', () {
      final submission = KycSubmission(
        id: 'sub-004',
        accountType: KycAccountType.gig,
        status: KycStatus.approved,
        documents: documents,
        submittedAt: DateTime(2026, 1, 10),
        reviewedAt: DateTime(2026, 1, 12),
      );

      expect(submission.status, KycStatus.approved);
      expect(submission.rejectionReason, isNull);
      expect(submission.reviewedAt, isNotNull);
    });
  });
}
