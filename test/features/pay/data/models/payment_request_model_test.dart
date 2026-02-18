import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/data/models/payment_request_model.dart';

void main() {
  group('PaymentRequestModel', () {
    const json = <String, dynamic>{
      'id': 'req-001',
      'amount': 50000.0,
      'currency': 'UGX',
      'share_link': 'https://pay.tisini.co/r/req-001',
      'status': 'pending',
      'created_at': 1718400000000,
      'note': 'Test note',
    };

    test('fromJson creates model', () {
      final model = PaymentRequestModel.fromJson(json);

      expect(model.id, 'req-001');
      expect(model.amount, 50000.0);
      expect(model.currency, 'UGX');
      expect(model.shareLink, 'https://pay.tisini.co/r/req-001');
      expect(model.status, 'pending');
      expect(model.note, 'Test note');
      expect(model.paidAt, isNull);
    });

    test('toJson produces valid map', () {
      const model = PaymentRequestModel(
        id: 'req-001',
        amount: 50000,
        currency: 'UGX',
        shareLink: 'https://pay.tisini.co/r/req-001',
        status: 'pending',
        createdAt: 1718400000000,
      );

      final result = model.toJson();
      expect(result['id'], 'req-001');
      expect(result['share_link'], 'https://pay.tisini.co/r/req-001');
    });

    test('toEntity converts to PaymentRequest', () {
      final model = PaymentRequestModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.id, 'req-001');
      expect(entity.amount, 50000.0);
      expect(entity.status, PaymentStatus.pending);
      expect(entity.note, 'Test note');
      expect(entity.paidAt, isNull);
    });

    test('toEntity parses completed status', () {
      final completedJson = Map<String, dynamic>.from(json)
        ..['status'] = 'completed'
        ..['paid_at'] = 1718403600000;

      final entity = PaymentRequestModel.fromJson(completedJson).toEntity();

      expect(entity.status, PaymentStatus.completed);
      expect(entity.paidAt, isNotNull);
    });
  });
}
