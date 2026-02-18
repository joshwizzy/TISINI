import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/topup_state.dart';
import 'package:tisini/features/pay/domain/repositories/pay_repository.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';
import 'package:tisini/features/pay/providers/topup_controller_provider.dart';

class MockPayRepository extends Mock implements PayRepository {}

void main() {
  const source = FundingSource(
    rail: PaymentRail.mobileMoney,
    label: 'MTN Mobile Money',
    identifier: '+256700100200',
    isAvailable: true,
  );

  const walletPayee = Payee(
    id: 'wallet',
    name: 'Wallet Top Up',
    identifier: 'TISINI Wallet',
    rail: PaymentRail.wallet,
    isPinned: false,
  );

  group('TopupController', () {
    late MockPayRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockPayRepository();
      container = ProviderContainer(
        overrides: [payRepositoryProvider.overrideWithValue(mockRepo)],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is selectingSource', () async {
      final state = await container.read(topupControllerProvider.future);

      expect(state, isA<TopupStateSelectingSource>());
    });

    test('selectSource transitions to enteringAmount', () async {
      await container.read(topupControllerProvider.future);

      container.read(topupControllerProvider.notifier).selectSource(source);

      final state = container.read(topupControllerProvider).value;
      expect(state, isA<TopupStateEnteringAmount>());
      expect((state! as TopupStateEnteringAmount).source, source);
    });

    test('setConfirming transitions to confirming', () async {
      await container.read(topupControllerProvider.future);

      container
          .read(topupControllerProvider.notifier)
          .setConfirming(
            source: source,
            amount: 100000,
            currency: 'UGX',
            fee: 500,
            total: 100500,
          );

      final state = container.read(topupControllerProvider).value;
      expect(state, isA<TopupStateConfirming>());
    });

    test('confirmAndTopup transitions to receipt on success', () async {
      final now = DateTime.now();
      when(
        () => mockRepo.submitTopup(
          sourceRail: any(named: 'sourceRail'),
          sourceIdentifier: any(named: 'sourceIdentifier'),
          amount: any(named: 'amount'),
          currency: any(named: 'currency'),
        ),
      ).thenAnswer(
        (_) async => Payment(
          id: 'pay-topup-001',
          type: PaymentType.topUp,
          status: PaymentStatus.completed,
          direction: TransactionDirection.inbound,
          amount: 100000,
          currency: 'UGX',
          rail: PaymentRail.mobileMoney,
          payee: walletPayee,
          fee: 500,
          total: 100500,
          category: TransactionCategory.uncategorised,
          createdAt: now,
        ),
      );

      when(
        () => mockRepo.getReceipt(transactionId: 'pay-topup-001'),
      ).thenAnswer(
        (_) async => PaymentReceipt(
          transactionId: 'pay-topup-001',
          receiptNumber: 'RCP-TOPUP-001',
          type: PaymentType.topUp,
          status: PaymentStatus.completed,
          amount: 100000,
          currency: 'UGX',
          fee: 500,
          total: 100500,
          rail: PaymentRail.mobileMoney,
          payeeName: 'Wallet Top Up',
          payeeIdentifier: 'TISINI Wallet',
          timestamp: now,
        ),
      );

      await container.read(topupControllerProvider.future);

      container
          .read(topupControllerProvider.notifier)
          .setConfirming(
            source: source,
            amount: 100000,
            currency: 'UGX',
            fee: 500,
            total: 100500,
          );

      await container.read(topupControllerProvider.notifier).confirmAndTopup();

      final state = container.read(topupControllerProvider).value;
      expect(state, isA<TopupStateReceipt>());
    });

    test('reset transitions to selectingSource', () async {
      await container.read(topupControllerProvider.future);

      container.read(topupControllerProvider.notifier).selectSource(source);
      container.read(topupControllerProvider.notifier).reset();

      final state = container.read(topupControllerProvider).value;
      expect(state, isA<TopupStateSelectingSource>());
    });
  });
}
