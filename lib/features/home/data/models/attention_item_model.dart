import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/home/domain/entities/attention_item.dart';

part 'attention_item_model.freezed.dart';
part 'attention_item_model.g.dart';

@freezed
class AttentionItemModel with _$AttentionItemModel {
  const factory AttentionItemModel({
    required String id,
    required String title,
    required String description,
    @JsonKey(name: 'action_label') required String actionLabel,
    @JsonKey(name: 'action_route') required String actionRoute,
    required String priority,
    @JsonKey(name: 'created_at') required int createdAt,
  }) = _AttentionItemModel;

  const AttentionItemModel._();

  factory AttentionItemModel.fromJson(Map<String, dynamic> json) =>
      _$AttentionItemModelFromJson(json);

  AttentionItem toEntity() => AttentionItem(
    id: id,
    title: title,
    description: description,
    actionLabel: actionLabel,
    actionRoute: actionRoute,
    priority: _parsePriority(priority),
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
}
