import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/core/providers/core_providers.dart';
import 'package:tisini/core/storage/secure_storage.dart';
import 'package:tisini/features/auth/domain/entities/auth_token.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/auth/domain/entities/login_state.dart';
import 'package:tisini/features/auth/domain/entities/otp_response.dart';
import 'package:tisini/features/auth/domain/entities/user.dart';
import 'package:tisini/features/auth/domain/repositories/auth_repository.dart';
import 'package:tisini/features/auth/providers/auth_repository_provider.dart';
import 'package:tisini/features/auth/providers/login_controller_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  group('LoginController', () {
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

    test('initial state is LoginState.initial', () async {
      final state = container.read(loginControllerProvider);
      // AsyncNotifier starts with AsyncLoading
      expect(state, isA<AsyncLoading<LoginState>>());
    });

    test('requestOtp rejects invalid phone number', () async {
      // Wait for build
      await container.read(loginControllerProvider.future);
      final notifier = container.read(loginControllerProvider.notifier);

      await notifier.requestOtp('12345');

      final state = container.read(loginControllerProvider);
      final value = state.valueOrNull;
      expect(value, isA<LoginStateError>());
      expect((value! as LoginStateError).code, 'INVALID_PHONE');
    });

    test('requestOtp succeeds with valid phone number', () async {
      when(() => mockRepo.requestOtp(phoneNumber: '+256700000000')).thenAnswer(
        (_) async => const OtpResponse(otpId: 'otp-123', expiresIn: 60),
      );

      await container.read(loginControllerProvider.future);
      final notifier = container.read(loginControllerProvider.notifier);

      await notifier.requestOtp('+256700000000');

      final state = container.read(loginControllerProvider);
      final value = state.valueOrNull;
      expect(value, isA<LoginStateOtpSent>());
      final otpSent = value! as LoginStateOtpSent;
      expect(otpSent.otpId, 'otp-123');
      expect(otpSent.phoneNumber, '+256700000000');
    });

    test('verifyOtp saves tokens on success', () async {
      when(() => mockRepo.requestOtp(phoneNumber: '+256700000000')).thenAnswer(
        (_) async => const OtpResponse(otpId: 'otp-123', expiresIn: 60),
      );

      final token = AuthToken(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiresAt: DateTime(2026, 3),
      );
      final user = User(
        id: 'user-1',
        phoneNumber: '+256700000000',
        kycStatus: KycStatus.notStarted,
        createdAt: DateTime(2026, 2, 18),
      );

      when(
        () => mockRepo.verifyOtp(otpId: 'otp-123', code: '123456'),
      ).thenAnswer((_) async => (token: token, user: user, isNewUser: true));

      when(
        () => mockStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      await container.read(loginControllerProvider.future);
      final notifier = container.read(loginControllerProvider.notifier);

      await notifier.requestOtp('+256700000000');
      await notifier.verifyOtp('123456');

      final state = container.read(loginControllerProvider);
      final value = state.valueOrNull;
      expect(value, isA<LoginStateVerified>());
      final verified = value! as LoginStateVerified;
      expect(verified.isNewUser, isTrue);

      verify(
        () => mockStorage.saveTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      ).called(1);
    });

    test('verifyOtp maps OTP_INVALID error code', () async {
      when(() => mockRepo.requestOtp(phoneNumber: '+256700000000')).thenAnswer(
        (_) async => const OtpResponse(otpId: 'otp-123', expiresIn: 60),
      );

      when(
        () => mockRepo.verifyOtp(otpId: 'otp-123', code: '000000'),
      ).thenThrow(
        const ServerException(
          'Invalid OTP',
          statusCode: 400,
          code: 'OTP_INVALID',
        ),
      );

      await container.read(loginControllerProvider.future);
      final notifier = container.read(loginControllerProvider.notifier);

      await notifier.requestOtp('+256700000000');
      await notifier.verifyOtp('000000');

      final state = container.read(loginControllerProvider);
      final value = state.valueOrNull;
      expect(value, isA<LoginStateError>());
      final error = value! as LoginStateError;
      expect(error.message, 'Incorrect code. Please try again.');
    });
  });
}
