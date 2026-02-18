import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/activity/domain/entities/export_job.dart';

part 'export_state.freezed.dart';

@freezed
sealed class ExportState with _$ExportState {
  const factory ExportState.choosingPeriod() = ExportChoosingPeriod;

  const factory ExportState.confirming({
    required DateTime startDate,
    required DateTime endDate,
    required int estimatedRows,
  }) = ExportConfirming;

  const factory ExportState.exporting() = ExportExporting;

  const factory ExportState.success({required ExportJob job}) = ExportSuccess;

  const factory ExportState.failed({required String message}) = ExportFailed;
}
