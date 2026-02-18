import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

class SendController extends AutoDisposeAsyncNotifier<SendState> {
  @override
  Future<SendState> build() async {
    return const SendState.selectingRecipient();
  }

  void selectRecipient(Payee payee) {
    state = AsyncData(SendState.enteringDetails(payee: payee));
  }

  void enterDetails({
    required Payee payee,
    required TransactionCategory category,
    String? reference,
    String? note,
  }) {
    state = AsyncData(
      SendState.enteringAmount(
        payee: payee,
        category: category,
        reference: reference,
        note: note,
      ),
    );
  }

  void setAmount({
    required Payee payee,
    required TransactionCategory category,
    required double amount,
    required String currency,
    required PaymentRoute route,
    required double fee,
    required double total,
    String? reference,
    String? note,
  }) {
    state = AsyncData(
      SendState.confirming(
        payee: payee,
        category: category,
        amount: amount,
        currency: currency,
        route: route,
        fee: fee,
        total: total,
        reference: reference,
        note: note,
      ),
    );
  }

  Future<void> confirmAndSend() async {
    final current = state.valueOrNull;
    if (current is! SendStateConfirming) return;

    state = const AsyncData(SendState.processing());

    try {
      final repo = ref.read(payRepositoryProvider);
      final payment = await repo.sendPayment(
        payeeId: current.payee.id,
        amount: current.amount,
        currency: current.currency,
        rail: current.route.rail.name,
        category: current.category.name,
        reference: current.reference,
        note: current.note,
      );

      final receipt = await repo.getReceipt(transactionId: payment.id);

      state = AsyncData(SendState.receipt(receipt: receipt));
    } on AppException catch (e) {
      state = AsyncData(SendState.failed(message: e.message, code: e.code));
    } on Exception {
      state = const AsyncData(
        SendState.failed(message: 'Something went wrong'),
      );
    }
  }

  void reset() {
    state = const AsyncData(SendState.selectingRecipient());
  }
}

final sendControllerProvider =
    AutoDisposeAsyncNotifierProvider<SendController, SendState>(
      SendController.new,
    );
