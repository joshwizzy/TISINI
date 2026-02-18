import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/business_pay_state.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/repositories/pay_repository.dart';
import 'package:tisini/features/pay/providers/business_pay_controller_provider.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

class MockPayRepository extends Mock implements PayRepository {}

void main() {
  const payee = Payee(
    id: 'p-002',
    name: 'ABC Supplies',
    identifier: 'BIZ-ABC-001',
    rail: PaymentRail.bank,
    isPinned: true,
    role: MerchantRole.supplier,
  );

  const route = PaymentRoute(
    rail: PaymentRail.bank,
    label: 'Bank Transfer',
    isAvailable: true,
    fee: 1500,
  );

  group('BusinessPayController', () {
    late MockPayRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockPayRepository();
      container = ProviderContainer(
        overrides: [payRepositoryProvider.overrideWithValue(mockRepo)],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is selectingCategory', () async {
      final state = await container.read(businessPayControllerProvider.future);

      expect(state, isA<BusinessPayStateSelectingCategory>());
    });

    test('selectCategory transitions to selectingPayee', () async {
      await container.read(businessPayControllerProvider.future);

      container
          .read(businessPayControllerProvider.notifier)
          .selectCategory('Suppliers');

      final state = container.read(businessPayControllerProvider).value;
      expect(state, isA<BusinessPayStateSelectingPayee>());
      expect((state! as BusinessPayStateSelectingPayee).category, 'Suppliers');
    });

    test('setConfirming transitions to confirming', () async {
      await container.read(businessPayControllerProvider.future);

      container
          .read(businessPayControllerProvider.notifier)
          .setConfirming(
            payee: payee,
            category: 'Suppliers',
            amount: 500000,
            currency: 'UGX',
            route: route,
            fee: 1500,
            total: 501500,
          );

      final state = container.read(businessPayControllerProvider).value;
      expect(state, isA<BusinessPayStateConfirming>());
    });

    test('confirmAndPay transitions to receipt on success', () async {
      final now = DateTime.now();
      when(
        () => mockRepo.sendBusinessPayment(
          payeeId: any(named: 'payeeId'),
          amount: any(named: 'amount'),
          currency: any(named: 'currency'),
          rail: any(named: 'rail'),
          category: any(named: 'category'),
          reference: any(named: 'reference'),
        ),
      ).thenAnswer(
        (_) async => Payment(
          id: 'pay-biz-001',
          type: PaymentType.businessPay,
          status: PaymentStatus.completed,
          direction: TransactionDirection.outbound,
          amount: 500000,
          currency: 'UGX',
          rail: PaymentRail.bank,
          payee: payee,
          fee: 1500,
          total: 501500,
          category: TransactionCategory.inventory,
          createdAt: now,
        ),
      );

      when(() => mockRepo.getReceipt(transactionId: 'pay-biz-001')).thenAnswer(
        (_) async => PaymentReceipt(
          transactionId: 'pay-biz-001',
          receiptNumber: 'RCP-BIZ-001',
          type: PaymentType.businessPay,
          status: PaymentStatus.completed,
          amount: 500000,
          currency: 'UGX',
          fee: 1500,
          total: 501500,
          rail: PaymentRail.bank,
          payeeName: 'ABC Supplies',
          payeeIdentifier: 'BIZ-ABC-001',
          timestamp: now,
        ),
      );

      await container.read(businessPayControllerProvider.future);

      container
          .read(businessPayControllerProvider.notifier)
          .setConfirming(
            payee: payee,
            category: 'Suppliers',
            amount: 500000,
            currency: 'UGX',
            route: route,
            fee: 1500,
            total: 501500,
          );

      await container
          .read(businessPayControllerProvider.notifier)
          .confirmAndPay();

      final state = container.read(businessPayControllerProvider).value;
      expect(state, isA<BusinessPayStateReceipt>());
    });

    test('reset transitions to selectingCategory', () async {
      await container.read(businessPayControllerProvider.future);

      container
          .read(businessPayControllerProvider.notifier)
          .selectCategory('Suppliers');
      container.read(businessPayControllerProvider.notifier).reset();

      final state = container.read(businessPayControllerProvider).value;
      expect(state, isA<BusinessPayStateSelectingCategory>());
    });
  });
}
