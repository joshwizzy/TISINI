import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/topup_state.dart';

void main() {
  const source = FundingSource(
    rail: PaymentRail.mobileMoney,
    label: 'MTN Mobile Money',
    identifier: '+256700100200',
    isAvailable: true,
  );

  group('TopupState', () {
    test('selectingSource variant', () {
      const state = TopupState.selectingSource();
      expect(state, isA<TopupStateSelectingSource>());
    });

    test('enteringAmount variant holds source', () {
      const state = TopupState.enteringAmount(source: source);
      expect(state, isA<TopupStateEnteringAmount>());
      expect((state as TopupStateEnteringAmount).source, source);
    });

    test('confirming variant', () {
      const state = TopupState.confirming(
        source: source,
        amount: 100000,
        currency: 'UGX',
        fee: 500,
        total: 100500,
      );
      expect(state, isA<TopupStateConfirming>());
      const confirming = state as TopupStateConfirming;
      expect(confirming.source, source);
      expect(confirming.amount, 100000);
      expect(confirming.total, 100500);
    });

    test('processing variant', () {
      const state = TopupState.processing();
      expect(state, isA<TopupStateProcessing>());
    });

    test('receipt variant', () {
      final state = TopupState.receipt(
        receipt: PaymentReceipt(
          transactionId: 'tx-003',
          receiptNumber: 'RCP-003',
          type: PaymentType.topUp,
          status: PaymentStatus.completed,
          amount: 100000,
          currency: 'UGX',
          fee: 500,
          total: 100500,
          rail: PaymentRail.mobileMoney,
          payeeName: 'Wallet Top Up',
          payeeIdentifier: 'MTN Mobile Money',
          timestamp: DateTime(2024),
        ),
      );
      expect(state, isA<TopupStateReceipt>());
    });

    test('failed variant', () {
      const state = TopupState.failed(message: 'Source unavailable');
      expect(state, isA<TopupStateFailed>());
      expect((state as TopupStateFailed).message, 'Source unavailable');
      expect(state.code, isNull);
    });
  });
}
