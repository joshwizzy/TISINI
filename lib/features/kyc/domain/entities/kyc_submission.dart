import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';

part 'kyc_submission.freezed.dart';

@freezed
class KycSubmission with _$KycSubmission {
  const factory KycSubmission({
    required String id,
    required KycAccountType accountType,
    required KycStatus status,
    required List<KycDocument> documents,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? reviewedAt,
  }) = _KycSubmission;
}
