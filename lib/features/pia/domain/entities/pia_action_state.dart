import 'package:freezed_annotation/freezed_annotation.dart';

part 'pia_action_state.freezed.dart';

@freezed
sealed class PiaActionState with _$PiaActionState {
  const factory PiaActionState.idle() = PiaActionIdle;

  const factory PiaActionState.executing({
    required String cardId,
    required String actionId,
  }) = PiaActionExecuting;

  const factory PiaActionState.success({required String message}) =
      PiaActionSuccess;

  const factory PiaActionState.failed({required String message}) =
      PiaActionFailed;
}
