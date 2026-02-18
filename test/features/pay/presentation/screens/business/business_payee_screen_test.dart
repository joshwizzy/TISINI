import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/business_pay_state.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/presentation/screens/business/business_payee_screen.dart';
import 'package:tisini/features/pay/providers/business_pay_controller_provider.dart';
import 'package:tisini/features/pay/providers/business_payees_provider.dart';
import 'package:tisini/features/pay/providers/payment_routes_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        businessPayControllerProvider.overrideWith(
          _MockBusinessPayController.new,
        ),
        businessPayeesProvider('Suppliers').overrideWith(
          (ref) async => [
            const Payee(
              id: 'p-biz-001',
              name: 'Acme Supplies Ltd',
              identifier: '1234567890',
              rail: PaymentRail.bank,
              isPinned: false,
            ),
          ],
        ),
        paymentRoutesProvider.overrideWith((ref) async => []),
      ],
      child: const MaterialApp(home: BusinessPayeeScreen()),
    );
  }

  group('BusinessPayeeScreen', () {
    testWidgets('renders Suppliers in app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Suppliers'), findsOneWidget);
    });

    testWidgets('renders search bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Search payees...'), findsOneWidget);
    });
  });
}

class _MockBusinessPayController extends BusinessPayController {
  @override
  Future<BusinessPayState> build() async {
    return const BusinessPayState.selectingPayee(category: 'Suppliers');
  }
}
