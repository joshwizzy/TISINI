import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/data/datasources/kyc_remote_datasource.dart';
import 'package:tisini/features/kyc/data/models/kyc_document_model.dart';
import 'package:tisini/features/kyc/data/models/kyc_submission_model.dart';

class MockKycRemoteDatasource implements KycRemoteDatasource {
  static const _readDelay = Duration(milliseconds: 300);
  static const _writeDelay = Duration(milliseconds: 800);

  KycSubmissionModel? _storedSubmission;

  @override
  Future<KycSubmissionModel?> getStatus() async {
    await Future<void>.delayed(_readDelay);
    return _storedSubmission;
  }

  @override
  Future<KycSubmissionModel> submitKyc({
    required KycAccountType accountType,
    required List<KycDocumentModel> documents,
  }) async {
    await Future<void>.delayed(_writeDelay);
    final now = DateTime.now().millisecondsSinceEpoch;

    final submission = KycSubmissionModel(
      id: 'kyc-${now.hashCode.abs()}',
      accountType: accountType == KycAccountType.business ? 'business' : 'gig',
      status: 'pending',
      documents: documents,
      submittedAt: now,
    );

    _storedSubmission = submission;
    return submission;
  }

  @override
  Future<KycSubmissionModel> retryKyc({
    required String submissionId,
    required List<KycDocumentModel> documents,
  }) async {
    await Future<void>.delayed(_writeDelay);
    final now = DateTime.now().millisecondsSinceEpoch;

    final submission = KycSubmissionModel(
      id: submissionId,
      accountType: _storedSubmission?.accountType ?? 'business',
      status: 'pending',
      documents: documents,
      submittedAt: now,
    );

    _storedSubmission = submission;
    return submission;
  }

  @override
  Future<KycDocumentModel> captureDocument({
    required KycDocumentType type,
  }) async {
    await Future<void>.delayed(_writeDelay);
    final now = DateTime.now().millisecondsSinceEpoch;
    final typeName = _typeToString(type);

    return KycDocumentModel(
      id: 'doc-${now.hashCode.abs()}',
      type: typeName,
      filePath: '/tmp/kyc_${typeName}_$now.jpg',
      isUploaded: false,
    );
  }

  static String _typeToString(KycDocumentType type) {
    return switch (type) {
      KycDocumentType.idFront => 'id_front',
      KycDocumentType.idBack => 'id_back',
      KycDocumentType.selfie => 'selfie',
      KycDocumentType.businessRegistration => 'business_registration',
      KycDocumentType.licence => 'licence',
      KycDocumentType.tin => 'tin',
    };
  }
}
