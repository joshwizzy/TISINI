import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge.freezed.dart';

@freezed
class Badge with _$Badge {
  const factory Badge({
    required String id,
    required String label,
    required String iconName,
    required bool isEarned,
    DateTime? earnedAt,
  }) = _Badge;
}
