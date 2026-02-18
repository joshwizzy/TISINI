import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/export_job.dart';

part 'export_job_model.freezed.dart';
part 'export_job_model.g.dart';

@freezed
class ExportJobModel with _$ExportJobModel {
  const factory ExportJobModel({
    required String id,
    @JsonKey(name: 'start_date') required int startDate,
    @JsonKey(name: 'end_date') required int endDate,
    required String status,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'download_url') String? downloadUrl,
  }) = _ExportJobModel;

  const ExportJobModel._();

  factory ExportJobModel.fromJson(Map<String, dynamic> json) =>
      _$ExportJobModelFromJson(json);

  ExportJob toEntity() => ExportJob(
    id: id,
    startDate: DateTime.fromMillisecondsSinceEpoch(startDate),
    endDate: DateTime.fromMillisecondsSinceEpoch(endDate),
    status: _parseStatus(status),
    createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    downloadUrl: downloadUrl,
  );

  static PaymentStatus _parseStatus(String status) {
    return switch (status) {
      'pending' => PaymentStatus.pending,
      'processing' => PaymentStatus.processing,
      'completed' => PaymentStatus.completed,
      'failed' => PaymentStatus.failed,
      'reversed' => PaymentStatus.reversed,
      _ => PaymentStatus.pending,
    };
  }
}
