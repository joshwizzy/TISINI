import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/kyc/presentation/screens/kyc_pending_screen.dart';

void main() {
  group('KycPendingScreen', () {
    testWidgets('renders Verification Status app bar title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: KycPendingScreen()));
      await tester.pump();

      expect(find.text('Verification Status'), findsOneWidget);
    });

    testWidgets('renders Being reviewed text', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: KycPendingScreen()));
      await tester.pump();

      expect(find.text('Being reviewed'), findsOneWidget);
    });

    testWidgets('renders 1-2 business days text', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: KycPendingScreen()));
      await tester.pump();

      expect(find.textContaining('1-2 business days'), findsOneWidget);
    });

    testWidgets('renders Done button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: KycPendingScreen()));
      await tester.pump();

      expect(find.text('Done'), findsOneWidget);
    });
  });
}
