import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/presentation/screens/kyc_failed_screen.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';

class MockKycFlowController extends KycFlowController {
  MockKycFlowController(this._state);

  final KycFlowState _state;

  @override
  Future<KycFlowState> build() async => _state;
}

void main() {
  group('KycFailedScreen', () {
    testWidgets('renders Verification failed text', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.failed(message: 'Document unclear'),
              ),
            ),
          ],
          child: const MaterialApp(home: KycFailedScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Verification failed'), findsOneWidget);
    });

    testWidgets('renders Try again button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.failed(message: 'Document unclear'),
              ),
            ),
          ],
          child: const MaterialApp(home: KycFailedScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('renders Contact support button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(
                const KycFlowState.failed(message: 'Document unclear'),
              ),
            ),
          ],
          child: const MaterialApp(home: KycFailedScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Contact support'), findsOneWidget);
    });
  });
}
