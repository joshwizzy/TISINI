import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';

part 'business_pay_state.freezed.dart';

@freezed
sealed class BusinessPayState with _$BusinessPayState {
  const factory BusinessPayState.selectingCategory() =
      BusinessPayStateSelectingCategory;

  const factory BusinessPayState.selectingPayee({required String category}) =
      BusinessPayStateSelectingPayee;

  const factory BusinessPayState.confirming({
    required Payee payee,
    required String category,
    required double amount,
    required String currency,
    required PaymentRoute route,
    required double fee,
    required double total,
    String? reference,
  }) = BusinessPayStateConfirming;

  const factory BusinessPayState.processing() = BusinessPayStateProcessing;

  const factory BusinessPayState.receipt({required PaymentReceipt receipt}) =
      BusinessPayStateReceipt;

  const factory BusinessPayState.failed({
    required String message,
    String? code,
  }) = BusinessPayStateFailed;
}
