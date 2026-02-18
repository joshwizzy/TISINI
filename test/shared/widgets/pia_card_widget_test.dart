import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/entities/pia_action.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';
import 'package:tisini/shared/widgets/pia_card_widget.dart';

void main() {
  PiaCard makeCard({
    PiaCardPriority priority = PiaCardPriority.medium,
    List<PiaAction> actions = const [],
  }) {
    return PiaCard(
      id: 'pia-001',
      title: 'Supplier payment due',
      what: 'ABC Supplies invoice due in 3 days',
      why: 'Maintain consistency score',
      details: 'Recurring order details',
      actions: actions,
      priority: priority,
      status: PiaCardStatus.active,
      isPinned: false,
      createdAt: DateTime(2025, 6, 15),
    );
  }

  Widget buildWidget({
    PiaCard? card,
    bool isExpanded = false,
    VoidCallback? onTap,
    void Function(PiaAction)? onAction,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: PiaCardWidget(
          card: card ?? makeCard(),
          isExpanded: isExpanded,
          onTap: onTap,
          onAction: onAction,
        ),
      ),
    );
  }

  group('PiaCardWidget', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Supplier payment due'), findsOneWidget);
    });

    testWidgets('renders what text', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('ABC Supplies invoice due in 3 days'), findsOneWidget);
    });

    testWidgets('hides why/details in compact mode', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Maintain consistency score'), findsNothing);
      expect(find.text('Recurring order details'), findsNothing);
    });

    testWidgets('shows why/details in expanded mode', (tester) async {
      await tester.pumpWidget(buildWidget(isExpanded: true));

      expect(find.text('Maintain consistency score'), findsOneWidget);
      expect(find.text('Recurring order details'), findsOneWidget);
    });

    testWidgets('renders action buttons', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          card: makeCard(
            actions: const [
              PiaAction(
                id: 'a1',
                type: PiaActionType.schedulePayment,
                label: 'Schedule',
              ),
            ],
          ),
        ),
      );

      expect(find.text('Schedule'), findsOneWidget);
    });

    testWidgets('calls onAction when action tapped', (tester) async {
      PiaAction? tappedAction;
      await tester.pumpWidget(
        buildWidget(
          card: makeCard(
            actions: const [
              PiaAction(
                id: 'a1',
                type: PiaActionType.schedulePayment,
                label: 'Schedule',
              ),
            ],
          ),
          onAction: (action) => tappedAction = action,
        ),
      );

      await tester.tap(find.text('Schedule'));
      expect(tappedAction, isNotNull);
      expect(tappedAction!.id, 'a1');
    });

    testWidgets('calls onTap when card tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildWidget(onTap: () => tapped = true));

      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, true);
    });
  });
}
