import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';
import 'package:tisini/features/pia/domain/repositories/pia_repository.dart';

class _FakePiaRepository implements PiaRepository {
  @override
  Future<({List<PiaCard> cards, String? nextCursor, bool hasMore})> getCards({
    String? cursor,
    int limit = 20,
  }) async {
    return (cards: <PiaCard>[], nextCursor: null, hasMore: false);
  }

  @override
  Future<PiaCard> getCard(String id) async {
    return PiaCard(
      id: id,
      title: 'Test',
      what: 'What',
      why: 'Why',
      details: 'Details',
      actions: const [],
      priority: PiaCardPriority.medium,
      status: PiaCardStatus.active,
      isPinned: false,
      createdAt: DateTime(2026),
    );
  }

  @override
  Future<String> executeAction({
    required String cardId,
    required String actionId,
    Map<String, dynamic> params = const {},
  }) async {
    return 'Action executed';
  }

  @override
  Future<PiaCard> updateCard(
    String id, {
    PiaCardStatus? status,
    bool? isPinned,
  }) async {
    return PiaCard(
      id: id,
      title: 'Test',
      what: 'What',
      why: 'Why',
      details: 'Details',
      actions: const [],
      priority: PiaCardPriority.medium,
      status: status ?? PiaCardStatus.active,
      isPinned: isPinned ?? false,
      createdAt: DateTime(2026),
    );
  }
}

void main() {
  group('PiaRepository', () {
    late PiaRepository repository;

    setUp(() {
      repository = _FakePiaRepository();
    });

    test('getCards returns record with cards list', () async {
      final result = await repository.getCards();

      expect(result.cards, isEmpty);
      expect(result.nextCursor, isNull);
      expect(result.hasMore, false);
    });

    test('getCard returns card by id', () async {
      final card = await repository.getCard('test-id');

      expect(card.id, 'test-id');
      expect(card.title, 'Test');
    });

    test('executeAction returns success message', () async {
      final message = await repository.executeAction(
        cardId: 'c-1',
        actionId: 'a-1',
      );

      expect(message, 'Action executed');
    });

    test('updateCard returns updated card', () async {
      final card = await repository.updateCard(
        'c-1',
        status: PiaCardStatus.dismissed,
        isPinned: true,
      );

      expect(card.id, 'c-1');
      expect(card.status, PiaCardStatus.dismissed);
      expect(card.isPinned, true);
    });
  });
}
