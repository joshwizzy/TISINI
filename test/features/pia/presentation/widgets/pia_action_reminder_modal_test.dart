import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pia/presentation/widgets/pia_action_reminder_modal.dart';

void main() {
  group('PiaActionReminderModal', () {
    testWidgets('shows title and controls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => PiaActionReminderModal(
                      onConfirm: ({required date, amount}) {},
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

      expect(find.text('Set Reminder'), findsOneWidget);
      expect(find.text('Change'), findsOneWidget);
      expect(find.text('Set reminder'), findsOneWidget);
      expect(find.text('Amount (optional)'), findsOneWidget);
    });

    testWidgets('submit calls onConfirm and pops', (tester) async {
      DateTime? confirmedDate;
      double? confirmedAmount;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => PiaActionReminderModal(
                      onConfirm: ({required date, amount}) {
                        confirmedDate = date;
                        confirmedAmount = amount;
                      },
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

      await tester.enterText(find.byType(TextField), '5000');
      await tester.tap(find.text('Set reminder'));
      await tester.pumpAndSettle();

      expect(confirmedDate, isNotNull);
      expect(confirmedAmount, 5000);
      expect(find.text('Set Reminder'), findsNothing);
    });

    testWidgets('submit without amount passes null', (tester) async {
      double? confirmedAmount = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => PiaActionReminderModal(
                      onConfirm: ({required date, amount}) {
                        confirmedAmount = amount;
                      },
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

      await tester.tap(find.text('Set reminder'));
      await tester.pumpAndSettle();

      expect(confirmedAmount, isNull);
    });
  });
}
