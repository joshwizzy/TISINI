import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/presentation/screens/kyc_account_type_screen.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';

class MockKycFlowController extends KycFlowController {
  MockKycFlowController(this._state);

  final KycFlowState _state;

  @override
  Future<KycFlowState> build() async => _state;
}

void main() {
  group('KycAccountTypeScreen', () {
    testWidgets('renders Account Type app bar title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(const KycFlowState.idle()),
            ),
          ],
          child: const MaterialApp(home: KycAccountTypeScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Account Type'), findsOneWidget);
    });

    testWidgets('renders Business card', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(const KycFlowState.idle()),
            ),
          ],
          child: const MaterialApp(home: KycAccountTypeScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Business'), findsOneWidget);
    });

    testWidgets('renders Gig Worker card', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(const KycFlowState.idle()),
            ),
          ],
          child: const MaterialApp(home: KycAccountTypeScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Gig Worker'), findsOneWidget);
    });
  });
}
