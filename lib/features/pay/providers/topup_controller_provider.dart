import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';
import 'package:tisini/features/pay/domain/entities/topup_state.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

class TopupController extends AutoDisposeAsyncNotifier<TopupState> {
  @override
  Future<TopupState> build() async {
    return const TopupState.selectingSource();
  }

  void selectSource(FundingSource source) {
    state = AsyncData(TopupState.enteringAmount(source: source));
  }

  void setConfirming({
    required FundingSource source,
    required double amount,
    required String currency,
    required double fee,
    required double total,
  }) {
    state = AsyncData(
      TopupState.confirming(
        source: source,
        amount: amount,
        currency: currency,
        fee: fee,
        total: total,
      ),
    );
  }

  Future<void> confirmAndTopup() async {
    final current = state.valueOrNull;
    if (current is! TopupStateConfirming) return;

    state = const AsyncData(TopupState.processing());

    try {
      final repo = ref.read(payRepositoryProvider);
      final payment = await repo.submitTopup(
        sourceRail: current.source.rail.name,
        sourceIdentifier: current.source.identifier,
        amount: current.amount,
        currency: current.currency,
      );

      final receipt = await repo.getReceipt(transactionId: payment.id);

      state = AsyncData(TopupState.receipt(receipt: receipt));
    } on AppException catch (e) {
      state = AsyncData(TopupState.failed(message: e.message, code: e.code));
    } on Exception {
      state = const AsyncData(
        TopupState.failed(message: 'Something went wrong'),
      );
    }
  }

  void reset() {
    state = const AsyncData(TopupState.selectingSource());
  }
}

final topupControllerProvider =
    AutoDisposeAsyncNotifierProvider<TopupController, TopupState>(
      TopupController.new,
    );
