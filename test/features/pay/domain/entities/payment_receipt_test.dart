import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';

void main() {
  group('PaymentReceipt', () {
    final now = DateTime.now();

    test('creates with required fields', () {
      final receipt = PaymentReceipt(
        transactionId: 'tx-001',
        receiptNumber: 'RCP-20260218-001',
        type: PaymentType.send,
        status: PaymentStatus.completed,
        amount: 150000,
        currency: 'UGX',
        fee: 500,
        total: 150500,
        rail: PaymentRail.mobileMoney,
        payeeName: 'Jane Nakamya',
        payeeIdentifier: '+256700100200',
        timestamp: now,
      );

      expect(receipt.transactionId, 'tx-001');
      expect(receipt.receiptNumber, 'RCP-20260218-001');
      expect(receipt.type, PaymentType.send);
      expect(receipt.status, PaymentStatus.completed);
      expect(receipt.amount, 150000);
      expect(receipt.fee, 500);
      expect(receipt.total, 150500);
      expect(receipt.reference, isNull);
    });

    test('creates with reference', () {
      final receipt = PaymentReceipt(
        transactionId: 'tx-002',
        receiptNumber: 'RCP-20260218-002',
        type: PaymentType.send,
        status: PaymentStatus.completed,
        amount: 150000,
        currency: 'UGX',
        fee: 0,
        total: 150000,
        rail: PaymentRail.bank,
        payeeName: 'ABC Supplies',
        payeeIdentifier: 'BIZ-ABC-001',
        reference: 'INV-001',
        timestamp: now,
      );

      expect(receipt.reference, 'INV-001');
      expect(receipt.rail, PaymentRail.bank);
    });

    test('supports value equality', () {
      final a = PaymentReceipt(
        transactionId: 'tx-001',
        receiptNumber: 'RCP-001',
        type: PaymentType.send,
        status: PaymentStatus.completed,
        amount: 150000,
        currency: 'UGX',
        fee: 0,
        total: 150000,
        rail: PaymentRail.mobileMoney,
        payeeName: 'Jane',
        payeeIdentifier: '+256700100200',
        timestamp: now,
      );
      final b = PaymentReceipt(
        transactionId: 'tx-001',
        receiptNumber: 'RCP-001',
        type: PaymentType.send,
        status: PaymentStatus.completed,
        amount: 150000,
        currency: 'UGX',
        fee: 0,
        total: 150000,
        rail: PaymentRail.mobileMoney,
        payeeName: 'Jane',
        payeeIdentifier: '+256700100200',
        timestamp: now,
      );

      expect(a, equals(b));
    });
  });
}
