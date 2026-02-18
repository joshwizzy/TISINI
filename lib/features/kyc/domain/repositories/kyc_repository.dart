import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_submission.dart';

abstract class KycRepository {
  Future<KycSubmission?> getStatus();

  Future<KycSubmission> submitKyc({
    required KycAccountType accountType,
    required List<KycDocument> documents,
  });

  Future<KycSubmission> retryKyc({
    required String submissionId,
    required List<KycDocument> documents,
  });

  Future<KycDocument> captureDocument({required KycDocumentType type});
}
