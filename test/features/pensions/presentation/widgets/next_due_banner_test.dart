import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pensions/presentation/widgets/next_due_banner.dart';

void main() {
  group('NextDueBanner', () {
    testWidgets('shows due date and amount', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NextDueBanner(
              nextDueDate: DateTime(2026, 4),
              nextDueAmount: 5000000,
              currency: 'UGX',
              onContribute: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Next Contribution Due'), findsOneWidget);
      expect(find.text('01 Apr 2026'), findsOneWidget);
      expect(find.text('UGX 5,000,000'), findsOneWidget);
      expect(find.text('Contribute now'), findsOneWidget);

      await tester.tap(find.text('Contribute now'));
      expect(tapped, true);
    });

    testWidgets('handles null due date and amount', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NextDueBanner(currency: 'UGX', onContribute: () {}),
          ),
        ),
      );

      expect(find.text('Next Contribution Due'), findsOneWidget);
      expect(find.text('Contribute now'), findsOneWidget);
    });
  });
}
