import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/activity/presentation/screens/export_period_screen.dart';

void main() {
  group('ExportPeriodScreen', () {
    testWidgets('shows period options', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ExportPeriodScreen())),
      );

      expect(find.text('Export Period'), findsOneWidget);
      expect(find.text('This month'), findsOneWidget);
      expect(find.text('Last month'), findsOneWidget);
      expect(find.text('Custom range'), findsOneWidget);
    });

    testWidgets('shows continue button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ExportPeriodScreen())),
      );

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('shows date picker for custom range', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ExportPeriodScreen())),
      );

      await tester.tap(find.text('Custom range'));
      await tester.pump();

      expect(find.text('Select dates'), findsOneWidget);
    });

    testWidgets('selects period option', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ExportPeriodScreen())),
      );

      await tester.tap(find.text('Last month'));
      await tester.pump();

      // All 3 options remain visible after selection
      expect(find.text('This month'), findsOneWidget);
      expect(find.text('Last month'), findsOneWidget);
      expect(find.text('Custom range'), findsOneWidget);
    });
  });
}
