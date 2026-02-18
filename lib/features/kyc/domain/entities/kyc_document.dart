import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'kyc_document.freezed.dart';

@freezed
class KycDocument with _$KycDocument {
  const factory KycDocument({
    required String id,
    required KycDocumentType type,
    required bool isUploaded,
    String? filePath,
  }) = _KycDocument;
}
