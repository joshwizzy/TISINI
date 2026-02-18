import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/presentation/screens/legal_about_screen.dart';

void main() {
  group('LegalAboutScreen', () {
    testWidgets('shows legal links', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LegalAboutScreen()));

      expect(find.text('Legal & About'), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Open Source Licences'), findsOneWidget);
    });

    testWidgets('shows app version', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LegalAboutScreen()));

      expect(find.text('Tisini v1.0.0'), findsOneWidget);
    });

    testWidgets('shows new rails placeholder', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LegalAboutScreen()));

      expect(find.text('New payment rails coming soon'), findsOneWidget);
    });
  });
}
