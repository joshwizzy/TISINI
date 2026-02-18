import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';
import 'package:tisini/features/pay/domain/entities/topup_state.dart';
import 'package:tisini/features/pay/presentation/screens/topup/topup_amount_screen.dart';
import 'package:tisini/features/pay/providers/topup_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        topupControllerProvider.overrideWith(_MockTopupController.new),
      ],
      child: const MaterialApp(home: TopupAmountScreen()),
    );
  }

  group('TopupAmountScreen', () {
    testWidgets('renders Enter Amount app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Enter Amount'), findsOneWidget);
    });

    testWidgets('renders source card', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('MTN Mobile Money'), findsOneWidget);
    });

    testWidgets('renders Continue button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Continue'), findsOneWidget);
    });
  });
}

class _MockTopupController extends TopupController {
  @override
  Future<TopupState> build() async {
    return const TopupState.enteringAmount(
      source: FundingSource(
        rail: PaymentRail.mobileMoney,
        label: 'MTN Mobile Money',
        identifier: '+256700100200',
        isAvailable: true,
      ),
    );
  }
}
