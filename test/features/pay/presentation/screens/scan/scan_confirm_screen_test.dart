import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/entities/scan_state.dart';
import 'package:tisini/features/pay/presentation/screens/scan/scan_confirm_screen.dart';
import 'package:tisini/features/pay/providers/payment_routes_provider.dart';
import 'package:tisini/features/pay/providers/scan_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        scanControllerProvider.overrideWith(_MockScanController.new),
        paymentRoutesProvider.overrideWith(
          (ref) async => [
            const PaymentRoute(
              rail: PaymentRail.mobileMoney,
              label: 'Mobile Money',
              isAvailable: true,
              fee: 500,
            ),
          ],
        ),
      ],
      child: const MaterialApp(home: ScanConfirmScreen()),
    );
  }

  group('ScanConfirmScreen', () {
    testWidgets('renders Confirm Payment app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Confirm Payment'), findsOneWidget);
    });

    testWidgets('renders payee name', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Jane Nakamya'), findsOneWidget);
    });

    testWidgets('renders Pay button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Pay'), findsOneWidget);
    });
  });
}

class _MockScanController extends ScanController {
  @override
  Future<ScanState> build() async {
    return const ScanState.resolved(
      payee: Payee(
        id: 'p-001',
        name: 'Jane Nakamya',
        identifier: '+256700100200',
        rail: PaymentRail.mobileMoney,
        isPinned: false,
      ),
    );
  }
}
