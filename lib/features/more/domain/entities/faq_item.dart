import 'package:freezed_annotation/freezed_annotation.dart';

part 'faq_item.freezed.dart';

@freezed
class FaqItem with _$FaqItem {
  const factory FaqItem({required String question, required String answer}) =
      _FaqItem;
}
