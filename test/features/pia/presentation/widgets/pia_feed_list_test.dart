import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/entities/pia_action.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';
import 'package:tisini/features/pia/presentation/widgets/pia_feed_list.dart';

void main() {
  final testCards = [
    PiaCard(
      id: 'card-1',
      title: 'Pension due soon',
      what: 'Your NSSF contribution is due',
      why: 'Avoid late penalties',
      details: 'Due in 5 days',
      actions: const [
        PiaAction(
          id: 'a-1',
          type: PiaActionType.schedulePayment,
          label: 'Schedule',
        ),
      ],
      priority: PiaCardPriority.high,
      status: PiaCardStatus.active,
      isPinned: false,
      createdAt: DateTime(2026),
    ),
    PiaCard(
      id: 'card-2',
      title: 'Export monthly report',
      what: 'Your January report is ready',
      why: 'Keep records up to date',
      details: 'Export now',
      actions: const [],
      priority: PiaCardPriority.low,
      status: PiaCardStatus.active,
      isPinned: false,
      createdAt: DateTime(2026),
    ),
  ];

  group('PiaFeedList', () {
    testWidgets('shows empty message when cards list is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PiaFeedList(cards: [])),
        ),
      );

      expect(find.text('No insights yet'), findsOneWidget);
    });

    testWidgets('shows custom empty message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PiaFeedList(cards: [], emptyMessage: 'Nothing pinned'),
          ),
        ),
      );

      expect(find.text('Nothing pinned'), findsOneWidget);
    });

    testWidgets('renders card titles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: PiaFeedList(cards: testCards)),
        ),
      );

      expect(find.text('Pension due soon'), findsOneWidget);
      expect(find.text('Export monthly report'), findsOneWidget);
    });

    testWidgets('card tap fires callback', (tester) async {
      PiaCard? tapped;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PiaFeedList(
              cards: testCards,
              onTapCard: (card) => tapped = card,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Pension due soon'));
      expect(tapped?.id, 'card-1');
    });

    testWidgets('swipe dismiss fires callback', (tester) async {
      PiaCard? dismissed;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PiaFeedList(
              cards: testCards,
              onDismiss: (card) => dismissed = card,
            ),
          ),
        ),
      );

      await tester.drag(find.text('Pension due soon'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(dismissed?.id, 'card-1');
    });

    testWidgets('long press fires pin callback', (tester) async {
      PiaCard? pinned;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PiaFeedList(cards: testCards, onPin: (card) => pinned = card),
          ),
        ),
      );

      await tester.longPress(find.text('Pension due soon'));
      expect(pinned?.id, 'card-1');
    });

    testWidgets('action button fires action callback', (tester) async {
      PiaAction? firedAction;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PiaFeedList(
              cards: testCards,
              onAction: (card, action) => firedAction = action,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Schedule'));
      expect(firedAction?.id, 'a-1');
    });
  });
}
