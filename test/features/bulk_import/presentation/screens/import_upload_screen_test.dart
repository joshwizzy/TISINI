import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/presentation/screens/import_upload_screen.dart';
import 'package:tisini/features/bulk_import/presentation/widgets/column_mapping_row.dart';
import 'package:tisini/features/bulk_import/providers/import_controller.dart';

class TestImportController extends ImportController {
  TestImportController(this._state);

  final ImportState _state;

  @override
  Future<ImportState> build() async => _state;
}

void main() {
  group('ImportUploadScreen', () {
    const mappingState = ImportState.mapping(
      columns: ['Date', 'Amount', 'Description', 'Ref'],
      sampleRows: [
        ['2024-01-15', '50000', 'MTN Airtime', 'TXN001'],
        ['2024-01-16', '120000', 'Jumia Uganda', 'TXN002'],
      ],
    );

    testWidgets('renders Map Columns app bar title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(mappingState),
            ),
          ],
          child: const MaterialApp(home: ImportUploadScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Map Columns'), findsOneWidget);
    });

    testWidgets('renders Map your columns heading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(mappingState),
            ),
          ],
          child: const MaterialApp(home: ImportUploadScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Map your columns'), findsOneWidget);
    });

    testWidgets('renders 4 ColumnMappingRow widgets', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(mappingState),
            ),
          ],
          child: const MaterialApp(home: ImportUploadScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(ColumnMappingRow), findsNWidgets(4));
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Merchant / Description'), findsOneWidget);
      expect(find.text('Reference'), findsOneWidget);
    });

    testWidgets('Continue button disabled when no columns selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(mappingState),
            ),
          ],
          child: const MaterialApp(home: ImportUploadScreen()),
        ),
      );
      await tester.pump();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Continue'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('renders Sample data section', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(mappingState),
            ),
          ],
          child: const MaterialApp(home: ImportUploadScreen()),
        ),
      );
      await tester.pump();

      // Scroll down to see Sample data section
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pump();

      expect(find.text('Sample data'), findsOneWidget);
      expect(find.byType(DataTable), findsOneWidget);
    });

    testWidgets('shows loading when state is not mapping', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(const ImportState.choosingSource()),
            ),
          ],
          child: const MaterialApp(home: ImportUploadScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
