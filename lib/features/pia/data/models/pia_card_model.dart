import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pia/data/models/pia_action_model.dart';
import 'package:tisini/features/pia/domain/entities/pia_card.dart';

part 'pia_card_model.freezed.dart';
part 'pia_card_model.g.dart';

@freezed
class PiaCardModel with _$PiaCardModel {
  const factory PiaCardModel({
    required String id,
    required String title,
    required String what,
    required String why,
    required String details,
    required List<PiaActionModel> actions,
    required String priority,
    required String status,
    @JsonKey(name: 'is_pinned') required bool isPinned,
    @JsonKey(name: 'created_at') required int createdAt,
  }) = _PiaCardModel;

  const PiaCardModel._();

  factory PiaCardModel.fromJson(Map<String, dynamic> json) =>
      _$PiaCardModelFromJson(json);

  PiaCard toEntity() => PiaCard(
    id: id,
    title: title,
    what: what,
    why: why,
    details: details,
    actions: actions.map((a) => a.toEntity()).toList(),
    priority: _parsePriority(priority),
    status: _parseStatus(status),
    isPinned: isPinned,
    createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
  );

  static PiaCardPriority _parsePriority(String priority) {
    return switch (priority) {
      'high' => PiaCardPriority.high,
      'medium' => PiaCardPriority.medium,
      'low' => PiaCardPriority.low,
      _ => PiaCardPriority.medium,
    };
  }

  static PiaCardStatus _parseStatus(String status) {
    return switch (status) {
      'active' => PiaCardStatus.active,
      'dismissed' => PiaCardStatus.dismissed,
      'actioned' => PiaCardStatus.actioned,
      'expired' => PiaCardStatus.expired,
      _ => PiaCardStatus.active,
    };
  }
}
