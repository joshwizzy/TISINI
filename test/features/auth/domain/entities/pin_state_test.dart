import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/auth/domain/entities/pin_state.dart';

void main() {
  group('PinState', () {
    test('initial creates correct state', () {
      const state = PinState.initial();
      expect(state, isA<PinStateInitial>());
    });

    test('enteringPin creates correct state', () {
      const state = PinState.enteringPin();
      expect(state, isA<PinStateEnteringPin>());
    });

    test('confirmingPin stores firstEntry', () {
      const state = PinState.confirmingPin(firstEntry: '1234');
      expect(state, isA<PinStateConfirmingPin>());
      const confirming = state as PinStateConfirmingPin;
      expect(confirming.firstEntry, '1234');
    });

    test('creatingPin creates correct state', () {
      const state = PinState.creatingPin();
      expect(state, isA<PinStateCreatingPin>());
    });

    test('pinCreated creates correct state', () {
      const state = PinState.pinCreated();
      expect(state, isA<PinStatePinCreated>());
    });

    test('biometricPrompt creates correct state', () {
      const state = PinState.biometricPrompt();
      expect(state, isA<PinStateBiometricPrompt>());
    });

    test('error stores message', () {
      const state = PinState.error(message: 'PINs do not match');
      expect(state, isA<PinStateError>());
      const error = state as PinStateError;
      expect(error.message, 'PINs do not match');
    });

    test('equality works for same values', () {
      const state1 = PinState.confirmingPin(firstEntry: '1234');
      const state2 = PinState.confirmingPin(firstEntry: '1234');
      expect(state1, equals(state2));
    });

    test('different firstEntry values are not equal', () {
      const state1 = PinState.confirmingPin(firstEntry: '1234');
      const state2 = PinState.confirmingPin(firstEntry: '5678');
      expect(state1, isNot(equals(state2)));
    });
  });
}
