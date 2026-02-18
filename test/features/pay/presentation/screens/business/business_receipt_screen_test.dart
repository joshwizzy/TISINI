import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/business_pay_state.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/presentation/screens/business/business_receipt_screen.dart';
import 'package:tisini/features/pay/providers/business_pay_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        businessPayControllerProvider.overrideWith(
          _MockBusinessPayController.new,
        ),
      ],
      child: const MaterialApp(
        home: BusinessReceiptScreen(transactionId: 'tx-biz-001'),
      ),
    );
  }

  group('BusinessReceiptScreen', () {
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

class _MockBusinessPayController extends BusinessPayController {
  @override
  Future<BusinessPayState> build() async {
    return BusinessPayState.receipt(
      receipt: PaymentReceipt(
        transactionId: 'tx-biz-001',
        receiptNumber: 'RCP-BIZ-001',
        type: PaymentType.businessPay,
        status: PaymentStatus.completed,
        amount: 500000,
        currency: 'UGX',
        fee: 1500,
        total: 501500,
        rail: PaymentRail.bank,
        payeeName: 'Acme Supplies Ltd',
        payeeIdentifier: '1234567890',
        timestamp: DateTime(2024),
      ),
    );
  }
}
