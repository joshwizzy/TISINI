import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/presentation/widgets/column_mapping_row.dart';

void main() {
  group('ColumnMappingRow', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColumnMappingRow(
              label: 'Date',
              columns: const ['Col1', 'Col2'],
              selectedColumn: null,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Date'), findsOneWidget);
    });

    testWidgets('renders dropdown with columns', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColumnMappingRow(
              label: 'Date',
              columns: const ['Col1', 'Col2'],
              selectedColumn: null,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

      // Open the dropdown to verify column items
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      expect(find.text('Col1'), findsWidgets);
      expect(find.text('Col2'), findsWidgets);
    });

    testWidgets('renders sample value when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColumnMappingRow(
              label: 'Date',
              columns: const ['Col1', 'Col2'],
              selectedColumn: null,
              onChanged: (_) {},
              sampleValue: 'sample',
            ),
          ),
        ),
      );

      expect(find.text('Sample: sample'), findsOneWidget);
    });

    testWidgets('does not render sample when null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColumnMappingRow(
              label: 'Date',
              columns: const ['Col1', 'Col2'],
              selectedColumn: null,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.textContaining('Sample:'), findsNothing);
    });
  });
}
