import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/data/models/payment_receipt_model.dart';

void main() {
  group('PaymentReceiptModel', () {
    const json = {
      'transaction_id': 'tx-001',
      'receipt_number': 'RCP-20260218-001',
      'type': 'send',
      'status': 'completed',
      'amount': 150000.0,
      'currency': 'UGX',
      'fee': 500.0,
      'total': 150500.0,
      'rail': 'mobile_money',
      'payee_name': 'Jane Nakamya',
      'payee_identifier': '+256700100200',
      'timestamp': 1718400000000,
    };

    test('fromJson creates correct model', () {
      final model = PaymentReceiptModel.fromJson(json);

      expect(model.transactionId, 'tx-001');
      expect(model.receiptNumber, 'RCP-20260218-001');
      expect(model.type, 'send');
      expect(model.amount, 150000.0);
      expect(model.fee, 500.0);
      expect(model.total, 150500.0);
      expect(model.payeeName, 'Jane Nakamya');
      expect(model.reference, isNull);
    });

    test('fromJson with reference', () {
      final fullJson = {...json, 'reference': 'INV-001'};

      final model = PaymentReceiptModel.fromJson(fullJson);

      expect(model.reference, 'INV-001');
    });

    test('toJson produces correct map', () {
      final model = PaymentReceiptModel.fromJson(json);
      final result = model.toJson();

      expect(result['transaction_id'], 'tx-001');
      expect(result['receipt_number'], 'RCP-20260218-001');
      expect(result['payee_name'], 'Jane Nakamya');
    });

    test('toEntity converts enums correctly', () {
      final model = PaymentReceiptModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.type, PaymentType.send);
      expect(entity.status, PaymentStatus.completed);
      expect(entity.rail, PaymentRail.mobileMoney);
      expect(entity.transactionId, 'tx-001');
      expect(entity.timestamp, isA<DateTime>());
    });
  });
}
