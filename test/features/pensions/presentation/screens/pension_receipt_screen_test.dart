import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribute_state.dart';
import 'package:tisini/features/pensions/presentation/screens/pension_receipt_screen.dart';
import 'package:tisini/features/pensions/providers/pension_contribute_controller.dart';

class TestPensionContributeController extends PensionContributeController {
  TestPensionContributeController(this._initialState);

  final PensionContributeState _initialState;

  @override
  Future<PensionContributeState> build() async => _initialState;
}

void main() {
  group('PensionReceiptScreen', () {
    testWidgets('shows receipt from controller state', (tester) async {
      final receipt = PaymentReceipt(
        transactionId: 'tx-001',
        receiptNumber: 'RCP-001',
        type: PaymentType.pensionContribution,
        status: PaymentStatus.completed,
        amount: 5000000,
        currency: 'UGX',
        fee: 500,
        total: 5000500,
        rail: PaymentRail.mobileMoney,
        payeeName: 'NSSF',
        payeeIdentifier: 'NSSF-UG-123456',
        timestamp: DateTime(2026, 3, 15),
      );

      final state = PensionContributeState.receipt(receipt: receipt);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pensionContributeControllerProvider.overrideWith(
              () => TestPensionContributeController(state),
            ),
          ],
          child: const MaterialApp(
            home: PensionReceiptScreen(transactionId: 'tx-001'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Payment Successful'), findsOneWidget);
      expect(find.text('NSSF'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
    });
  });
}
