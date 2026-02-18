import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/more/domain/entities/notification_preferences.dart';

part 'notification_preferences_model.freezed.dart';
part 'notification_preferences_model.g.dart';

@freezed
class NotificationPreferencesModel with _$NotificationPreferencesModel {
  const factory NotificationPreferencesModel({
    @JsonKey(name: 'payment_received') required bool paymentReceived,
    @JsonKey(name: 'pia_cards') required bool piaCards,
    @JsonKey(name: 'pension_reminders') required bool pensionReminders,
    required bool promotions,
  }) = _NotificationPreferencesModel;

  const NotificationPreferencesModel._();

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesModelFromJson(json);

  NotificationPreferences toEntity() => NotificationPreferences(
    paymentReceived: paymentReceived,
    piaCards: piaCards,
    pensionReminders: pensionReminders,
    promotions: promotions,
  );
}
