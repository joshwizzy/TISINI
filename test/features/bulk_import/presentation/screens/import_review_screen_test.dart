import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_mapping.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_state.dart';
import 'package:tisini/features/bulk_import/presentation/screens/import_review_screen.dart';
import 'package:tisini/features/bulk_import/providers/import_controller.dart';

class TestImportController extends ImportController {
  TestImportController(this._state);

  final ImportState _state;

  @override
  Future<ImportState> build() async => _state;
}

void main() {
  group('ImportReviewScreen', () {
    const reviewingState = ImportState.reviewing(
      mapping: ImportMapping(
        dateColumn: 'Date',
        amountColumn: 'Amount',
        merchantColumn: 'Description',
        referenceColumn: 'Ref',
      ),
      totalRows: 150,
      autoCategorised: 120,
      uncategorised: 30,
    );

    testWidgets('renders Review Import app bar title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(reviewingState),
            ),
          ],
          child: const MaterialApp(home: ImportReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Review Import'), findsOneWidget);
    });

    testWidgets('renders Import summary heading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(reviewingState),
            ),
          ],
          child: const MaterialApp(home: ImportReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Import summary'), findsOneWidget);
    });

    testWidgets('renders row stats', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(reviewingState),
            ),
          ],
          child: const MaterialApp(home: ImportReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Total rows'), findsOneWidget);
      expect(find.text('150'), findsOneWidget);
      expect(find.text('Auto-categorised'), findsOneWidget);
      expect(find.text('120'), findsOneWidget);
      expect(find.text('Uncategorised'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
    });

    testWidgets('renders column mapping summary', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(reviewingState),
            ),
          ],
          child: const MaterialApp(home: ImportReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Column mapping'), findsOneWidget);
      expect(find.text('Date'), findsNWidgets(2));
      expect(find.text('Amount'), findsNWidgets(2));
      expect(find.text('Merchant'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Reference'), findsOneWidget);
      expect(find.text('Ref'), findsOneWidget);
    });

    testWidgets('renders Import button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(reviewingState),
            ),
          ],
          child: const MaterialApp(home: ImportReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Import'), findsOneWidget);
    });

    testWidgets('shows loading when state is not reviewing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            importControllerProvider.overrideWith(
              () => TestImportController(const ImportState.choosingSource()),
            ),
          ],
          child: const MaterialApp(home: ImportReviewScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
