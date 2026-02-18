import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/topup_state.dart';
import 'package:tisini/features/pay/presentation/screens/topup/topup_receipt_screen.dart';
import 'package:tisini/features/pay/providers/topup_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        topupControllerProvider.overrideWith(_MockTopupController.new),
      ],
      child: const MaterialApp(
        home: TopupReceiptScreen(transactionId: 'tx-topup-001'),
      ),
    );
  }

  group('TopupReceiptScreen', () {
    testWidgets('renders Payment Successful', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('Payment Successful'), findsOneWidget);
    });

    testWidgets('renders Done button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('Done'), findsOneWidget);
    });
  });
}

class _MockTopupController extends TopupController {
  @override
  Future<TopupState> build() async {
    return TopupState.receipt(
      receipt: PaymentReceipt(
        transactionId: 'tx-topup-001',
        receiptNumber: 'RCP-TOPUP-001',
        type: PaymentType.topUp,
        status: PaymentStatus.completed,
        amount: 100000,
        currency: 'UGX',
        fee: 500,
        total: 100500,
        rail: PaymentRail.mobileMoney,
        payeeName: 'Tisini Wallet',
        payeeIdentifier: 'wallet',
        timestamp: DateTime(2024),
      ),
    );
  }
}
