import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';

part 'kyc_document_model.freezed.dart';
part 'kyc_document_model.g.dart';

@freezed
class KycDocumentModel with _$KycDocumentModel {
  const factory KycDocumentModel({
    required String id,
    required String type,
    @JsonKey(name: 'is_uploaded') required bool isUploaded,
    @JsonKey(name: 'file_path') String? filePath,
  }) = _KycDocumentModel;

  const KycDocumentModel._();

  factory KycDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$KycDocumentModelFromJson(json);

  KycDocument toEntity() => KycDocument(
    id: id,
    type: _parseDocType(type),
    filePath: filePath,
    isUploaded: isUploaded,
  );

  static KycDocumentType _parseDocType(String type) {
    return switch (type) {
      'id_front' => KycDocumentType.idFront,
      'id_back' => KycDocumentType.idBack,
      'selfie' => KycDocumentType.selfie,
      'business_registration' => KycDocumentType.businessRegistration,
      'licence' => KycDocumentType.licence,
      'tin' => KycDocumentType.tin,
      _ => KycDocumentType.idFront,
    };
  }
}
