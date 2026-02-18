import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/providers/payment_routes_provider.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribute_state.dart';
import 'package:tisini/features/pensions/presentation/screens/pension_contribute_screen.dart';
import 'package:tisini/features/pensions/providers/pension_contribute_controller.dart';

class TestPensionContributeController extends PensionContributeController {
  @override
  Future<PensionContributeState> build() async {
    return const PensionContributeState.enteringAmount(
      currency: 'UGX',
      nextDueAmount: 5000000,
    );
  }
}

void main() {
  const testRoutes = [
    PaymentRoute(
      rail: PaymentRail.mobileMoney,
      label: 'Mobile Money',
      isAvailable: true,
      fee: 500,
    ),
  ];

  group('PensionContributeScreen', () {
    testWidgets('shows contribute form after loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pensionContributeControllerProvider.overrideWith(
              TestPensionContributeController.new,
            ),
            paymentRoutesProvider.overrideWith((ref) async => testRoutes),
          ],
          child: const MaterialApp(home: PensionContributeScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Contribute'), findsOneWidget);
      expect(find.text('NSSF Pension'), findsOneWidget);
      expect(find.text('National Social Security Fund'), findsOneWidget);
      expect(find.text('Pay via'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('shows reference field', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pensionContributeControllerProvider.overrideWith(
              TestPensionContributeController.new,
            ),
            paymentRoutesProvider.overrideWith((ref) async => testRoutes),
          ],
          child: const MaterialApp(home: PensionContributeScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Reference'), findsOneWidget);
    });

    testWidgets('pre-fills due amount', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pensionContributeControllerProvider.overrideWith(
              TestPensionContributeController.new,
            ),
            paymentRoutesProvider.overrideWith((ref) async => testRoutes),
          ],
          child: const MaterialApp(home: PensionContributeScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('5000000'), findsOneWidget);
    });
  });
}
