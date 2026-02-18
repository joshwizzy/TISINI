import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'attention_item.freezed.dart';

@freezed
class AttentionItem with _$AttentionItem {
  const factory AttentionItem({
    required String id,
    required String title,
    required String description,
    required String actionLabel,
    required String actionRoute,
    required PiaCardPriority priority,
    required DateTime createdAt,
  }) = _AttentionItem;
}
