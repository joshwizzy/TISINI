import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_mapping.dart';

part 'import_mapping_model.freezed.dart';
part 'import_mapping_model.g.dart';

@freezed
class ImportMappingModel with _$ImportMappingModel {
  const factory ImportMappingModel({
    @JsonKey(name: 'date_column') required String dateColumn,
    @JsonKey(name: 'amount_column') required String amountColumn,
    @JsonKey(name: 'merchant_column') required String merchantColumn,
    @JsonKey(name: 'reference_column') required String referenceColumn,
  }) = _ImportMappingModel;

  const ImportMappingModel._();

  factory ImportMappingModel.fromJson(Map<String, dynamic> json) =>
      _$ImportMappingModelFromJson(json);

  factory ImportMappingModel.fromEntity(ImportMapping entity) =>
      ImportMappingModel(
        dateColumn: entity.dateColumn,
        amountColumn: entity.amountColumn,
        merchantColumn: entity.merchantColumn,
        referenceColumn: entity.referenceColumn,
      );

  ImportMapping toEntity() => ImportMapping(
    dateColumn: dateColumn,
    amountColumn: amountColumn,
    merchantColumn: merchantColumn,
    referenceColumn: referenceColumn,
  );
}
