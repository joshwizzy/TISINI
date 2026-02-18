import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/presentation/widgets/import_progress_bar.dart';

void main() {
  group('ImportProgressBar', () {
    testWidgets('renders row count text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImportProgressBar(
              processedRows: 72,
              totalRows: 142,
              statusLabel: 'Processing',
            ),
          ),
        ),
      );

      expect(find.text('72 / 142 rows'), findsOneWidget);
    });

    testWidgets('renders status label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImportProgressBar(
              processedRows: 72,
              totalRows: 142,
              statusLabel: 'Processing',
            ),
          ),
        ),
      );

      expect(find.text('Processing'), findsOneWidget);
    });

    testWidgets('shows LinearProgressIndicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImportProgressBar(
              processedRows: 72,
              totalRows: 142,
              statusLabel: 'Processing',
            ),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}
