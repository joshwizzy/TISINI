import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribution.dart';

part 'pension_contribution_model.freezed.dart';
part 'pension_contribution_model.g.dart';

@freezed
class PensionContributionModel with _$PensionContributionModel {
  const factory PensionContributionModel({
    required String id,
    required double amount,
    required String currency,
    required String status,
    required String rail,
    @JsonKey(name: 'created_at') required int createdAt,
    String? reference,
    @JsonKey(name: 'completed_at') int? completedAt,
  }) = _PensionContributionModel;

  const PensionContributionModel._();

  factory PensionContributionModel.fromJson(Map<String, dynamic> json) =>
      _$PensionContributionModelFromJson(json);

  PensionContribution toEntity() => PensionContribution(
    id: id,
    amount: amount,
    currency: currency,
    status: _parseStatus(status),
    rail: _parseRail(rail),
    createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    reference: reference,
    completedAt: completedAt != null
        ? DateTime.fromMillisecondsSinceEpoch(completedAt!)
        : null,
  );

  static ContributionStatus _parseStatus(String status) {
    return switch (status) {
      'pending' => ContributionStatus.pending,
      'completed' => ContributionStatus.completed,
      'failed' => ContributionStatus.failed,
      _ => ContributionStatus.pending,
    };
  }

  static PaymentRail _parseRail(String rail) {
    return switch (rail) {
      'bank' => PaymentRail.bank,
      'mobile_money' => PaymentRail.mobileMoney,
      'card' => PaymentRail.card,
      'wallet' => PaymentRail.wallet,
      _ => PaymentRail.mobileMoney,
    };
  }
}
