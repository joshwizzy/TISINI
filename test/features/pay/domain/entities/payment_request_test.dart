import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_request.dart';

void main() {
  group('PaymentRequest', () {
    test('can be created with required fields', () {
      final now = DateTime.now();
      final request = PaymentRequest(
        id: 'req-001',
        amount: 50000,
        currency: 'UGX',
        shareLink: 'https://pay.tisini.co/r/req-001',
        status: PaymentStatus.pending,
        createdAt: now,
      );

      expect(request.id, 'req-001');
      expect(request.amount, 50000);
      expect(request.currency, 'UGX');
      expect(request.shareLink, 'https://pay.tisini.co/r/req-001');
      expect(request.status, PaymentStatus.pending);
      expect(request.createdAt, now);
      expect(request.note, isNull);
      expect(request.paidAt, isNull);
    });

    test('can be created with optional fields', () {
      final now = DateTime.now();
      final paidAt = now.add(const Duration(hours: 1));
      final request = PaymentRequest(
        id: 'req-002',
        amount: 75000,
        currency: 'UGX',
        shareLink: 'https://pay.tisini.co/r/req-002',
        status: PaymentStatus.completed,
        createdAt: now,
        note: 'Invoice payment',
        paidAt: paidAt,
      );

      expect(request.note, 'Invoice payment');
      expect(request.paidAt, paidAt);
    });

    test('supports equality', () {
      final now = DateTime(2024);
      final a = PaymentRequest(
        id: 'req-001',
        amount: 50000,
        currency: 'UGX',
        shareLink: 'https://pay.tisini.co/r/req-001',
        status: PaymentStatus.pending,
        createdAt: now,
      );
      final b = PaymentRequest(
        id: 'req-001',
        amount: 50000,
        currency: 'UGX',
        shareLink: 'https://pay.tisini.co/r/req-001',
        status: PaymentStatus.pending,
        createdAt: now,
      );

      expect(a, equals(b));
    });
  });
}
