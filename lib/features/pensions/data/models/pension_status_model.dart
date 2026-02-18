import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/domain/entities/pension_reminder.dart';
import 'package:tisini/features/pensions/domain/entities/pension_status.dart';

part 'pension_status_model.freezed.dart';
part 'pension_status_model.g.dart';

@freezed
class PensionReminderModel with _$PensionReminderModel {
  const factory PensionReminderModel({
    required String id,
    @JsonKey(name: 'reminder_date') required int reminderDate,
    @JsonKey(name: 'is_active') required bool isActive,
    double? amount,
  }) = _PensionReminderModel;

  const PensionReminderModel._();

  factory PensionReminderModel.fromJson(Map<String, dynamic> json) =>
      _$PensionReminderModelFromJson(json);

  PensionReminder toEntity() => PensionReminder(
    id: id,
    reminderDate: DateTime.fromMillisecondsSinceEpoch(reminderDate),
    isActive: isActive,
    amount: amount,
  );
}

@freezed
class PensionStatusModel with _$PensionStatusModel {
  const factory PensionStatusModel({
    @JsonKey(name: 'link_status') required String linkStatus,
    required String currency,
    @JsonKey(name: 'total_contributions') required int totalContributions,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'active_reminders')
    required List<PensionReminderModel> activeReminders,
    @JsonKey(name: 'nssf_number') String? nssfNumber,
    @JsonKey(name: 'next_due_date') int? nextDueDate,
    @JsonKey(name: 'next_due_amount') double? nextDueAmount,
  }) = _PensionStatusModel;

  const PensionStatusModel._();

  factory PensionStatusModel.fromJson(Map<String, dynamic> json) =>
      _$PensionStatusModelFromJson(json);

  PensionStatus toEntity() => PensionStatus(
    linkStatus: _parseLinkStatus(linkStatus),
    currency: currency,
    totalContributions: totalContributions,
    totalAmount: totalAmount,
    activeReminders: activeReminders.map((r) => r.toEntity()).toList(),
    nssfNumber: nssfNumber,
    nextDueDate: nextDueDate != null
        ? DateTime.fromMillisecondsSinceEpoch(nextDueDate!)
        : null,
    nextDueAmount: nextDueAmount,
  );

  static PensionLinkStatus _parseLinkStatus(String status) {
    return switch (status) {
      'linked' => PensionLinkStatus.linked,
      'not_linked' => PensionLinkStatus.notLinked,
      'verifying' => PensionLinkStatus.verifying,
      _ => PensionLinkStatus.notLinked,
    };
  }
}
