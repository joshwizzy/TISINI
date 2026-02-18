import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_result.dart';
import 'package:tisini/features/bulk_import/presentation/widgets/import_summary_card.dart';

void main() {
  group('ImportSummaryCard', () {
    testWidgets('renders imported count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImportSummaryCard(
              result: ImportResult(
                jobId: 'j1',
                totalImported: 138,
                categorised: 89,
                uncategorised: 49,
                errors: [],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Imported'), findsOneWidget);
      expect(find.text('138'), findsOneWidget);
    });

    testWidgets('renders categorised count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImportSummaryCard(
              result: ImportResult(
                jobId: 'j1',
                totalImported: 138,
                categorised: 89,
                uncategorised: 49,
                errors: [],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Categorised'), findsOneWidget);
      expect(find.text('89'), findsOneWidget);
    });

    testWidgets('renders uncategorised count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImportSummaryCard(
              result: ImportResult(
                jobId: 'j1',
                totalImported: 138,
                categorised: 89,
                uncategorised: 49,
                errors: [],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Uncategorised'), findsOneWidget);
      expect(find.text('49'), findsOneWidget);
    });

    testWidgets('renders error count when errors present', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImportSummaryCard(
              result: ImportResult(
                jobId: 'j1',
                totalImported: 138,
                categorised: 89,
                uncategorised: 49,
                errors: ['err1'],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Errors'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });
  });
}
