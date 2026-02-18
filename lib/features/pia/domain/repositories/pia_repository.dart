import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';

abstract class PiaRepository {
  Future<({List<PiaCard> cards, String? nextCursor, bool hasMore})> getCards({
    String? cursor,
    int limit = 20,
  });

  Future<PiaCard> getCard(String id);

  Future<String> executeAction({
    required String cardId,
    required String actionId,
    Map<String, dynamic> params = const {},
  });

  Future<PiaCard> updateCard(
    String id, {
    PiaCardStatus? status,
    bool? isPinned,
  });
}
