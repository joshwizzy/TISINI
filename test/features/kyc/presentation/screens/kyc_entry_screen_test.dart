import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/kyc/domain/entities/kyc_flow_state.dart';
import 'package:tisini/features/kyc/presentation/screens/kyc_entry_screen.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';
import 'package:tisini/features/kyc/providers/kyc_provider.dart';

class MockKycFlowController extends KycFlowController {
  MockKycFlowController(this._state);

  final KycFlowState _state;

  @override
  Future<KycFlowState> build() async => _state;
}

void main() {
  group('KycEntryScreen', () {
    testWidgets('renders KYC Verification app bar title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(const KycFlowState.idle()),
            ),
            kycSubmissionStatusProvider.overrideWith((ref) async => null),
          ],
          child: const MaterialApp(home: KycEntryScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('KYC Verification'), findsOneWidget);
    });

    testWidgets('renders Verify your identity heading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(const KycFlowState.idle()),
            ),
            kycSubmissionStatusProvider.overrideWith((ref) async => null),
          ],
          child: const MaterialApp(home: KycEntryScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Verify your identity'), findsOneWidget);
    });

    testWidgets('renders Get started button when idle', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            kycFlowControllerProvider.overrideWith(
              () => MockKycFlowController(const KycFlowState.idle()),
            ),
            kycSubmissionStatusProvider.overrideWith((ref) async => null),
          ],
          child: const MaterialApp(home: KycEntryScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Get started'), findsOneWidget);
    });
  });
}
