import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/business_pay_state.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/presentation/screens/business/business_confirm_screen.dart';
import 'package:tisini/features/pay/providers/business_pay_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        businessPayControllerProvider.overrideWith(
          _MockBusinessPayController.new,
        ),
      ],
      child: const MaterialApp(home: BusinessConfirmScreen()),
    );
  }

  group('BusinessConfirmScreen', () {
    testWidgets('renders Confirm app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('renders payee name', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Acme Supplies Ltd'), findsOneWidget);
    });

    testWidgets('renders Pay button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Pay'), findsOneWidget);
    });

    testWidgets('renders cost breakdown', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Fee'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
    });
  });
}

class _MockBusinessPayController extends BusinessPayController {
  @override
  Future<BusinessPayState> build() async {
    return const BusinessPayState.confirming(
      payee: Payee(
        id: 'p-biz-001',
        name: 'Acme Supplies Ltd',
        identifier: '1234567890',
        rail: PaymentRail.bank,
        isPinned: false,
      ),
      category: 'Suppliers',
      amount: 500000,
      currency: 'UGX',
      route: PaymentRoute(
        rail: PaymentRail.bank,
        label: 'Bank Transfer',
        isAvailable: true,
        fee: 1500,
      ),
      fee: 1500,
      total: 501500,
    );
  }
}
