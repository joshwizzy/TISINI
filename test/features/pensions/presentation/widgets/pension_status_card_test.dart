import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/domain/entities/pension_status.dart';
import 'package:tisini/features/pensions/presentation/widgets/pension_status_card.dart';

void main() {
  group('PensionStatusCard', () {
    testWidgets('shows NSSF number when linked', (tester) async {
      const status = PensionStatus(
        linkStatus: PensionLinkStatus.linked,
        currency: 'UGX',
        totalContributions: 3,
        totalAmount: 15000000,
        nssfNumber: 'NSSF-UG-123456',
        activeReminders: [],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PensionStatusCard(status: status)),
        ),
      );

      expect(find.text('NSSF Account'), findsOneWidget);
      expect(find.text('NSSF-UG-123456'), findsOneWidget);
      expect(find.text('Linked'), findsOneWidget);
      expect(find.text('Connect NSSF'), findsNothing);
    });

    testWidgets('shows Connect button when not linked', (tester) async {
      var tapped = false;

      const status = PensionStatus(
        linkStatus: PensionLinkStatus.notLinked,
        currency: 'UGX',
        totalContributions: 0,
        totalAmount: 0,
        activeReminders: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PensionStatusCard(
              status: status,
              onConnect: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Not Linked'), findsOneWidget);
      expect(find.text('Connect NSSF'), findsOneWidget);

      await tester.tap(find.text('Connect NSSF'));
      expect(tapped, true);
    });

    testWidgets('shows verifying badge', (tester) async {
      const status = PensionStatus(
        linkStatus: PensionLinkStatus.verifying,
        currency: 'UGX',
        totalContributions: 0,
        totalAmount: 0,
        nssfNumber: 'NSSF-UG-123456',
        activeReminders: [],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PensionStatusCard(status: status)),
        ),
      );

      expect(find.text('Verifying'), findsOneWidget);
      expect(find.text('Connect NSSF'), findsNothing);
    });
  });
}
