import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/domain/entities/pinned_merchant.dart';

part 'pinned_merchant_model.freezed.dart';
part 'pinned_merchant_model.g.dart';

@freezed
class PinnedMerchantModel with _$PinnedMerchantModel {
  const factory PinnedMerchantModel({
    required String id,
    required String name,
    required String identifier,
    required String role,
    @JsonKey(name: 'pinned_at') required int pinnedAt,
  }) = _PinnedMerchantModel;

  const PinnedMerchantModel._();

  factory PinnedMerchantModel.fromJson(Map<String, dynamic> json) =>
      _$PinnedMerchantModelFromJson(json);

  PinnedMerchant toEntity() => PinnedMerchant(
    id: id,
    name: name,
    identifier: identifier,
    role: _parseRole(role),
    pinnedAt: DateTime.fromMillisecondsSinceEpoch(pinnedAt),
  );

  static MerchantRole _parseRole(String role) {
    return switch (role) {
      'supplier' => MerchantRole.supplier,
      'rent' => MerchantRole.rent,
      'wages' => MerchantRole.wages,
      'tax' => MerchantRole.tax,
      'pension' => MerchantRole.pension,
      'utilities' => MerchantRole.utilities,
      _ => MerchantRole.supplier,
    };
  }
}
