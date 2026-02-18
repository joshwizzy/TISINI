import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/presentation/screens/import_progress_screen.dart';
import 'package:tisini/features/bulk_import/presentation/widgets/import_progress_bar.dart';
import 'package:tisini/features/bulk_import/providers/import_controller.dart';

class TestImportController extends ImportController {
  TestImportController(this._state);

  final ImportState _state;

  @override
  Future<ImportState> build() async => _state;
}

void main() {
  group('ImportProgressScreen', () {
    testWidgets('renders Importing app bar title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(
                const ImportState.processing(jobId: 'job-1'),
              ),
            ),
          ],
          child: const MaterialApp(home: ImportProgressScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Importing'), findsOneWidget);
    });

    testWidgets('renders Processing your import text', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(
                const ImportState.processing(jobId: 'job-1'),
              ),
            ),
          ],
          child: const MaterialApp(home: ImportProgressScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Processing your import'), findsOneWidget);
    });

    testWidgets('renders ImportProgressBar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(
                const ImportState.processing(jobId: 'job-1'),
              ),
            ),
          ],
          child: const MaterialApp(home: ImportProgressScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(ImportProgressBar), findsOneWidget);
    });
  });
}
