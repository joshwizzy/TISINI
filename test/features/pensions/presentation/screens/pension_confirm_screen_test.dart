import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribute_state.dart';
import 'package:tisini/features/pensions/presentation/screens/pension_confirm_screen.dart';
import 'package:tisini/features/pensions/providers/pension_contribute_controller.dart';

class TestPensionContributeController extends PensionContributeController {
  TestPensionContributeController(this._initialState);

  final PensionContributeState _initialState;

  @override
  Future<PensionContributeState> build() async => _initialState;
}

void main() {
  const route = PaymentRoute(
    rail: PaymentRail.mobileMoney,
    label: 'Mobile Money',
    isAvailable: true,
    fee: 500,
  );

  group('PensionConfirmScreen', () {
    testWidgets('shows confirm details', (tester) async {
      const state = PensionContributeState.confirming(
        amount: 5000000,
        currency: 'UGX',
        route: route,
        fee: 500,
        total: 5000500,
        reference: 'NSSF Mar 2026',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pensionContributeControllerProvider.overrideWith(
              () => TestPensionContributeController(state),
            ),
          ],
          child: const MaterialApp(home: PensionConfirmScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Contributing to'), findsOneWidget);
      expect(find.text('NSSF Pension'), findsOneWidget);
      expect(find.text('NSSF Mar 2026'), findsOneWidget);
      expect(find.text('Via'), findsOneWidget);
      expect(find.text('Pay'), findsOneWidget);
    });

    testWidgets('shows processing spinner', (tester) async {
      const state = PensionContributeState.processing();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pensionContributeControllerProvider.overrideWith(
              () => TestPensionContributeController(state),
            ),
          ],
          child: const MaterialApp(home: PensionConfirmScreen()),
        ),
      );

      // Use pump() instead of pumpAndSettle() since
      // CircularProgressIndicator animates indefinitely
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
