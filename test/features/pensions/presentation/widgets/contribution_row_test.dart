import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribution.dart';
import 'package:tisini/features/pensions/presentation/widgets/contribution_row.dart';

void main() {
  group('ContributionRow', () {
    testWidgets('shows completed contribution', (tester) async {
      final contribution = PensionContribution(
        id: 'pc-001',
        amount: 5000000,
        currency: 'UGX',
        status: ContributionStatus.completed,
        rail: PaymentRail.mobileMoney,
        reference: 'NSSF Jan 2026',
        createdAt: DateTime(2026),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ContributionRow(contribution: contribution)),
        ),
      );

      expect(find.text('01 Jan 2026'), findsOneWidget);
      expect(find.text('NSSF Jan 2026'), findsOneWidget);
      expect(find.text('UGX 5,000,000'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('shows pending contribution', (tester) async {
      final contribution = PensionContribution(
        id: 'pc-002',
        amount: 3000000,
        currency: 'UGX',
        status: ContributionStatus.pending,
        rail: PaymentRail.bank,
        createdAt: DateTime(2026, 2),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ContributionRow(contribution: contribution)),
        ),
      );

      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('UGX 3,000,000'), findsOneWidget);
    });

    testWidgets('shows failed contribution', (tester) async {
      final contribution = PensionContribution(
        id: 'pc-003',
        amount: 5000000,
        currency: 'UGX',
        status: ContributionStatus.failed,
        rail: PaymentRail.mobileMoney,
        createdAt: DateTime(2026, 3),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ContributionRow(contribution: contribution)),
        ),
      );

      expect(find.text('Failed'), findsOneWidget);
    });
  });
}
