import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribute_state.dart';
import 'package:tisini/features/pensions/providers/pension_provider.dart';

class PensionContributeController
    extends AutoDisposeAsyncNotifier<PensionContributeState> {
  @override
  Future<PensionContributeState> build() async {
    final status = await ref.watch(pensionStatusProvider.future);
    return PensionContributeState.enteringAmount(
      currency: status.currency,
      nextDueAmount: status.nextDueAmount,
    );
  }

  void setConfirming({
    required double amount,
    required String currency,
    required PaymentRoute route,
    required double fee,
    required double total,
    required String reference,
  }) {
    state = AsyncData(
      PensionContributeState.confirming(
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
    if (current is! PensionContributeConfirming) return;

    state = const AsyncData(PensionContributeState.processing());

    try {
      final pensionRepo = ref.read(pensionRepositoryProvider);
      final contribution = await pensionRepo.submitContribution(
        amount: current.amount,
        currency: current.currency,
        rail: current.route.rail.name,
        reference: current.reference,
      );

      final payRepo = ref.read(payRepositoryProvider);
      final receipt = await payRepo.getReceipt(transactionId: contribution.id);

      state = AsyncData(PensionContributeState.receipt(receipt: receipt));
    } on AppException catch (e) {
      state = AsyncData(
        PensionContributeState.failed(message: e.message, code: e.code),
      );
    } on Exception {
      state = const AsyncData(
        PensionContributeState.failed(message: 'Something went wrong'),
      );
    }
  }

  void reset() {
    state = const AsyncData(
      PensionContributeState.enteringAmount(currency: 'UGX'),
    );
  }
}

final pensionContributeControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      PensionContributeController,
      PensionContributeState
    >(PensionContributeController.new);
