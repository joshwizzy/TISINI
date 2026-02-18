import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';

void main() {
  group('Transaction', () {
    test('creates with required fields', () {
      final tx = Transaction(
        id: 'tx-001',
        type: PaymentType.send,
        direction: TransactionDirection.outbound,
        status: PaymentStatus.completed,
        amount: 50000,
        currency: 'UGX',
        counterpartyName: 'Jane Doe',
        counterpartyIdentifier: '+256700000001',
        category: TransactionCategory.people,
        rail: PaymentRail.mobileMoney,
        createdAt: DateTime(2025, 6, 15),
      );

      expect(tx.id, 'tx-001');
      expect(tx.type, PaymentType.send);
      expect(tx.direction, TransactionDirection.outbound);
      expect(tx.status, PaymentStatus.completed);
      expect(tx.amount, 50000);
      expect(tx.currency, 'UGX');
      expect(tx.counterpartyName, 'Jane Doe');
      expect(tx.category, TransactionCategory.people);
      expect(tx.rail, PaymentRail.mobileMoney);
      expect(tx.merchantRole, isNull);
      expect(tx.note, isNull);
      expect(tx.fee, isNull);
    });

    test('creates with optional fields', () {
      final tx = Transaction(
        id: 'tx-002',
        type: PaymentType.businessPay,
        direction: TransactionDirection.outbound,
        status: PaymentStatus.completed,
        amount: 200000,
        currency: 'UGX',
        counterpartyName: 'ABC Supplies',
        counterpartyIdentifier: 'BIZ-001',
        category: TransactionCategory.inventory,
        rail: PaymentRail.bank,
        createdAt: DateTime(2025, 6, 15),
        merchantRole: MerchantRole.supplier,
        note: 'Monthly stock order',
        fee: 500,
      );

      expect(tx.merchantRole, MerchantRole.supplier);
      expect(tx.note, 'Monthly stock order');
      expect(tx.fee, 500);
    });

    test('supports value equality', () {
      final now = DateTime(2025, 6, 15);
      final a = Transaction(
        id: 'tx-001',
        type: PaymentType.send,
        direction: TransactionDirection.outbound,
        status: PaymentStatus.completed,
        amount: 50000,
        currency: 'UGX',
        counterpartyName: 'Jane Doe',
        counterpartyIdentifier: '+256700000001',
        category: TransactionCategory.people,
        rail: PaymentRail.mobileMoney,
        createdAt: now,
      );
      final b = Transaction(
        id: 'tx-001',
        type: PaymentType.send,
        direction: TransactionDirection.outbound,
        status: PaymentStatus.completed,
        amount: 50000,
        currency: 'UGX',
        counterpartyName: 'Jane Doe',
        counterpartyIdentifier: '+256700000001',
        category: TransactionCategory.people,
        rail: PaymentRail.mobileMoney,
        createdAt: now,
      );

      expect(a, equals(b));
    });
  });
}
