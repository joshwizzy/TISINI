import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_receipt_screen.dart';
import 'package:tisini/features/pay/providers/send_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [sendControllerProvider.overrideWith(_MockSendController.new)],
      child: const MaterialApp(
        home: SendReceiptScreen(transactionId: 'tx-001'),
      ),
    );
  }

  group('SendReceiptScreen', () {
    testWidgets('renders Payment Successful', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('Payment Successful'), findsOneWidget);
    });

    testWidgets('renders payee name', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('Jane Nakamya'), findsOneWidget);
    });

    testWidgets('renders Done button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('renders Share button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('Share'), findsOneWidget);
    });
  });
}

class _MockSendController extends SendController {
  @override
  Future<SendState> build() async {
    return SendState.receipt(
      receipt: PaymentReceipt(
        transactionId: 'tx-001',
        receiptNumber: 'RCP-001',
        type: PaymentType.send,
        status: PaymentStatus.completed,
        amount: 150000,
        currency: 'UGX',
        fee: 500,
        total: 150500,
        rail: PaymentRail.mobileMoney,
        payeeName: 'Jane Nakamya',
        payeeIdentifier: '+256700100200',
        timestamp: DateTime(2026, 2, 18, 14, 30),
      ),
    );
  }
}
