import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribute_state.dart';
import 'package:tisini/features/pensions/providers/pension_contribute_controller.dart';

void main() {
  const route = PaymentRoute(
    rail: PaymentRail.mobileMoney,
    label: 'Mobile Money',
    isAvailable: true,
    fee: 500,
  );

  group('PensionContributeController', () {
    test('build returns enteringAmount with due info', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Keep a listener to prevent auto-dispose
      container.listen(pensionContributeControllerProvider, (_, __) {});

      final state = await container.read(
        pensionContributeControllerProvider.future,
      );

      expect(state, isA<PensionContributeEnteringAmount>());
      final entering = state as PensionContributeEnteringAmount;
      expect(entering.currency, 'UGX');
      expect(entering.nextDueAmount, 5000000);
    });

    test('setConfirming transitions to confirming', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(pensionContributeControllerProvider, (_, __) {});

      await container.read(pensionContributeControllerProvider.future);

      container
          .read(pensionContributeControllerProvider.notifier)
          .setConfirming(
            amount: 5000000,
            currency: 'UGX',
            route: route,
            fee: 500,
            total: 5000500,
            reference: 'NSSF Mar 2026',
          );

      final state = container
          .read(pensionContributeControllerProvider)
          .valueOrNull;

      expect(state, isA<PensionContributeConfirming>());
      final confirming = state! as PensionContributeConfirming;
      expect(confirming.amount, 5000000);
      expect(confirming.reference, 'NSSF Mar 2026');
    });

    test('confirmAndPay transitions through processing to receipt', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(pensionContributeControllerProvider, (_, __) {});

      await container.read(pensionContributeControllerProvider.future);

      container
          .read(pensionContributeControllerProvider.notifier)
          .setConfirming(
            amount: 5000000,
            currency: 'UGX',
            route: route,
            fee: 500,
            total: 5000500,
            reference: 'NSSF Mar 2026',
          );

      await container
          .read(pensionContributeControllerProvider.notifier)
          .confirmAndPay();

      final state = container
          .read(pensionContributeControllerProvider)
          .valueOrNull;

      expect(state, isA<PensionContributeReceipt>());
    });

    test('reset returns to enteringAmount', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(pensionContributeControllerProvider, (_, __) {});

      await container.read(pensionContributeControllerProvider.future);

      container.read(pensionContributeControllerProvider.notifier).reset();

      final state = container
          .read(pensionContributeControllerProvider)
          .valueOrNull;

      expect(state, isA<PensionContributeEnteringAmount>());
    });

    test('confirmAndPay does nothing if not in confirming state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(pensionContributeControllerProvider, (_, __) {});

      await container.read(pensionContributeControllerProvider.future);

      await container
          .read(pensionContributeControllerProvider.notifier)
          .confirmAndPay();

      final state = container
          .read(pensionContributeControllerProvider)
          .valueOrNull;

      expect(state, isA<PensionContributeEnteringAmount>());
    });
  });
}
