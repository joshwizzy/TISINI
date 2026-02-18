import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'export_job.freezed.dart';

@freezed
class ExportJob with _$ExportJob {
  const factory ExportJob({
    required String id,
    required DateTime startDate,
    required DateTime endDate,
    required PaymentStatus status,
    required DateTime createdAt,
    String? downloadUrl,
  }) = _ExportJob;
}
