import 'package:freezed_annotation/freezed_annotation.dart';

part 'pension_reminder.freezed.dart';

@freezed
class PensionReminder with _$PensionReminder {
  const factory PensionReminder({
    required String id,
    required DateTime reminderDate,
    required bool isActive,
    double? amount,
  }) = _PensionReminder;
}
