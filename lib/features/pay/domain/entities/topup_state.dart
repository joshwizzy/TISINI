import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';

part 'topup_state.freezed.dart';

@freezed
sealed class TopupState with _$TopupState {
  const factory TopupState.selectingSource() = TopupStateSelectingSource;

  const factory TopupState.enteringAmount({required FundingSource source}) =
      TopupStateEnteringAmount;

  const factory TopupState.confirming({
    required FundingSource source,
    required double amount,
    required String currency,
    required double fee,
    required double total,
  }) = TopupStateConfirming;

  const factory TopupState.processing() = TopupStateProcessing;

  const factory TopupState.receipt({required PaymentReceipt receipt}) =
      TopupStateReceipt;

  const factory TopupState.failed({required String message, String? code}) =
      TopupStateFailed;
}
