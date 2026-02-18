import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_document.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/presentation/screens/kyc_checklist_screen.dart';
import 'package:tisini/features/kyc/presentation/widgets/document_checklist_item.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';

class MockKycFlowController extends KycFlowController {
  MockKycFlowController(this._state);

  final KycFlowState _state;

  @override
  Future<KycFlowState> build() async => _state;
}

void main() {
  group('KycChecklistScreen', () {
    testWidgets('renders Documents app bar title', (tester) async {
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
          ],
          child: const MaterialApp(home: KycChecklistScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Documents'), findsOneWidget);
    });

    testWidgets('renders 3 checklist items for gig account type', (
      tester,
    ) async {
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
          ],
          child: const MaterialApp(home: KycChecklistScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(DocumentChecklistItem), findsNWidgets(3));
      expect(find.text('ID Card (Front)'), findsOneWidget);
      expect(find.text('ID Card (Back)'), findsOneWidget);
      expect(find.text('Selfie'), findsOneWidget);
    });

    testWidgets('renders 4 checklist items for business account type', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.business,
                  documents: [],
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: KycChecklistScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(DocumentChecklistItem), findsNWidgets(4));
      expect(find.text('Business Registration'), findsOneWidget);
    });

    testWidgets('Continue button disabled when no documents captured', (
      tester,
    ) async {
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
          ],
          child: const MaterialApp(home: KycChecklistScreen()),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Continue'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Continue button enabled when all gig docs captured', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.capturingDocuments(
                  accountType: KycAccountType.gig,
                  documents: [
                    KycDocument(
                      id: 'd1',
                      type: KycDocumentType.idFront,
                      isUploaded: true,
                    ),
                    KycDocument(
                      id: 'd2',
                      type: KycDocumentType.idBack,
                      isUploaded: true,
                    ),
                    KycDocument(
                      id: 'd3',
                      type: KycDocumentType.selfie,
                      isUploaded: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: KycChecklistScreen()),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Continue'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('shows loading when state is not capturing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(const KycFlowState.idle()),
            ),
          ],
          child: const MaterialApp(home: KycChecklistScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
