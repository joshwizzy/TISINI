import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_result.dart';

part 'import_result_model.freezed.dart';
part 'import_result_model.g.dart';

@freezed
class ImportResultModel with _$ImportResultModel {
  const factory ImportResultModel({
    @JsonKey(name: 'job_id') required String jobId,
    @JsonKey(name: 'total_imported') required int totalImported,
    required int categorised,
    required int uncategorised,
    required List<String> errors,
  }) = _ImportResultModel;

  const ImportResultModel._();

  factory ImportResultModel.fromJson(Map<String, dynamic> json) =>
      _$ImportResultModelFromJson(json);

  ImportResult toEntity() => ImportResult(
    jobId: jobId,
    totalImported: totalImported,
    categorised: categorised,
    uncategorised: uncategorised,
    errors: errors,
  );
}
