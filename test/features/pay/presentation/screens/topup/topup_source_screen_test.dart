import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';
import 'package:tisini/features/pay/domain/entities/topup_state.dart';
import 'package:tisini/features/pay/presentation/screens/topup/topup_source_screen.dart';
import 'package:tisini/features/pay/providers/funding_sources_provider.dart';
import 'package:tisini/features/pay/providers/topup_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        topupControllerProvider.overrideWith(_MockTopupController.new),
        fundingSourcesProvider.overrideWith(
          (ref) async => [
            const FundingSource(
              rail: PaymentRail.mobileMoney,
              label: 'MTN Mobile Money',
              identifier: '+256700100200',
              isAvailable: true,
            ),
            const FundingSource(
              rail: PaymentRail.bank,
              label: 'Stanbic Bank',
              identifier: '9030012345678',
              isAvailable: true,
            ),
          ],
        ),
      ],
      child: const MaterialApp(home: TopupSourceScreen()),
    );
  }

  group('TopupSourceScreen', () {
    testWidgets('renders Top Up app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Top Up'), findsOneWidget);
    });

    testWidgets('renders Select funding source', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Select funding source'), findsOneWidget);
    });

    testWidgets('renders source labels', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('MTN Mobile Money'), findsOneWidget);
      expect(find.text('Stanbic Bank'), findsOneWidget);
    });
  });
}

class _MockTopupController extends TopupController {
  @override
  Future<TopupState> build() async {
    return const TopupState.selectingSource();
  }
}
