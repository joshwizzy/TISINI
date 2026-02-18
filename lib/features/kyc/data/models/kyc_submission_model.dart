import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/kyc/data/models/kyc_document_model.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_submission.dart';

part 'kyc_submission_model.freezed.dart';
part 'kyc_submission_model.g.dart';

@freezed
class KycSubmissionModel with _$KycSubmissionModel {
  const factory KycSubmissionModel({
    required String id,
    @JsonKey(name: 'account_type') required String accountType,
    required String status,
    required List<KycDocumentModel> documents,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'submitted_at') int? submittedAt,
    @JsonKey(name: 'reviewed_at') int? reviewedAt,
  }) = _KycSubmissionModel;

  const KycSubmissionModel._();

  factory KycSubmissionModel.fromJson(Map<String, dynamic> json) =>
      _$KycSubmissionModelFromJson(json);

  KycSubmission toEntity() => KycSubmission(
    id: id,
    accountType: _parseAccountType(accountType),
    status: _parseStatus(status),
    documents: documents.map((d) => d.toEntity()).toList(),
    rejectionReason: rejectionReason,
    submittedAt: submittedAt != null
        ? DateTime.fromMillisecondsSinceEpoch(submittedAt!)
        : null,
    reviewedAt: reviewedAt != null
        ? DateTime.fromMillisecondsSinceEpoch(reviewedAt!)
        : null,
  );

  static KycAccountType _parseAccountType(String type) {
    return switch (type) {
      'business' => KycAccountType.business,
      'gig' => KycAccountType.gig,
      _ => KycAccountType.business,
    };
  }

  static KycStatus _parseStatus(String status) {
    return switch (status) {
      'not_started' => KycStatus.notStarted,
      'in_progress' => KycStatus.inProgress,
      'pending' => KycStatus.pending,
      'approved' => KycStatus.approved,
      'failed' => KycStatus.failed,
      _ => KycStatus.notStarted,
    };
  }
}
