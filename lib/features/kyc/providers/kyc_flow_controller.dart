import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/providers/kyc_provider.dart';

class KycFlowController extends AutoDisposeAsyncNotifier<KycFlowState> {
  @override
  Future<KycFlowState> build() async {
    final repo = ref.watch(kycRepositoryProvider);
    final submission = await repo.getStatus();

    if (submission == null || submission.status == KycStatus.notStarted) {
      return const KycFlowState.idle();
    }

    if (submission.status == KycStatus.approved) {
      return KycFlowState.success(submissionId: submission.id);
    }

    if (submission.status == KycStatus.failed) {
      return KycFlowState.failed(
        message: submission.rejectionReason ?? 'Verification failed',
      );
    }

    return KycFlowState.reviewing(submission: submission);
  }

  void selectAccountType(KycAccountType type) {
    state = AsyncData(
      KycFlowState.capturingDocuments(accountType: type, documents: []),
    );
  }

  void captureDocument(KycDocument doc) {
    final current = state.valueOrNull;
    if (current is! KycCapturingDocuments) return;

    final docs = List<KycDocument>.from(current.documents);
    final existingIndex = docs.indexWhere((d) => d.type == doc.type);
    if (existingIndex >= 0) {
      docs[existingIndex] = doc;
    } else {
      docs.add(doc);
    }

    state = AsyncData(
      KycFlowState.capturingDocuments(
        accountType: current.accountType,
        documents: docs,
      ),
    );
  }

  Future<void> submitForReview() async {
    final current = state.valueOrNull;
    if (current is! KycCapturingDocuments) return;

    state = const AsyncData(KycFlowState.submitting());

    try {
      final repo = ref.read(kycRepositoryProvider);
      final submission = await repo.submitKyc(
        accountType: current.accountType,
        documents: current.documents,
      );

      state = AsyncData(KycFlowState.success(submissionId: submission.id));
    } on AppException catch (e) {
      state = AsyncData(KycFlowState.failed(message: e.message));
    } on Exception {
      state = const AsyncData(
        KycFlowState.failed(message: 'Submission failed'),
      );
    }
  }

  void retry() {
    state = const AsyncData(KycFlowState.selectingAccountType());
  }

  void reset() {
    state = const AsyncData(KycFlowState.idle());
  }
}

final kycFlowControllerProvider =
    AutoDisposeAsyncNotifierProvider<KycFlowController, KycFlowState>(
      KycFlowController.new,
    );
