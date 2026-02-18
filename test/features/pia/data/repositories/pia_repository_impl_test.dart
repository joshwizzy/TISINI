import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/data/datasources/mock_pia_remote_datasource.dart';
import 'package:tisini/features/pia/data/repositories/pia_repository_impl.dart';

void main() {
  late PiaRepositoryImpl repository;

  setUp(() {
    repository = PiaRepositoryImpl(datasource: MockPiaRemoteDatasource());
  });

  group('PiaRepositoryImpl', () {
    test('getCards returns domain entities', () async {
      final result = await repository.getCards();

      expect(result.cards, hasLength(7));
      expect(result.hasMore, false);
      expect(result.nextCursor, isNull);

      final first = result.cards.first;
      expect(first.id, 'pia-001');
      expect(first.priority, PiaCardPriority.high);
      expect(first.status, PiaCardStatus.active);
      expect(first.createdAt, isA<DateTime>());
    });

    test('getCard returns domain entity by id', () async {
      final card = await repository.getCard('pia-003');

      expect(card.id, 'pia-003');
      expect(card.title, 'New supplier detected');
      expect(card.priority, PiaCardPriority.medium);
      expect(card.actions, hasLength(1));
      expect(card.actions.first.type, PiaActionType.askUserConfirmation);
    });

    test('executeAction returns success message', () async {
      final message = await repository.executeAction(
        cardId: 'pia-001',
        actionId: 'a-001',
      );

      expect(message, contains('Schedule payment'));
    });

    test('updateCard returns updated domain entity', () async {
      final card = await repository.updateCard(
        'pia-002',
        status: PiaCardStatus.dismissed,
      );

      expect(card.id, 'pia-002');
      expect(card.status, PiaCardStatus.dismissed);
    });

    test('updateCard sets isPinned', () async {
      final card = await repository.updateCard('pia-003', isPinned: true);

      expect(card.id, 'pia-003');
      expect(card.isPinned, true);
    });

    test('getCards with pagination', () async {
      final page1 = await repository.getCards(limit: 3);

      expect(page1.cards, hasLength(3));
      expect(page1.hasMore, true);
      expect(page1.nextCursor, isNotNull);

      final page2 = await repository.getCards(
        cursor: page1.nextCursor,
        limit: 3,
      );

      expect(page2.cards, hasLength(3));
    });
  });
}
