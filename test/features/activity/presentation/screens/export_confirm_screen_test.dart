import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/activity/presentation/screens/export_confirm_screen.dart';
import 'package:tisini/features/activity/providers/export_controller.dart';

void main() {
  group('ExportConfirmScreen', () {
    testWidgets('shows no export data when not confirming', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ExportConfirmScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.text('No export data'), findsOneWidget);
    });

    testWidgets('shows export summary when in confirming state', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Use runAsync to allow Future.delayed in the mock
      // datasource to complete (testWidgets uses fake async).
      await tester.runAsync(() async {
        container.listen(exportControllerProvider, (_, __) {});
        await container.read(exportControllerProvider.future);
        await container
            .read(exportControllerProvider.notifier)
            .setPeriod(startDate: DateTime(2020), endDate: DateTime(2030));
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: ExportConfirmScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Export Summary'), findsOneWidget);
      expect(find.text('CSV'), findsOneWidget);
      expect(find.text('Export'), findsOneWidget);
    });
  });
}
