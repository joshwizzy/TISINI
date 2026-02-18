import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/more/presentation/screens/help_support_screen.dart';

void main() {
  group('HelpSupportScreen', () {
    testWidgets('shows loading initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HelpSupportScreen())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows FAQ questions after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HelpSupportScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('How do I send money?'), findsOneWidget);
      expect(find.text('How do I link my NSSF account?'), findsOneWidget);
    });

    testWidgets('shows Contact Support button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HelpSupportScreen())),
      );

      await tester.pumpAndSettle();

      // Scroll down to see Contact Support button
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('Contact Support'), findsOneWidget);
    });

    testWidgets('expands FAQ to show answer', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: HelpSupportScreen())),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('How do I send money?'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Go to the Pay tab'), findsOneWidget);
    });
  });
}
