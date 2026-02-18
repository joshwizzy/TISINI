import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/providers/core_providers.dart';
import 'package:tisini/core/storage/secure_storage.dart';
import 'package:tisini/features/auth/domain/entities/pin_state.dart';
import 'package:tisini/features/auth/domain/repositories/auth_repository.dart';
import 'package:tisini/features/auth/providers/auth_repository_provider.dart';
import 'package:tisini/features/auth/providers/pin_controller_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  group('PinController', () {
    late ProviderContainer container;
    late MockAuthRepository mockRepo;
    late MockSecureStorage mockStorage;

    setUp(() {
      mockRepo = MockAuthRepository();
      mockStorage = MockSecureStorage();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
          secureStorageProvider.overrideWithValue(mockStorage),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is enteringPin', () async {
      final state = await container.read(pinControllerProvider.future);
      expect(state, isA<PinStateEnteringPin>());
    });

    test('enterPin transitions to confirmingPin', () async {
      await container.read(pinControllerProvider.future);
      final notifier = container.read(pinControllerProvider.notifier);

      await notifier.enterPin('1234');

      final state = container.read(pinControllerProvider);
      final value = state.valueOrNull;
      expect(value, isA<PinStateConfirmingPin>());
      expect((value! as PinStateConfirmingPin).firstEntry, '1234');
    });

    test('enterPin rejects non-4-digit input', () async {
      await container.read(pinControllerProvider.future);
      final notifier = container.read(pinControllerProvider.notifier);

      await notifier.enterPin('12');

      final state = container.read(pinControllerProvider);
      final value = state.valueOrNull;
      expect(value, isA<PinStateError>());
      expect((value! as PinStateError).message, 'PIN must be 4 digits');
    });

    test('confirmPin creates PIN when entries match', () async {
      when(() => mockRepo.createPin(pin: '1234')).thenAnswer((_) async {});
      when(() => mockStorage.savePinHash(any())).thenAnswer((_) async {});

      await container.read(pinControllerProvider.future);
      final notifier = container.read(pinControllerProvider.notifier);

      await notifier.enterPin('1234');
      await notifier.confirmPin('1234');

      final state = container.read(pinControllerProvider);
      final value = state.valueOrNull;
      expect(value, isA<PinStatePinCreated>());
      verify(() => mockRepo.createPin(pin: '1234')).called(1);
      verify(() => mockStorage.savePinHash(any())).called(1);
    });

    test('confirmPin shows error when PINs do not match', () async {
      // Keep a listener active so auto-dispose doesn't kick in
      final states = <PinState?>[];
      container.listen(
        pinControllerProvider,
        (prev, next) => states.add(next.valueOrNull),
      );

      await container.read(pinControllerProvider.future);
      final notifier = container.read(pinControllerProvider.notifier);

      await notifier.enterPin('1234');
      await notifier.confirmPin('5678');

      // Should have seen error then reset to enteringPin
      expect(
        states,
        containsAll([isA<PinStateError>(), isA<PinStateEnteringPin>()]),
      );
    });

    test('enableBiometric saves to secure storage', () async {
      when(
        () => mockStorage.setBiometricEnabled(enabled: true),
      ).thenAnswer((_) async {});

      await container.read(pinControllerProvider.future);
      final notifier = container.read(pinControllerProvider.notifier);

      await notifier.enableBiometric();

      verify(() => mockStorage.setBiometricEnabled(enabled: true)).called(1);
    });
  });
}
