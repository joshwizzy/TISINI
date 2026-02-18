import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_result.freezed.dart';

@freezed
class ImportResult with _$ImportResult {
  const factory ImportResult({
    required String jobId,
    required int totalImported,
    required int categorised,
    required int uncategorised,
    required List<String> errors,
  }) = _ImportResult;
}
