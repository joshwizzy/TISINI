import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/providers/core_providers.dart';
import 'package:tisini/features/auth/domain/entities/pin_state.dart';
import 'package:tisini/features/auth/providers/auth_repository_provider.dart';

class PinController extends AutoDisposeAsyncNotifier<PinState> {
  @override
  Future<PinState> build() async {
    return const PinState.enteringPin();
  }

  Future<void> enterPin(String pin) async {
    if (pin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin)) {
      state = const AsyncData(PinState.error(message: 'PIN must be 4 digits'));
      return;
    }
    state = AsyncData(PinState.confirmingPin(firstEntry: pin));
  }

  Future<void> confirmPin(String pin) async {
    final currentState = state.valueOrNull;
    if (currentState is! PinStateConfirmingPin) return;

    if (pin != currentState.firstEntry) {
      state = const AsyncData(PinState.error(message: 'PINs do not match'));
      // Reset to entering after a brief delay
      await Future<void>.delayed(const Duration(milliseconds: 500));
      state = const AsyncData(PinState.enteringPin());
      return;
    }

    state = const AsyncData(PinState.creatingPin());

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.createPin(pin: pin);

      // Save PIN hash
      final hash = sha256.convert(utf8.encode(pin)).toString();
      final secureStorage = ref.read(secureStorageProvider);
      await secureStorage.savePinHash(hash);

      state = const AsyncData(PinState.pinCreated());
    } on Exception {
      state = const AsyncData(
        PinState.error(message: 'Failed to create PIN. Please try again.'),
      );
    }
  }

  void showBiometricPrompt() {
    state = const AsyncData(PinState.biometricPrompt());
  }

  Future<void> enableBiometric() async {
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.setBiometricEnabled(enabled: true);
  }

  Future<void> skipBiometric() async {
    // No action needed
  }
}

final pinControllerProvider =
    AutoDisposeAsyncNotifierProvider<PinController, PinState>(
      PinController.new,
    );
