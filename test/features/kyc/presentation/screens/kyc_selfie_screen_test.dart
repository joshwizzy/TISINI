import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_submission.dart';
import 'package:tisini/features/kyc/domain/repositories/kyc_repository.dart';
import 'package:tisini/features/kyc/presentation/screens/kyc_selfie_screen.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';
import 'package:tisini/features/kyc/providers/kyc_provider.dart';

class MockKycFlowController extends KycFlowController {
  MockKycFlowController(this._state);

  final KycFlowState _state;

  @override
  Future<KycFlowState> build() async => _state;
}

class FakeKycRepository implements KycRepository {
  @override
  Future<KycDocument> captureDocument({required KycDocumentType type}) async {
    return KycDocument(id: 'doc-selfie', type: type, isUploaded: true);
  }

  @override
  Future<KycSubmission?> getStatus() async => null;

  @override
  Future<KycSubmission> submitKyc({
    required KycAccountType accountType,
    required List<KycDocument> documents,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<KycSubmission> retryKyc({
    required String submissionId,
    required List<KycDocument> documents,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  group('KycSelfieScreen', () {
    testWidgets('renders Selfie app bar title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.gig,
                  documents: [],
                ),
              ),
            ),
            kycRepositoryProvider.overrideWithValue(FakeKycRepository()),
          ],
          child: const MaterialApp(home: KycSelfieScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Selfie'), findsOneWidget);
    });

    testWidgets('renders Capture button initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.gig,
                  documents: [],
                ),
              ),
            ),
            kycRepositoryProvider.overrideWithValue(FakeKycRepository()),
          ],
          child: const MaterialApp(home: KycSelfieScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Capture'), findsOneWidget);
    });

    testWidgets('renders position instruction text', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.gig,
                  documents: [],
                ),
              ),
            ),
            kycRepositoryProvider.overrideWithValue(FakeKycRepository()),
          ],
          child: const MaterialApp(home: KycSelfieScreen()),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Position your face within'), findsOneWidget);
    });

    testWidgets('shows Retake and Use this after capture', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.gig,
                  documents: [],
                ),
              ),
            ),
            kycRepositoryProvider.overrideWithValue(FakeKycRepository()),
          ],
          child: const MaterialApp(home: KycSelfieScreen()),
        ),
      );
      await tester.pump();

      await tester.runAsync(() async {
        await tester.tap(find.text('Capture'));
      });
      await tester.pump();

      expect(find.text('Retake'), findsOneWidget);
      expect(find.text('Use this'), findsOneWidget);
      expect(find.text('Selfie captured'), findsOneWidget);
    });
  });
}
