import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/entities/scan_state.dart';
import 'package:tisini/features/pay/domain/repositories/pay_repository.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';
import 'package:tisini/features/pay/providers/scan_controller_provider.dart';

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

  group('ScanController', () {
    late MockPayRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockPayRepository();
      container = ProviderContainer(
        overrides: [payRepositoryProvider.overrideWithValue(mockRepo)],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is scanning', () async {
      final state = await container.read(scanControllerProvider.future);

      expect(state, isA<ScanStateScanning>());
    });

    test('enterManually transitions to manualEntry', () async {
      await container.read(scanControllerProvider.future);

      container.read(scanControllerProvider.notifier).enterManually();

      final state = container.read(scanControllerProvider).value;
      expect(state, isA<ScanStateManualEntry>());
    });

    test('resolveManualPayee transitions to resolved', () async {
      when(
        () => mockRepo.searchPayees(query: '+256700100200'),
      ).thenAnswer((_) async => [payee]);

      await container.read(scanControllerProvider.future);

      await container
          .read(scanControllerProvider.notifier)
          .resolveManualPayee('+256700100200');

      final state = container.read(scanControllerProvider).value;
      expect(state, isA<ScanStateResolved>());
    });

    test('setAmount transitions to confirming', () async {
      await container.read(scanControllerProvider.future);

      container
          .read(scanControllerProvider.notifier)
          .setAmount(
            payee: payee,
            amount: 10000,
            currency: 'UGX',
            route: route,
            fee: 500,
            total: 10500,
          );

      final state = container.read(scanControllerProvider).value;
      expect(state, isA<ScanStateConfirming>());
      expect((state! as ScanStateConfirming).total, 10500);
    });

    test('confirmAndPay transitions to receipt on success', () async {
      final now = DateTime.now();
      when(
        () => mockRepo.scanPay(
          payeeId: any(named: 'payeeId'),
          amount: any(named: 'amount'),
          currency: any(named: 'currency'),
          rail: any(named: 'rail'),
          qrData: any(named: 'qrData'),
        ),
      ).thenAnswer(
        (_) async => Payment(
          id: 'pay-001',
          type: PaymentType.scanPay,
          status: PaymentStatus.completed,
          direction: TransactionDirection.outbound,
          amount: 10000,
          currency: 'UGX',
          rail: PaymentRail.mobileMoney,
          payee: payee,
          fee: 500,
          total: 10500,
          category: TransactionCategory.uncategorised,
          createdAt: now,
        ),
      );

      when(() => mockRepo.getReceipt(transactionId: 'pay-001')).thenAnswer(
        (_) async => PaymentReceipt(
          transactionId: 'pay-001',
          receiptNumber: 'RCP-001',
          type: PaymentType.scanPay,
          status: PaymentStatus.completed,
          amount: 10000,
          currency: 'UGX',
          fee: 500,
          total: 10500,
          rail: PaymentRail.mobileMoney,
          payeeName: 'Jane Nakamya',
          payeeIdentifier: '+256700100200',
          timestamp: now,
        ),
      );

      await container.read(scanControllerProvider.future);

      // Move to confirming state first
      container
          .read(scanControllerProvider.notifier)
          .setAmount(
            payee: payee,
            amount: 10000,
            currency: 'UGX',
            route: route,
            fee: 500,
            total: 10500,
          );

      await container.read(scanControllerProvider.notifier).confirmAndPay();

      final state = container.read(scanControllerProvider).value;
      expect(state, isA<ScanStateReceipt>());
    });

    test('reset transitions to scanning', () async {
      await container.read(scanControllerProvider.future);

      container.read(scanControllerProvider.notifier).enterManually();
      container.read(scanControllerProvider.notifier).reset();

      final state = container.read(scanControllerProvider).value;
      expect(state, isA<ScanStateScanning>());
    });
  });
}
