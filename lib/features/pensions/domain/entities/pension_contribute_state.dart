import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';

part 'pension_contribute_state.freezed.dart';

@freezed
sealed class PensionContributeState with _$PensionContributeState {
  const factory PensionContributeState.enteringAmount({
    required String currency,
    double? nextDueAmount,
  }) = PensionContributeEnteringAmount;

  const factory PensionContributeState.confirming({
    required double amount,
    required String currency,
    required PaymentRoute route,
    required double fee,
    required double total,
    required String reference,
  }) = PensionContributeConfirming;

  const factory PensionContributeState.processing() =
      PensionContributeProcessing;

  const factory PensionContributeState.receipt({
    required PaymentReceipt receipt,
  }) = PensionContributeReceipt;

  const factory PensionContributeState.failed({
    required String message,
    String? code,
  }) = PensionContributeFailed;
}
