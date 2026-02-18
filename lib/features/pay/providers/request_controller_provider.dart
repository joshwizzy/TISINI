import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/features/pay/domain/entities/request_state.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

class RequestController extends AutoDisposeAsyncNotifier<RequestState> {
  @override
  Future<RequestState> build() async {
    return const RequestState.creating();
  }

  Future<void> createRequest({
    required double amount,
    required String currency,
    String? note,
  }) async {
    state = const AsyncData(RequestState.processing());

    try {
      final repo = ref.read(payRepositoryProvider);
      final request = await repo.createPaymentRequest(
        amount: amount,
        currency: currency,
        note: note,
      );

      state = AsyncData(RequestState.sharing(request: request));
    } on AppException catch (e) {
      state = AsyncData(RequestState.failed(message: e.message, code: e.code));
    } on Exception {
      state = const AsyncData(
        RequestState.failed(message: 'Something went wrong'),
      );
    }
  }

  Future<void> viewStatus(String requestId) async {
    state = const AsyncData(RequestState.processing());

    try {
      final repo = ref.read(payRepositoryProvider);
      final request = await repo.getPaymentRequest(requestId: requestId);

      state = AsyncData(RequestState.tracking(request: request));
    } on AppException catch (e) {
      state = AsyncData(RequestState.failed(message: e.message, code: e.code));
    } on Exception {
      state = const AsyncData(
        RequestState.failed(message: 'Something went wrong'),
      );
    }
  }

  Future<void> refreshStatus(String requestId) async {
    try {
      final repo = ref.read(payRepositoryProvider);
      final request = await repo.getPaymentRequest(requestId: requestId);

      state = AsyncData(RequestState.tracking(request: request));
    } on Exception {
      // Keep current state on refresh failure
    }
  }

  void reset() {
    state = const AsyncData(RequestState.creating());
  }
}

final requestControllerProvider =
    AutoDisposeAsyncNotifierProvider<RequestController, RequestState>(
      RequestController.new,
    );
