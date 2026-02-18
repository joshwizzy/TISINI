import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'funding_source.freezed.dart';

@freezed
class FundingSource with _$FundingSource {
  const factory FundingSource({
    required PaymentRail rail,
    required String label,
    required String identifier,
    required bool isAvailable,
  }) = _FundingSource;
}
