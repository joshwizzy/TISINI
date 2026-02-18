import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_details_screen.dart';
import 'package:tisini/features/pay/providers/send_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [sendControllerProvider.overrideWith(_MockSendController.new)],
      child: const MaterialApp(home: SendDetailsScreen()),
    );
  }

  group('SendDetailsScreen', () {
    testWidgets('renders Payment Details app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Payment Details'), findsOneWidget);
    });

    testWidgets('renders payee name', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Jane Nakamya'), findsOneWidget);
    });

    testWidgets('renders reference field', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Reference (optional)'), findsOneWidget);
    });

    testWidgets('renders category section', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Category'), findsOneWidget);
    });

    testWidgets('renders text input fields', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Reference + note fields + category tags rendered
      expect(find.byType(TextField), findsAtLeast(1));
    });
  });
}

class _MockSendController extends SendController {
  @override
  Future<SendState> build() async {
    return const SendState.enteringDetails(
      payee: Payee(
        id: 'p-001',
        name: 'Jane Nakamya',
        identifier: '+256700100200',
        rail: PaymentRail.mobileMoney,
        isPinned: false,
      ),
    );
  }
}
