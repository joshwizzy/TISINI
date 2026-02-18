import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_result.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/presentation/screens/import_result_screen.dart';
import 'package:tisini/features/bulk_import/presentation/widgets/import_summary_card.dart';
import 'package:tisini/features/bulk_import/providers/import_controller.dart';

class TestImportController extends ImportController {
  TestImportController(this._state);

  final ImportState _state;

  @override
  Future<ImportState> build() async => _state;
}

void main() {
  group('ImportResultScreen', () {
    const testResult = ImportResult(
      jobId: 'job-001',
      totalImported: 142,
      categorised: 120,
      uncategorised: 22,
      errors: [],
    );

    testWidgets('renders Import Complete when in completed state', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(
                const ImportState.completed(result: testResult),
              ),
            ),
          ],
          child: const MaterialApp(home: ImportResultScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Import Complete'), findsOneWidget);
    });

    testWidgets('renders ImportSummaryCard', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(
                const ImportState.completed(result: testResult),
              ),
            ),
          ],
          child: const MaterialApp(home: ImportResultScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(ImportSummaryCard), findsOneWidget);
    });
  });
}
