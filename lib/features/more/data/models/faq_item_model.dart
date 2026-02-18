import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/more/domain/entities/faq_item.dart';

part 'faq_item_model.freezed.dart';
part 'faq_item_model.g.dart';

@freezed
class FaqItemModel with _$FaqItemModel {
  const factory FaqItemModel({
    required String question,
    required String answer,
  }) = _FaqItemModel;

  const FaqItemModel._();

  factory FaqItemModel.fromJson(Map<String, dynamic> json) =>
      _$FaqItemModelFromJson(json);

  FaqItem toEntity() => FaqItem(question: question, answer: answer);
}
