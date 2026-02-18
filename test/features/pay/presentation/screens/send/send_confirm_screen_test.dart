import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_confirm_screen.dart';
import 'package:tisini/features/pay/providers/send_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [sendControllerProvider.overrideWith(_MockSendController.new)],
      child: const MaterialApp(home: SendConfirmScreen()),
    );
  }

  group('SendConfirmScreen', () {
    testWidgets('renders Confirm app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('renders Sending to label', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Sending to'), findsOneWidget);
    });

    testWidgets('renders payee name', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Jane Nakamya'), findsOneWidget);
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

class _MockSendController extends SendController {
  @override
  Future<SendState> build() async {
    return const SendState.confirming(
      payee: Payee(
        id: 'p-001',
        name: 'Jane Nakamya',
        identifier: '+256700100200',
        rail: PaymentRail.mobileMoney,
        isPinned: false,
      ),
      category: TransactionCategory.people,
      amount: 150000,
      currency: 'UGX',
      route: PaymentRoute(
        rail: PaymentRail.mobileMoney,
        label: 'Mobile Money',
        isAvailable: true,
        fee: 500,
      ),
      fee: 500,
      total: 150500,
    );
  }
}
