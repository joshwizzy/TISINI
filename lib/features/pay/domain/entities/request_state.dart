import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/pay/domain/entities/payment_request.dart';

part 'request_state.freezed.dart';

@freezed
sealed class RequestState with _$RequestState {
  const factory RequestState.creating() = RequestStateCreating;

  const factory RequestState.processing() = RequestStateProcessing;

  const factory RequestState.sharing({required PaymentRequest request}) =
      RequestStateSharing;

  const factory RequestState.tracking({required PaymentRequest request}) =
      RequestStateTracking;

  const factory RequestState.failed({required String message, String? code}) =
      RequestStateFailed;
}
