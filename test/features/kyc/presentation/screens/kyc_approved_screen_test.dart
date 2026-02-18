import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/kyc/presentation/screens/kyc_approved_screen.dart';

void main() {
  group('KycApprovedScreen', () {
    testWidgets("renders You're verified text", (tester) async {
      await tester.pumpWidget(const MaterialApp(home: KycApprovedScreen()));
      await tester.pump();

      expect(find.text("You're verified"), findsOneWidget);
    });

    testWidgets('renders Done button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: KycApprovedScreen()));
      await tester.pump();

      expect(find.text('Done'), findsOneWidget);
    });
  });
}
