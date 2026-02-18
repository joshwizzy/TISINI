import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';
import 'package:tisini/features/pay/domain/repositories/pay_repository.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';
import 'package:tisini/features/pay/providers/send_controller_provider.dart';

class MockPayRepository extends Mock implements PayRepository {}

void main() {
  const payee = Payee(
    id: 'p-001',
    name: 'Jane Nakamya',
    identifier: '+256700100200',
    rail: PaymentRail.mobileMoney,
    isPinned: false,
  );

  const route = PaymentRoute(
    rail: PaymentRail.mobileMoney,
    label: 'Mobile Money',
    isAvailable: true,
    fee: 500,
  );

  group('SendController', () {
    late MockPayRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockPayRepository();
      container = ProviderContainer(
        overrides: [payRepositoryProvider.overrideWithValue(mockRepo)],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is selectingRecipient', () async {
      final state = await container.read(sendControllerProvider.future);

      expect(state, isA<SendStateSelectingRecipient>());
    });

    test('selectRecipient transitions to enteringDetails', () async {
      await container.read(sendControllerProvider.future);

      container.read(sendControllerProvider.notifier).selectRecipient(payee);

      final state = container.read(sendControllerProvider).value;
      expect(state, isA<SendStateEnteringDetails>());
      expect((state! as SendStateEnteringDetails).payee, payee);
    });

    test('enterDetails transitions to enteringAmount', () async {
      await container.read(sendControllerProvider.future);

      container
          .read(sendControllerProvider.notifier)
          .enterDetails(
            payee: payee,
            reference: 'INV-001',
            category: TransactionCategory.people,
            note: 'Test',
          );

      final state = container.read(sendControllerProvider).value;
      expect(state, isA<SendStateEnteringAmount>());
      final amount = state! as SendStateEnteringAmount;
      expect(amount.payee, payee);
      expect(amount.reference, 'INV-001');
    });

    test('setAmount transitions to confirming', () async {
      await container.read(sendControllerProvider.future);

      container
          .read(sendControllerProvider.notifier)
          .setAmount(
            payee: payee,
            category: TransactionCategory.people,
            amount: 150000,
            currency: 'UGX',
            route: route,
            fee: 500,
            total: 150500,
          );

      final state = container.read(sendControllerProvider).value;
      expect(state, isA<SendStateConfirming>());
      final confirming = state! as SendStateConfirming;
      expect(confirming.amount, 150000);
      expect(confirming.total, 150500);
    });

    test('confirmAndSend transitions to receipt on success', () async {
      final now = DateTime.now();
      when(
        () => mockRepo.sendPayment(
          payeeId: any(named: 'payeeId'),
          amount: any(named: 'amount'),
          currency: any(named: 'currency'),
          rail: any(named: 'rail'),
          category: any(named: 'category'),
          reference: any(named: 'reference'),
          note: any(named: 'note'),
        ),
      ).thenAnswer(
        (_) async => Payment(
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
        ),
      );

      when(() => mockRepo.getReceipt(transactionId: 'pay-001')).thenAnswer(
        (_) async => PaymentReceipt(
          transactionId: 'pay-001',
          receiptNumber: 'RCP-001',
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
        ),
      );

      await container.read(sendControllerProvider.future);

      // Move to confirming state first
      container
          .read(sendControllerProvider.notifier)
          .setAmount(
            payee: payee,
            category: TransactionCategory.people,
            amount: 150000,
            currency: 'UGX',
            route: route,
            fee: 500,
            total: 150500,
          );

      await container.read(sendControllerProvider.notifier).confirmAndSend();

      final state = container.read(sendControllerProvider).value;
      expect(state, isA<SendStateReceipt>());
    });

    test('reset transitions to selectingRecipient', () async {
      await container.read(sendControllerProvider.future);

      container.read(sendControllerProvider.notifier).selectRecipient(payee);
      container.read(sendControllerProvider.notifier).reset();

      final state = container.read(sendControllerProvider).value;
      expect(state, isA<SendStateSelectingRecipient>());
    });
  });
}
