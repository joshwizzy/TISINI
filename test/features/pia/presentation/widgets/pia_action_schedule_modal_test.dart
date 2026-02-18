import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pia/presentation/widgets/pia_action_schedule_modal.dart';

void main() {
  group('PiaActionScheduleModal — schedule mode', () {
    testWidgets('shows schedule UI with payee name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => PiaActionScheduleModal(
                      mode: PiaScheduleMode.schedule,
                      params: const {'payeeName': 'NSSF'},
                      onConfirm: (_) {},
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Schedule NSSF'), findsOneWidget);
      expect(find.text('Change'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Amount (optional)'), findsOneWidget);
    });

    testWidgets('submit schedule calls onConfirm', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => PiaActionScheduleModal(
                      mode: PiaScheduleMode.schedule,
                      onConfirm: (r) => result = r,
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.containsKey('date'), true);
    });
  });

  group('PiaActionScheduleModal — confirm mode', () {
    testWidgets('shows confirm UI with question', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => PiaActionScheduleModal(
                      mode: PiaScheduleMode.confirm,
                      params: const {'question': 'Is this a new supplier?'},
                      onConfirm: (_) {},
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Is this a new supplier?'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('yes button confirms with true', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => PiaActionScheduleModal(
                      mode: PiaScheduleMode.confirm,
                      onConfirm: (r) => result = r,
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(result?['confirmed'], true);
    });

    testWidgets('no button confirms with false', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => PiaActionScheduleModal(
                      mode: PiaScheduleMode.confirm,
                      onConfirm: (r) => result = r,
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(result?['confirmed'], false);
    });
  });
}
