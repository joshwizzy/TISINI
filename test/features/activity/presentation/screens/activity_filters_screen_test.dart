import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/activity/presentation/screens/activity_filters_screen.dart';

void main() {
  group('ActivityFiltersScreen', () {
    testWidgets('shows filter sections', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ActivityFiltersScreen())),
      );

      expect(find.text('Filters'), findsOneWidget);
      expect(find.text('Direction'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Date Range'), findsOneWidget);
    });

    testWidgets('shows direction segmented button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ActivityFiltersScreen())),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('In'), findsOneWidget);
      expect(find.text('Out'), findsOneWidget);
    });

    testWidgets('shows all category tags', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ActivityFiltersScreen())),
      );

      expect(find.text('Sales'), findsOneWidget);
      expect(find.text('Inventory'), findsOneWidget);
      expect(find.text('Bills'), findsOneWidget);
      expect(find.text('People'), findsOneWidget);
      expect(find.text('Compliance'), findsOneWidget);
      expect(find.text('Agency'), findsOneWidget);
      expect(find.text('Uncategorised'), findsOneWidget);
    });

    testWidgets('shows apply button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ActivityFiltersScreen())),
      );

      // Scroll down to reveal the Apply button at the bottom
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pump();

      expect(find.text('Apply'), findsOneWidget);
    });

    testWidgets('shows clear button in appbar', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ActivityFiltersScreen())),
      );

      expect(find.text('Clear'), findsOneWidget);
    });

    testWidgets('shows date range picker button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ActivityFiltersScreen())),
      );

      expect(find.text('Select date range'), findsOneWidget);
    });
  });
}
