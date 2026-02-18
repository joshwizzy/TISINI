import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_state.freezed.dart';

@freezed
sealed class PinState with _$PinState {
  const factory PinState.initial() = PinStateInitial;
  const factory PinState.enteringPin() = PinStateEnteringPin;
  const factory PinState.confirmingPin({required String firstEntry}) =
      PinStateConfirmingPin;
  const factory PinState.creatingPin() = PinStateCreatingPin;
  const factory PinState.pinCreated() = PinStatePinCreated;
  const factory PinState.biometricPrompt() = PinStateBiometricPrompt;
  const factory PinState.error({required String message}) = PinStateError;
}
