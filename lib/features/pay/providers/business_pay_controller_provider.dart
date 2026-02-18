import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/features/pay/domain/entities/business_pay_state.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

class BusinessPayController extends AutoDisposeAsyncNotifier<BusinessPayState> {
  @override
  Future<BusinessPayState> build() async {
    return const BusinessPayState.selectingCategory();
  }

  void selectCategory(String category) {
    state = AsyncData(BusinessPayState.selectingPayee(category: category));
  }

  void setConfirming({
    required Payee payee,
    required String category,
    required double amount,
    required String currency,
    required PaymentRoute route,
    required double fee,
    required double total,
    String? reference,
  }) {
    state = AsyncData(
      BusinessPayState.confirming(
        payee: payee,
        category: category,
        amount: amount,
        currency: currency,
        route: route,
        fee: fee,
        total: total,
        reference: reference,
      ),
    );
  }

  Future<void> confirmAndPay() async {
    final current = state.valueOrNull;
    if (current is! BusinessPayStateConfirming) return;

    state = const AsyncData(BusinessPayState.processing());

    try {
      final repo = ref.read(payRepositoryProvider);
      final payment = await repo.sendBusinessPayment(
        payeeId: current.payee.id,
        amount: current.amount,
        currency: current.currency,
        rail: current.route.rail.name,
        category: current.category,
        reference: current.reference,
      );

      final receipt = await repo.getReceipt(transactionId: payment.id);

      state = AsyncData(BusinessPayState.receipt(receipt: receipt));
    } on AppException catch (e) {
      state = AsyncData(
        BusinessPayState.failed(message: e.message, code: e.code),
      );
    } on Exception {
      state = const AsyncData(
        BusinessPayState.failed(message: 'Something went wrong'),
      );
    }
  }

  void reset() {
    state = const AsyncData(BusinessPayState.selectingCategory());
  }
}

final businessPayControllerProvider =
    AutoDisposeAsyncNotifierProvider<BusinessPayController, BusinessPayState>(
      BusinessPayController.new,
    );
