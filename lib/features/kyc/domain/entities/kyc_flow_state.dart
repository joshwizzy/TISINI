import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_submission.dart';

part 'kyc_flow_state.freezed.dart';

@freezed
sealed class KycFlowState with _$KycFlowState {
  const factory KycFlowState.idle() = KycIdle;

  const factory KycFlowState.selectingAccountType() = KycSelectingAccountType;

  const factory KycFlowState.capturingDocuments({
    required KycAccountType accountType,
    required List<KycDocument> documents,
  }) = KycCapturingDocuments;

  const factory KycFlowState.reviewing({required KycSubmission submission}) =
      KycReviewing;

  const factory KycFlowState.submitting() = KycSubmitting;

  const factory KycFlowState.success({required String submissionId}) =
      KycSuccess;

  const factory KycFlowState.failed({required String message}) = KycFailed;
}
