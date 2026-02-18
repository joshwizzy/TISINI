import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/shared/widgets/receipt_template.dart';

void main() {
  final receipt = PaymentReceipt(
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
  );

  Widget buildWidget({
    PaymentReceipt? r,
    VoidCallback? onDone,
    VoidCallback? onShare,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ReceiptTemplate(
          receipt: r ?? receipt,
          onDone: onDone,
          onShare: onShare,
        ),
      ),
    );
  }

  group('ReceiptTemplate', () {
    testWidgets('renders payee name', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Jane Nakamya'), findsOneWidget);
    });

    testWidgets('renders total amount', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('UGX 150,500'), findsWidgets);
    });

    testWidgets('renders receipt number', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('RCP-001'), findsOneWidget);
    });

    testWidgets('renders Done button', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('renders Share button', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Share'), findsOneWidget);
    });

    testWidgets('handles Done tap', (tester) async {
      var doneTapped = false;
      await tester.pumpWidget(buildWidget(onDone: () => doneTapped = true));

      await tester.tap(find.text('Done'));

      expect(doneTapped, isTrue);
    });

    testWidgets('renders Payment Successful for completed', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Payment Successful'), findsOneWidget);
    });

    testWidgets('renders Payment Failed for failed status', (tester) async {
      final failedReceipt = PaymentReceipt(
        transactionId: 'tx-002',
        receiptNumber: 'RCP-002',
        type: PaymentType.send,
        status: PaymentStatus.failed,
        amount: 150000,
        currency: 'UGX',
        fee: 0,
        total: 150000,
        rail: PaymentRail.mobileMoney,
        payeeName: 'Jane',
        payeeIdentifier: '+256700100200',
        timestamp: DateTime(2026, 2, 18),
      );

      await tester.pumpWidget(buildWidget(r: failedReceipt));

      expect(find.text('Payment Failed'), findsOneWidget);
    });
  });
}
