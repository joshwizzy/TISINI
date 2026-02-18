import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/home/domain/entities/badge.dart';

part 'badge_model.freezed.dart';
part 'badge_model.g.dart';

@freezed
class BadgeModel with _$BadgeModel {
  const factory BadgeModel({
    required String id,
    required String label,
    @JsonKey(name: 'icon_name') required String iconName,
    @JsonKey(name: 'is_earned') required bool isEarned,
    @JsonKey(name: 'earned_at') int? earnedAt,
  }) = _BadgeModel;

  const BadgeModel._();

  factory BadgeModel.fromJson(Map<String, dynamic> json) =>
      _$BadgeModelFromJson(json);

  Badge toEntity() => Badge(
    id: id,
    label: label,
    iconName: iconName,
    isEarned: isEarned,
    earnedAt: earnedAt != null
        ? DateTime.fromMillisecondsSinceEpoch(earnedAt!)
        : null,
  );
}
