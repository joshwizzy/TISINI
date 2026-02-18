import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/entities/scan_state.dart';

void main() {
  const payee = Payee(
    id: 'p-001',
    name: 'Jane Nakamya',
    identifier: '+256700100200',
    rail: PaymentRail.mobileMoney,
    isPinned: false,
  );

  const route = PaymentRoute(
    rail: PaymentRail.mobileMoney,
    label: 'Mobile Money',
    isAvailable: true,
    fee: 500,
  );

  group('ScanState', () {
    test('scanning variant', () {
      const state = ScanState.scanning();
      expect(state, isA<ScanStateScanning>());
    });

    test('manualEntry variant', () {
      const state = ScanState.manualEntry();
      expect(state, isA<ScanStateManualEntry>());
    });

    test('resolved variant with payee', () {
      const state = ScanState.resolved(
        payee: payee,
        amount: 10000,
        qrData: 'tisini://pay/p-001?amount=10000',
      );
      expect(state, isA<ScanStateResolved>());
      const resolved = state as ScanStateResolved;
      expect(resolved.payee, payee);
      expect(resolved.amount, 10000);
      expect(resolved.qrData, 'tisini://pay/p-001?amount=10000');
    });

    test('confirming variant', () {
      const state = ScanState.confirming(
        payee: payee,
        amount: 10000,
        currency: 'UGX',
        route: route,
        fee: 500,
        total: 10500,
      );
      expect(state, isA<ScanStateConfirming>());
      const confirming = state as ScanStateConfirming;
      expect(confirming.total, 10500);
    });

    test('processing variant', () {
      const state = ScanState.processing();
      expect(state, isA<ScanStateProcessing>());
    });

    test('receipt variant', () {
      final state = ScanState.receipt(
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
      expect(state, isA<ScanStateReceipt>());
    });

    test('failed variant', () {
      const state = ScanState.failed(message: 'QR invalid');
      expect(state, isA<ScanStateFailed>());
      expect((state as ScanStateFailed).message, 'QR invalid');
    });
  });
}
