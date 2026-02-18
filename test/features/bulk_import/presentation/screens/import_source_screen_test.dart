import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/presentation/screens/import_source_screen.dart';
import 'package:tisini/features/bulk_import/providers/import_controller.dart';

class TestImportController extends ImportController {
  TestImportController(this._state);

  final ImportState _state;

  @override
  Future<ImportState> build() async => _state;
}

void main() {
  group('ImportSourceScreen', () {
    testWidgets('renders Import Statements app bar title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(const ImportState.choosingSource()),
            ),
          ],
          child: const MaterialApp(home: ImportSourceScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Import Statements'), findsOneWidget);
    });

    testWidgets('renders Bank Statement (CSV) card', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(const ImportState.choosingSource()),
            ),
          ],
          child: const MaterialApp(home: ImportSourceScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Bank Statement (CSV)'), findsOneWidget);
    });

    testWidgets('renders Mobile Money Statement card', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(const ImportState.choosingSource()),
            ),
          ],
          child: const MaterialApp(home: ImportSourceScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Mobile Money Statement'), findsOneWidget);
    });
  });
}
