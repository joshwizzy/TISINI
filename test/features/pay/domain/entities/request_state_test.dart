import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_request.dart';
import 'package:tisini/features/pay/domain/entities/request_state.dart';

void main() {
  final request = PaymentRequest(
    id: 'req-001',
    amount: 50000,
    currency: 'UGX',
    shareLink: 'https://pay.tisini.co/r/req-001',
    status: PaymentStatus.pending,
    createdAt: DateTime(2024),
  );

  group('RequestState', () {
    test('creating variant', () {
      const state = RequestState.creating();
      expect(state, isA<RequestStateCreating>());
    });

    test('processing variant', () {
      const state = RequestState.processing();
      expect(state, isA<RequestStateProcessing>());
    });

    test('sharing variant holds request', () {
      final state = RequestState.sharing(request: request);
      expect(state, isA<RequestStateSharing>());
      expect((state as RequestStateSharing).request, request);
    });

    test('tracking variant holds request', () {
      final state = RequestState.tracking(request: request);
      expect(state, isA<RequestStateTracking>());
      expect((state as RequestStateTracking).request, request);
    });

    test('failed variant holds message and optional code', () {
      const state = RequestState.failed(
        message: 'Network error',
        code: 'NET_001',
      );
      expect(state, isA<RequestStateFailed>());
      const failed = state as RequestStateFailed;
      expect(failed.message, 'Network error');
      expect(failed.code, 'NET_001');
    });

    test('failed variant without code', () {
      const state = RequestState.failed(message: 'Something went wrong');
      expect((state as RequestStateFailed).code, isNull);
    });
  });
}
