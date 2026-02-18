import 'package:freezed_annotation/freezed_annotation.dart';

part 'tisini_index.freezed.dart';

@freezed
class TisiniIndex with _$TisiniIndex {
  const factory TisiniIndex({
    required int score,
    required int paymentConsistency,
    required int complianceReadiness,
    required int businessMomentum,
    required int dataCompleteness,
    required String changeReason,
    required double changeAmount,
    required DateTime updatedAt,
  }) = _TisiniIndex;
}
