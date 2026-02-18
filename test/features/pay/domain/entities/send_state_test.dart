import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';

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

  group('SendState', () {
    test('selectingRecipient creates initial state', () {
      const state = SendState.selectingRecipient();

      expect(state, isA<SendStateSelectingRecipient>());
    });

    test('enteringDetails holds payee', () {
      const state = SendState.enteringDetails(payee: payee);

      expect(state, isA<SendStateEnteringDetails>());
      const details = state as SendStateEnteringDetails;
      expect(details.payee, payee);
    });

    test('enteringAmount holds payee and optional fields', () {
      const state = SendState.enteringAmount(
        payee: payee,
        reference: 'INV-001',
        category: TransactionCategory.people,
        note: 'Test note',
      );

      expect(state, isA<SendStateEnteringAmount>());
      const amount = state as SendStateEnteringAmount;
      expect(amount.payee, payee);
      expect(amount.reference, 'INV-001');
      expect(amount.category, TransactionCategory.people);
      expect(amount.note, 'Test note');
    });

    test('confirming holds full payment details', () {
      const state = SendState.confirming(
        payee: payee,
        reference: 'INV-001',
        category: TransactionCategory.people,
        note: 'Test',
        amount: 150000,
        currency: 'UGX',
        route: route,
        fee: 500,
        total: 150500,
      );

      expect(state, isA<SendStateConfirming>());
      const confirming = state as SendStateConfirming;
      expect(confirming.amount, 150000);
      expect(confirming.fee, 500);
      expect(confirming.total, 150500);
      expect(confirming.route, route);
    });

    test('processing creates processing state', () {
      const state = SendState.processing();

      expect(state, isA<SendStateProcessing>());
    });

    test('receipt holds PaymentReceipt', () {
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
        timestamp: DateTime.now(),
      );

      final state = SendState.receipt(receipt: receipt);

      expect(state, isA<SendStateReceipt>());
      expect((state as SendStateReceipt).receipt.transactionId, 'tx-001');
    });

    test('failed holds message and optional code', () {
      const state = SendState.failed(
        message: 'Payment failed',
        code: 'INSUFFICIENT_BALANCE',
      );

      expect(state, isA<SendStateFailed>());
      const failed = state as SendStateFailed;
      expect(failed.message, 'Payment failed');
      expect(failed.code, 'INSUFFICIENT_BALANCE');
    });

    test('failed works without code', () {
      const state = SendState.failed(message: 'Something went wrong');

      const failed = state as SendStateFailed;
      expect(failed.code, isNull);
    });
  });
}
