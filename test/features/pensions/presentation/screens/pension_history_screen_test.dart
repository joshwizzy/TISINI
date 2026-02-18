import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pensions/presentation/screens/pension_history_screen.dart';

void main() {
  group('PensionHistoryScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PensionHistoryScreen())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Settle pending timers from mock datasource delays
      await tester.pumpAndSettle();
    });

    testWidgets('shows contributions after loading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PensionHistoryScreen())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Contribution History'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      // "Completed" appears in filter chip + contribution badges
      expect(find.text('Completed'), findsWidgets);
      expect(find.text('Pending'), findsWidgets);
      expect(find.text('Failed'), findsOneWidget);
    });

    testWidgets('filter chips work', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PensionHistoryScreen())),
      );

      await tester.pumpAndSettle();

      // Tap Completed filter (use first match - the filter chip)
      await tester.tap(find.text('Completed').first);
      await tester.pumpAndSettle();

      // Should still show the filter chip
      expect(find.text('Completed'), findsWidgets);

      // Tap Pending filter (use first match)
      await tester.tap(find.text('Pending').first);
      await tester.pumpAndSettle();

      expect(find.text('Pending'), findsWidgets);

      // Tap All to reset
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
    });
  });
}
