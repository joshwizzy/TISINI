import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';

part 'send_state.freezed.dart';

@freezed
sealed class SendState with _$SendState {
  const factory SendState.selectingRecipient() = SendStateSelectingRecipient;

  const factory SendState.enteringDetails({required Payee payee}) =
      SendStateEnteringDetails;

  const factory SendState.enteringAmount({
    required Payee payee,
    required TransactionCategory category,
    String? reference,
    String? note,
  }) = SendStateEnteringAmount;

  const factory SendState.confirming({
    required Payee payee,
    required TransactionCategory category,
    required double amount,
    required String currency,
    required PaymentRoute route,
    required double fee,
    required double total,
    String? reference,
    String? note,
  }) = SendStateConfirming;

  const factory SendState.processing() = SendStateProcessing;

  const factory SendState.receipt({required PaymentReceipt receipt}) =
      SendStateReceipt;

  const factory SendState.failed({required String message, String? code}) =
      SendStateFailed;
}
