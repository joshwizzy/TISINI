import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/domain/entities/pension_reminder.dart';

part 'pension_status.freezed.dart';

@freezed
class PensionStatus with _$PensionStatus {
  const factory PensionStatus({
    required PensionLinkStatus linkStatus,
    required String currency,
    required int totalContributions,
    required double totalAmount,
    required List<PensionReminder> activeReminders,
    String? nssfNumber,
    DateTime? nextDueDate,
    double? nextDueAmount,
  }) = _PensionStatus;
}
