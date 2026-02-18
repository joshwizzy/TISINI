import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/data/datasources/mock_pia_remote_datasource.dart';

void main() {
  late MockPiaRemoteDatasource datasource;

  setUp(() {
    datasource = MockPiaRemoteDatasource();
  });

  group('MockPiaRemoteDatasource', () {
    test('getCards returns 7 active cards', () async {
      final result = await datasource.getCards();

      expect(result.cards, hasLength(7));
      expect(result.hasMore, false);
      expect(result.nextCursor, isNull);
    });

    test('getCards returns cards with valid fields', () async {
      final result = await datasource.getCards();
      final first = result.cards.first;

      expect(first.id, 'pia-001');
      expect(first.title, 'Pension due soon');
      expect(first.priority, 'high');
      expect(first.status, 'active');
      expect(first.isPinned, false);
      expect(first.actions, isNotEmpty);
    });

    test('getCards supports pagination with limit', () async {
      final page1 = await datasource.getCards(limit: 3);

      expect(page1.cards, hasLength(3));
      expect(page1.hasMore, true);
      expect(page1.nextCursor, isNotNull);

      final page2 = await datasource.getCards(
        cursor: page1.nextCursor,
        limit: 3,
      );

      expect(page2.cards, hasLength(3));
      expect(page2.hasMore, true);

      final page3 = await datasource.getCards(
        cursor: page2.nextCursor,
        limit: 3,
      );

      expect(page3.cards, hasLength(1));
      expect(page3.hasMore, false);
    });

    test('getCard returns card by id', () async {
      final card = await datasource.getCard('pia-003');

      expect(card.id, 'pia-003');
      expect(card.title, 'New supplier detected');
      expect(card.priority, 'medium');
    });

    test('getCard throws for unknown id', () async {
      expect(() => datasource.getCard('unknown'), throwsException);
    });

    test('executeAction returns success message', () async {
      final message = await datasource.executeAction(
        cardId: 'pia-001',
        actionId: 'a-001',
      );

      expect(message, contains('Schedule payment'));
      expect(message, contains('Pension due soon'));
    });

    test('executeAction throws for unknown card', () async {
      expect(
        () => datasource.executeAction(cardId: 'unknown', actionId: 'a-001'),
        throwsException,
      );
    });

    test('executeAction throws for unknown action', () async {
      expect(
        () => datasource.executeAction(cardId: 'pia-001', actionId: 'unknown'),
        throwsException,
      );
    });

    test('updateCard updates status', () async {
      final card = await datasource.updateCard(
        'pia-001',
        status: PiaCardStatus.dismissed,
      );

      expect(card.id, 'pia-001');
      expect(card.status, 'dismissed');
    });

    test('updateCard updates isPinned', () async {
      final card = await datasource.updateCard('pia-001', isPinned: true);

      expect(card.id, 'pia-001');
      expect(card.isPinned, true);
    });

    test('updateCard throws for unknown id', () async {
      expect(() => datasource.updateCard('unknown'), throwsException);
    });

    test('dismissed cards are excluded from getCards', () async {
      await datasource.updateCard('pia-001', status: PiaCardStatus.dismissed);

      final result = await datasource.getCards();

      expect(result.cards, hasLength(6));
      expect(result.cards.any((c) => c.id == 'pia-001'), false);
    });

    test('card 7 is pinned by default', () async {
      final card = await datasource.getCard('pia-007');

      expect(card.isPinned, true);
      expect(card.priority, 'medium');
    });

    test('card with multiple actions', () async {
      final card = await datasource.getCard('pia-006');

      expect(card.actions, hasLength(2));
      expect(card.actions[0].type, 'set_reminder');
      expect(card.actions[1].type, 'schedule_payment');
    });
  });
}
