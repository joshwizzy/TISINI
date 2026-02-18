import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_mapping.freezed.dart';

@freezed
class ImportMapping with _$ImportMapping {
  const factory ImportMapping({
    required String dateColumn,
    required String amountColumn,
    required String merchantColumn,
    required String referenceColumn,
  }) = _ImportMapping;
}
