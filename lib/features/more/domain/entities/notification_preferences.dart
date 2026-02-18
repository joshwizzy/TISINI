import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences.freezed.dart';

@freezed
class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    required bool paymentReceived,
    required bool piaCards,
    required bool pensionReminders,
    required bool promotions,
  }) = _NotificationPreferences;
}
