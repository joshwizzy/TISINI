import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';
import 'package:tisini/shared/widgets/funding_source_card.dart';

void main() {
  const source = FundingSource(
    rail: PaymentRail.mobileMoney,
    label: 'MTN Mobile Money',
    identifier: '+256700100200',
    isAvailable: true,
  );

  group('FundingSourceCard', () {
    testWidgets('renders source label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FundingSourceCard(source: source)),
        ),
      );

      expect(find.text('MTN Mobile Money'), findsOneWidget);
    });

    testWidgets('renders source identifier', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FundingSourceCard(source: source)),
        ),
      );

      expect(find.text('+256700100200'), findsOneWidget);
    });

    testWidgets('calls onTap when available', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FundingSourceCard(source: source, onTap: () => tapped = true),
          ),
        ),
      );

      await tester.tap(find.byType(FundingSourceCard));
      expect(tapped, true);
    });

    testWidgets('does not call onTap when unavailable', (tester) async {
      var tapped = false;
      const unavailable = FundingSource(
        rail: PaymentRail.card,
        label: 'Visa *4242',
        identifier: '**** 4242',
        isAvailable: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FundingSourceCard(
              source: unavailable,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FundingSourceCard));
      expect(tapped, false);
    });

    testWidgets('shows check icon when selected', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FundingSourceCard(source: source, isSelected: true),
          ),
        ),
      );

      expect(find.byType(FundingSourceCard), findsOneWidget);
    });
  });
}
