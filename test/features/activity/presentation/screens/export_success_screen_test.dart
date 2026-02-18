import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/activity/presentation/screens/export_success_screen.dart';
import 'package:tisini/features/activity/providers/export_controller.dart';

void main() {
  group('ExportSuccessScreen', () {
    testWidgets('shows no export data when not in success state', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ExportSuccessScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.text('No export data'), findsOneWidget);
    });

    testWidgets('shows success content when in success state', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Use runAsync to allow Future.delayed in the mock
      // datasource to complete (testWidgets uses fake async).
      await tester.runAsync(() async {
        container.listen(exportControllerProvider, (_, __) {});
        await container.read(exportControllerProvider.future);
        await container
            .read(exportControllerProvider.notifier)
            .confirmExport(
              startDate: DateTime(2026),
              endDate: DateTime(2026, 2),
            );
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: ExportSuccessScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Export ready'), findsOneWidget);
      expect(find.text('Download'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });
  });
}
