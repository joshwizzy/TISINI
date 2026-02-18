import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/scan_state.dart';
import 'package:tisini/features/pay/presentation/screens/scan/scan_receipt_screen.dart';
import 'package:tisini/features/pay/providers/scan_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [scanControllerProvider.overrideWith(_MockScanController.new)],
      child: const MaterialApp(
        home: ScanReceiptScreen(transactionId: 'tx-001'),
      ),
    );
  }

  group('ScanReceiptScreen', () {
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

class _MockScanController extends ScanController {
  @override
  Future<ScanState> build() async {
    return ScanState.receipt(
      receipt: PaymentReceipt(
        transactionId: 'tx-001',
        receiptNumber: 'RCP-001',
        type: PaymentType.scanPay,
        status: PaymentStatus.completed,
        amount: 10000,
        currency: 'UGX',
        fee: 500,
        total: 10500,
        rail: PaymentRail.mobileMoney,
        payeeName: 'Jane Nakamya',
        payeeIdentifier: '+256700100200',
        timestamp: DateTime(2024),
      ),
    );
  }
}
