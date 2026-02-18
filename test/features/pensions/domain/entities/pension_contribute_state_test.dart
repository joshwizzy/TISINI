import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribute_state.dart';

void main() {
  const route = PaymentRoute(
    rail: PaymentRail.mobileMoney,
    label: 'Mobile Money',
    isAvailable: true,
    fee: 500,
  );

  group('PensionContributeState', () {
    test('enteringAmount creates initial state', () {
      const state = PensionContributeState.enteringAmount(
        currency: 'UGX',
        nextDueAmount: 5000000,
      );

      expect(state, isA<PensionContributeEnteringAmount>());
      const entering = state as PensionContributeEnteringAmount;
      expect(entering.currency, 'UGX');
      expect(entering.nextDueAmount, 5000000);
    });

    test('enteringAmount works without nextDueAmount', () {
      const state = PensionContributeState.enteringAmount(currency: 'UGX');

      const entering = state as PensionContributeEnteringAmount;
      expect(entering.nextDueAmount, isNull);
    });

    test('confirming holds full details', () {
      const state = PensionContributeState.confirming(
        amount: 5000000,
        currency: 'UGX',
        route: route,
        fee: 500,
        total: 5000500,
        reference: 'NSSF Mar 2026',
      );

      expect(state, isA<PensionContributeConfirming>());
      const confirming = state as PensionContributeConfirming;
      expect(confirming.amount, 5000000);
      expect(confirming.fee, 500);
      expect(confirming.total, 5000500);
      expect(confirming.reference, 'NSSF Mar 2026');
      expect(confirming.route, route);
    });

    test('processing creates processing state', () {
      const state = PensionContributeState.processing();

      expect(state, isA<PensionContributeProcessing>());
    });

    test('receipt holds PaymentReceipt', () {
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
        timestamp: DateTime.now(),
      );

      final state = PensionContributeState.receipt(receipt: receipt);

      expect(state, isA<PensionContributeReceipt>());
      expect(
        (state as PensionContributeReceipt).receipt.transactionId,
        'tx-001',
      );
    });

    test('failed holds message and optional code', () {
      const state = PensionContributeState.failed(
        message: 'Contribution failed',
        code: 'INSUFFICIENT_BALANCE',
      );

      expect(state, isA<PensionContributeFailed>());
      const failed = state as PensionContributeFailed;
      expect(failed.message, 'Contribution failed');
      expect(failed.code, 'INSUFFICIENT_BALANCE');
    });

    test('failed works without code', () {
      const state = PensionContributeState.failed(
        message: 'Something went wrong',
      );

      const failed = state as PensionContributeFailed;
      expect(failed.code, isNull);
    });
  });
}
