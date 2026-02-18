import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/data/models/kyc_document_model.dart';
import 'package:tisini/features/kyc/data/models/kyc_submission_model.dart';

abstract class KycRemoteDatasource {
  Future<KycSubmissionModel?> getStatus();

  Future<KycSubmissionModel> submitKyc({
    required KycAccountType accountType,
    required List<KycDocumentModel> documents,
  });

  Future<KycSubmissionModel> retryKyc({
    required String submissionId,
    required List<KycDocumentModel> documents,
  });

  Future<KycDocumentModel> captureDocument({required KycDocumentType type});
}
