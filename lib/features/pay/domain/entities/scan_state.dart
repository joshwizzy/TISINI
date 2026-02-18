import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';

part 'scan_state.freezed.dart';

@freezed
sealed class ScanState with _$ScanState {
  const factory ScanState.scanning() = ScanStateScanning;

  const factory ScanState.manualEntry() = ScanStateManualEntry;

  const factory ScanState.resolved({
    required Payee payee,
    double? amount,
    String? qrData,
  }) = ScanStateResolved;

  const factory ScanState.confirming({
    required Payee payee,
    required double amount,
    required String currency,
    required PaymentRoute route,
    required double fee,
    required double total,
    String? qrData,
  }) = ScanStateConfirming;

  const factory ScanState.processing() = ScanStateProcessing;

  const factory ScanState.receipt({required PaymentReceipt receipt}) =
      ScanStateReceipt;

  const factory ScanState.failed({required String message, String? code}) =
      ScanStateFailed;
}
