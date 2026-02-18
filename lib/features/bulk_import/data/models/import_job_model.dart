import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_job.dart';

part 'import_job_model.freezed.dart';
part 'import_job_model.g.dart';

@freezed
class ImportJobModel with _$ImportJobModel {
  const factory ImportJobModel({
    required String id,
    required String source,
    required String status,
    @JsonKey(name: 'total_rows') required int totalRows,
    @JsonKey(name: 'processed_rows') required int processedRows,
    @JsonKey(name: 'success_rows') required int successRows,
    @JsonKey(name: 'error_rows') required int errorRows,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'completed_at') int? completedAt,
  }) = _ImportJobModel;

  const ImportJobModel._();

  factory ImportJobModel.fromJson(Map<String, dynamic> json) =>
      _$ImportJobModelFromJson(json);

  ImportJob toEntity() => ImportJob(
    id: id,
    source: _parseSource(source),
    status: _parseStatus(status),
    totalRows: totalRows,
    processedRows: processedRows,
    successRows: successRows,
    errorRows: errorRows,
    createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    completedAt: completedAt != null
        ? DateTime.fromMillisecondsSinceEpoch(completedAt!)
        : null,
  );

  static ImportSource _parseSource(String source) {
    return switch (source) {
      'bank' => ImportSource.bank,
      'mobile_money' => ImportSource.mobileMoney,
      _ => ImportSource.bank,
    };
  }

  static ImportJobStatus _parseStatus(String status) {
    return switch (status) {
      'uploading' => ImportJobStatus.uploading,
      'mapping' => ImportJobStatus.mapping,
      'processing' => ImportJobStatus.processing,
      'completed' => ImportJobStatus.completed,
      'failed' => ImportJobStatus.failed,
      _ => ImportJobStatus.uploading,
    };
  }
}
