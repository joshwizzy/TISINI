import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/data/models/pia_card_model.dart';

abstract class PiaRemoteDatasource {
  Future<({List<PiaCardModel> cards, String? nextCursor, bool hasMore})>
  getCards({String? cursor, int limit = 20});

  Future<PiaCardModel> getCard(String id);

  Future<String> executeAction({
    required String cardId,
    required String actionId,
    Map<String, dynamic> params = const {},
  });

  Future<PiaCardModel> updateCard(
    String id, {
    PiaCardStatus? status,
    bool? isPinned,
  });
}
