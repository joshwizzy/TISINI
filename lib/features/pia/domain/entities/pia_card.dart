import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/domain/entities/pia_action.dart';

part 'pia_card.freezed.dart';

@freezed
class PiaCard with _$PiaCard {
  const factory PiaCard({
    required String id,
    required String title,
    required String what,
    required String why,
    required String details,
    required List<PiaAction> actions,
    required PiaCardPriority priority,
    required PiaCardStatus status,
    required bool isPinned,
    required DateTime createdAt,
  }) = _PiaCard;
}
