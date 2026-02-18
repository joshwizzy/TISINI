import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'pinned_merchant.freezed.dart';

@freezed
class PinnedMerchant with _$PinnedMerchant {
  const factory PinnedMerchant({
    required String id,
    required String name,
    required String identifier,
    required MerchantRole role,
    required DateTime pinnedAt,
  }) = _PinnedMerchant;
}
