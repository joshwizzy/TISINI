import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_request.dart';
import 'package:tisini/features/pay/domain/entities/request_state.dart';
import 'package:tisini/features/pay/domain/repositories/pay_repository.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';
import 'package:tisini/features/pay/providers/request_controller_provider.dart';

class MockPayRepository extends Mock implements PayRepository {}

void main() {
  group('RequestController', () {
    late MockPayRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockPayRepository();
      container = ProviderContainer(
        overrides: [payRepositoryProvider.overrideWithValue(mockRepo)],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is creating', () async {
      final state = await container.read(requestControllerProvider.future);

      expect(state, isA<RequestStateCreating>());
    });

    test('createRequest transitions to sharing on success', () async {
      final request = PaymentRequest(
        id: 'req-001',
        amount: 50000,
        currency: 'UGX',
        shareLink: 'https://pay.tisini.co/r/req-001',
        status: PaymentStatus.pending,
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepo.createPaymentRequest(
          amount: 50000,
          currency: 'UGX',
          note: 'Test',
        ),
      ).thenAnswer((_) async => request);

      await container.read(requestControllerProvider.future);

      await container
          .read(requestControllerProvider.notifier)
          .createRequest(amount: 50000, currency: 'UGX', note: 'Test');

      final state = container.read(requestControllerProvider).value;
      expect(state, isA<RequestStateSharing>());
      expect((state! as RequestStateSharing).request.id, 'req-001');
    });

    test('createRequest transitions to failed on error', () async {
      when(
        () => mockRepo.createPaymentRequest(
          amount: any(named: 'amount'),
          currency: any(named: 'currency'),
        ),
      ).thenThrow(Exception('Network error'));

      await container.read(requestControllerProvider.future);

      await container
          .read(requestControllerProvider.notifier)
          .createRequest(amount: 50000, currency: 'UGX');

      final state = container.read(requestControllerProvider).value;
      expect(state, isA<RequestStateFailed>());
    });

    test('viewStatus transitions to tracking', () async {
      final request = PaymentRequest(
        id: 'req-001',
        amount: 50000,
        currency: 'UGX',
        shareLink: 'https://pay.tisini.co/r/req-001',
        status: PaymentStatus.pending,
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepo.getPaymentRequest(requestId: 'req-001'),
      ).thenAnswer((_) async => request);

      await container.read(requestControllerProvider.future);

      await container
          .read(requestControllerProvider.notifier)
          .viewStatus('req-001');

      final state = container.read(requestControllerProvider).value;
      expect(state, isA<RequestStateTracking>());
    });

    test('reset transitions to creating', () async {
      await container.read(requestControllerProvider.future);

      container.read(requestControllerProvider.notifier).reset();

      final state = container.read(requestControllerProvider).value;
      expect(state, isA<RequestStateCreating>());
    });
  });
}
