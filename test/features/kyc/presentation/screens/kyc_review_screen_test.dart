import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/presentation/screens/kyc_review_screen.dart';
import 'package:tisini/features/kyc/presentation/widgets/document_thumbnail.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';

class MockKycFlowController extends KycFlowController {
  MockKycFlowController(this._state);

  final KycFlowState _state;

  @override
  Future<KycFlowState> build() async => _state;
}

void main() {
  group('KycReviewScreen', () {
    const documents = [
      KycDocument(id: 'd1', type: KycDocumentType.idFront, isUploaded: true),
      KycDocument(id: 'd2', type: KycDocumentType.idBack, isUploaded: true),
      KycDocument(id: 'd3', type: KycDocumentType.selfie, isUploaded: true),
    ];

    testWidgets('renders Review app bar title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.gig,
                  documents: documents,
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: KycReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Review'), findsOneWidget);
    });

    testWidgets('renders Review your submission heading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.gig,
                  documents: documents,
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: KycReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Review your submission'), findsOneWidget);
    });

    testWidgets('renders account type label for gig', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.gig,
                  documents: documents,
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: KycReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Account type: Gig Worker'), findsOneWidget);
    });

    testWidgets('renders account type label for business', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.business,
                  documents: documents,
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: KycReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Account type: Business'), findsOneWidget);
    });

    testWidgets('renders document thumbnails', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.gig,
                  documents: documents,
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: KycReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(DocumentThumbnail), findsNWidgets(3));
    });

    testWidgets('renders Submit for review button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.gig,
                  documents: documents,
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: KycReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Submit for review'), findsOneWidget);
    });

    testWidgets('shows loading when in submitting state', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(const KycFlowState.submitting()),
            ),
          ],
          child: const MaterialApp(home: KycReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
