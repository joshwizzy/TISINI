import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/data/datasources/kyc_remote_datasource.dart';
import 'package:tisini/features/kyc/data/models/kyc_document_model.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_submission.dart';
import 'package:tisini/features/kyc/domain/repositories/kyc_repository.dart';

class KycRepositoryImpl implements KycRepository {
  KycRepositoryImpl({required KycRemoteDatasource datasource})
    : _datasource = datasource;

  final KycRemoteDatasource _datasource;

  @override
  Future<KycSubmission?> getStatus() async {
    final model = await _datasource.getStatus();
    return model?.toEntity();
  }

  @override
  Future<KycSubmission> submitKyc({
    required KycAccountType accountType,
    required List<KycDocument> documents,
  }) async {
    final docModels = documents
        .map(
          (d) => KycDocumentModel(
            id: d.id,
            type: _docTypeToString(d.type),
            filePath: d.filePath,
            isUploaded: d.isUploaded,
          ),
        )
        .toList();

    final model = await _datasource.submitKyc(
      accountType: accountType,
      documents: docModels,
    );
    return model.toEntity();
  }

  @override
  Future<KycSubmission> retryKyc({
    required String submissionId,
    required List<KycDocument> documents,
  }) async {
    final docModels = documents
        .map(
          (d) => KycDocumentModel(
            id: d.id,
            type: _docTypeToString(d.type),
            filePath: d.filePath,
            isUploaded: d.isUploaded,
          ),
        )
        .toList();

    final model = await _datasource.retryKyc(
      submissionId: submissionId,
      documents: docModels,
    );
    return model.toEntity();
  }

  @override
  Future<KycDocument> captureDocument({required KycDocumentType type}) async {
    final model = await _datasource.captureDocument(type: type);
    return model.toEntity();
  }

  static String _docTypeToString(KycDocumentType type) {
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
