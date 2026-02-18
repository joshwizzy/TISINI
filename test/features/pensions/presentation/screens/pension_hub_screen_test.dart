import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pensions/presentation/screens/pension_hub_screen.dart';

void main() {
  group('PensionHubScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PensionHubScreen())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Settle pending timers from mock datasource delays
      await tester.pumpAndSettle();
    });

    testWidgets('shows pension status after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PensionHubScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Pensions'), findsOneWidget);
      expect(find.text('NSSF Account'), findsOneWidget);
      expect(find.text('NSSF-UG-123456'), findsOneWidget);
      expect(find.text('Next Contribution Due'), findsOneWidget);
      expect(find.text('Contribute now'), findsOneWidget);
    });

    testWidgets('shows recent contributions section', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PensionHubScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Recent Contributions'), findsOneWidget);
      expect(find.text('See all'), findsOneWidget);
    });

    testWidgets('shows reminders section', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PensionHubScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Reminders'), findsOneWidget);
    });

    testWidgets('shows Contribute FAB', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PensionHubScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Contribute'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
