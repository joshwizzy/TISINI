import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/entities/scan_state.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

class ScanController extends AutoDisposeAsyncNotifier<ScanState> {
  @override
  Future<ScanState> build() async {
    return const ScanState.scanning();
  }

  Future<void> onQrScanned(String qrData) async {
    try {
      final repo = ref.read(payRepositoryProvider);
      // Parse QR data to extract payee identifier
      final results = await repo.searchPayees(query: qrData);
      if (results.isNotEmpty) {
        state = AsyncData(
          ScanState.resolved(payee: results.first, qrData: qrData),
        );
      } else {
        state = const AsyncData(ScanState.failed(message: 'Payee not found'));
      }
    } on AppException catch (e) {
      state = AsyncData(ScanState.failed(message: e.message, code: e.code));
    } on Exception {
      state = const AsyncData(
        ScanState.failed(message: 'Failed to process QR code'),
      );
    }
  }

  void enterManually() {
    state = const AsyncData(ScanState.manualEntry());
  }

  Future<void> resolveManualPayee(String identifier) async {
    try {
      final repo = ref.read(payRepositoryProvider);
      final results = await repo.searchPayees(query: identifier);
      if (results.isNotEmpty) {
        state = AsyncData(ScanState.resolved(payee: results.first));
      } else {
        state = const AsyncData(ScanState.failed(message: 'Payee not found'));
      }
    } on AppException catch (e) {
      state = AsyncData(ScanState.failed(message: e.message, code: e.code));
    } on Exception {
      state = const AsyncData(
        ScanState.failed(message: 'Something went wrong'),
      );
    }
  }

  void setAmount({
    required Payee payee,
    required double amount,
    required String currency,
    required PaymentRoute route,
    required double fee,
    required double total,
    String? qrData,
  }) {
    state = AsyncData(
      ScanState.confirming(
        payee: payee,
        amount: amount,
        currency: currency,
        route: route,
        fee: fee,
        total: total,
        qrData: qrData,
      ),
    );
  }

  Future<void> confirmAndPay() async {
    final current = state.valueOrNull;
    if (current is! ScanStateConfirming) return;

    state = const AsyncData(ScanState.processing());

    try {
      final repo = ref.read(payRepositoryProvider);
      final payment = await repo.scanPay(
        payeeId: current.payee.id,
        amount: current.amount,
        currency: current.currency,
        rail: current.route.rail.name,
        qrData: current.qrData,
      );

      final receipt = await repo.getReceipt(transactionId: payment.id);

      state = AsyncData(ScanState.receipt(receipt: receipt));
    } on AppException catch (e) {
      state = AsyncData(ScanState.failed(message: e.message, code: e.code));
    } on Exception {
      state = const AsyncData(
        ScanState.failed(message: 'Something went wrong'),
      );
    }
  }

  void reset() {
    state = const AsyncData(ScanState.scanning());
  }
}

final scanControllerProvider =
    AutoDisposeAsyncNotifierProvider<ScanController, ScanState>(
      ScanController.new,
    );
