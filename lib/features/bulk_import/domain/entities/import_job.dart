import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'import_job.freezed.dart';

@freezed
class ImportJob with _$ImportJob {
  const factory ImportJob({
    required String id,
    required ImportSource source,
    required ImportJobStatus status,
    required int totalRows,
    required int processedRows,
    required int successRows,
    required int errorRows,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _ImportJob;
}
