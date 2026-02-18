import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'pension_contribution.freezed.dart';

@freezed
class PensionContribution with _$PensionContribution {
  const factory PensionContribution({
    required String id,
    required double amount,
    required String currency,
    required ContributionStatus status,
    required PaymentRail rail,
    required DateTime createdAt,
    String? reference,
    DateTime? completedAt,
  }) = _PensionContribution;
}
