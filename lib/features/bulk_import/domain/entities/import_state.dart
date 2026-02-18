import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_mapping.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_result.dart';

part 'import_state.freezed.dart';

@freezed
sealed class ImportState with _$ImportState {
  const factory ImportState.choosingSource() = ImportChoosingSource;

  const factory ImportState.uploading({required ImportSource source}) =
      ImportUploading;

  const factory ImportState.mapping({
    required List<String> columns,
    required List<List<String>> sampleRows,
  }) = ImportMapping_;

  const factory ImportState.reviewing({
    required ImportMapping mapping,
    required int totalRows,
    required int autoCategorised,
    required int uncategorised,
  }) = ImportReviewing;

  const factory ImportState.processing({required String jobId}) =
      ImportProcessing;

  const factory ImportState.completed({required ImportResult result}) =
      ImportCompleted;

  const factory ImportState.failed({required String message}) = ImportFailed;
}
