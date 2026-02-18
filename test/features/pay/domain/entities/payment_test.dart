import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment.dart';

void main() {
  group('Payment', () {
    final now = DateTime.now();
    const payee = Payee(
      id: 'p-001',
      name: 'Jane Nakamya',
      identifier: '+256700100200',
      rail: PaymentRail.mobileMoney,
      isPinned: false,
    );

    test('creates with required fields', () {
      final payment = Payment(
        id: 'pay-001',
        type: PaymentType.send,
        status: PaymentStatus.completed,
        direction: TransactionDirection.outbound,
        amount: 150000,
        currency: 'UGX',
        rail: PaymentRail.mobileMoney,
        payee: payee,
        fee: 500,
        total: 150500,
        category: TransactionCategory.people,
        createdAt: now,
      );

      expect(payment.id, 'pay-001');
      expect(payment.type, PaymentType.send);
      expect(payment.status, PaymentStatus.completed);
      expect(payment.amount, 150000);
      expect(payment.fee, 500);
      expect(payment.total, 150500);
      expect(payment.payee, payee);
      expect(payment.reference, isNull);
      expect(payment.note, isNull);
      expect(payment.completedAt, isNull);
    });

    test('creates with optional fields', () {
      final payment = Payment(
        id: 'pay-002',
        type: PaymentType.send,
        status: PaymentStatus.completed,
        direction: TransactionDirection.outbound,
        amount: 150000,
        currency: 'UGX',
        rail: PaymentRail.mobileMoney,
        payee: payee,
        reference: 'INV-001',
        fee: 0,
        total: 150000,
        category: TransactionCategory.people,
        note: 'Monthly payment',
        createdAt: now,
        completedAt: now,
      );

      expect(payment.reference, 'INV-001');
      expect(payment.note, 'Monthly payment');
      expect(payment.completedAt, now);
    });

    test('supports value equality', () {
      final a = Payment(
        id: 'pay-001',
        type: PaymentType.send,
        status: PaymentStatus.completed,
        direction: TransactionDirection.outbound,
        amount: 150000,
        currency: 'UGX',
        rail: PaymentRail.mobileMoney,
        payee: payee,
        fee: 0,
        total: 150000,
        category: TransactionCategory.people,
        createdAt: now,
      );
      final b = Payment(
        id: 'pay-001',
        type: PaymentType.send,
        status: PaymentStatus.completed,
        direction: TransactionDirection.outbound,
        amount: 150000,
        currency: 'UGX',
        rail: PaymentRail.mobileMoney,
        payee: payee,
        fee: 0,
        total: 150000,
        category: TransactionCategory.people,
        createdAt: now,
      );

      expect(a, equals(b));
    });
  });
}
