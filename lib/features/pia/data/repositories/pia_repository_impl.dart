import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/data/datasources/pia_remote_datasource.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';
import 'package:tisini/features/pia/domain/repositories/pia_repository.dart';

class PiaRepositoryImpl implements PiaRepository {
  PiaRepositoryImpl({required PiaRemoteDatasource datasource})
    : _datasource = datasource;

  final PiaRemoteDatasource _datasource;

  @override
  Future<({List<PiaCard> cards, String? nextCursor, bool hasMore})> getCards({
    String? cursor,
    int limit = 20,
  }) async {
    final result = await _datasource.getCards(cursor: cursor, limit: limit);
    return (
      cards: result.cards.map((m) => m.toEntity()).toList(),
      nextCursor: result.nextCursor,
      hasMore: result.hasMore,
    );
  }

  @override
  Future<PiaCard> getCard(String id) async {
    final model = await _datasource.getCard(id);
    return model.toEntity();
  }

  @override
  Future<String> executeAction({
    required String cardId,
    required String actionId,
    Map<String, dynamic> params = const {},
  }) async {
    return _datasource.executeAction(
      cardId: cardId,
      actionId: actionId,
      params: params,
    );
  }

  @override
  Future<PiaCard> updateCard(
    String id, {
    PiaCardStatus? status,
    bool? isPinned,
  }) async {
    final model = await _datasource.updateCard(
      id,
      status: status,
      isPinned: isPinned,
    );
    return model.toEntity();
  }
}
