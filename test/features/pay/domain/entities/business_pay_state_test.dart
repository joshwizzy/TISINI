import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/business_pay_state.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';

void main() {
  const payee = Payee(
    id: 'p-002',
    name: 'ABC Supplies',
    identifier: 'BIZ-ABC-001',
    rail: PaymentRail.bank,
    isPinned: true,
    role: MerchantRole.supplier,
  );

  const route = PaymentRoute(
    rail: PaymentRail.bank,
    label: 'Bank Transfer',
    isAvailable: true,
    fee: 1500,
  );

  group('BusinessPayState', () {
    test('selectingCategory variant', () {
      const state = BusinessPayState.selectingCategory();
      expect(state, isA<BusinessPayStateSelectingCategory>());
    });

    test('selectingPayee variant holds category', () {
      const state = BusinessPayState.selectingPayee(category: 'Suppliers');
      expect(state, isA<BusinessPayStateSelectingPayee>());
      expect((state as BusinessPayStateSelectingPayee).category, 'Suppliers');
    });

    test('confirming variant', () {
      const state = BusinessPayState.confirming(
        payee: payee,
        category: 'Suppliers',
        amount: 500000,
        currency: 'UGX',
        route: route,
        fee: 1500,
        total: 501500,
        reference: 'PO-2024-001',
      );
      expect(state, isA<BusinessPayStateConfirming>());
      const confirming = state as BusinessPayStateConfirming;
      expect(confirming.payee, payee);
      expect(confirming.reference, 'PO-2024-001');
      expect(confirming.total, 501500);
    });

    test('processing variant', () {
      const state = BusinessPayState.processing();
      expect(state, isA<BusinessPayStateProcessing>());
    });

    test('receipt variant', () {
      final state = BusinessPayState.receipt(
        receipt: PaymentReceipt(
          transactionId: 'tx-002',
          receiptNumber: 'RCP-002',
          type: PaymentType.businessPay,
          status: PaymentStatus.completed,
          amount: 500000,
          currency: 'UGX',
          fee: 1500,
          total: 501500,
          rail: PaymentRail.bank,
          payeeName: 'ABC Supplies',
          payeeIdentifier: 'BIZ-ABC-001',
          timestamp: DateTime(2024),
          reference: 'PO-2024-001',
        ),
      );
      expect(state, isA<BusinessPayStateReceipt>());
    });

    test('failed variant', () {
      const state = BusinessPayState.failed(
        message: 'Insufficient balance',
        code: 'INSUF_BAL',
      );
      expect(state, isA<BusinessPayStateFailed>());
      const failed = state as BusinessPayStateFailed;
      expect(failed.message, 'Insufficient balance');
      expect(failed.code, 'INSUF_BAL');
    });
  });
}
