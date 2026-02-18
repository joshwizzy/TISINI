import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tisini/features/auth/data/models/auth_token_model.dart';
import 'package:tisini/features/auth/data/models/otp_response_model.dart';
import 'package:tisini/features/auth/data/models/user_model.dart';
import 'package:tisini/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  late MockAuthRemoteDatasource mockDatasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockAuthRemoteDatasource();
    repository = AuthRepositoryImpl(datasource: mockDatasource);
  });

  group('requestOtp', () {
    test('returns OtpResponse entity from datasource', () async {
      when(
        () => mockDatasource.requestOtp(phoneNumber: '+256700000000'),
      ).thenAnswer(
        (_) async => const OtpResponseModel(otpId: 'otp-123', expiresIn: 60),
      );

      final result = await repository.requestOtp(phoneNumber: '+256700000000');
      expect(result.otpId, 'otp-123');
      expect(result.expiresIn, 60);
    });
  });

  group('verifyOtp', () {
    test('returns mapped entities on success', () async {
      when(
        () => mockDatasource.verifyOtp(otpId: 'otp-123', code: '123456'),
      ).thenAnswer(
        (_) async => (
          token: const AuthTokenModel(
            accessToken: 'access',
            refreshToken: 'refresh',
            expiresAt: 1740000000000,
          ),
          user: const UserModel(
            id: 'user-001',
            phoneNumber: '+256700000000',
            kycStatus: 'not_started',
            createdAt: 1740000000000,
          ),
          isNewUser: true,
        ),
      );

      final result = await repository.verifyOtp(
        otpId: 'otp-123',
        code: '123456',
      );
      expect(result.token.accessToken, 'access');
      expect(result.user.id, 'user-001');
      expect(result.user.kycStatus, KycStatus.notStarted);
      expect(result.isNewUser, isTrue);
    });

    test('rethrows ServerException from datasource', () async {
      when(
        () => mockDatasource.verifyOtp(otpId: 'otp-123', code: '000000'),
      ).thenThrow(
        const ServerException(
          'Invalid OTP',
          statusCode: 400,
          code: 'OTP_INVALID',
        ),
      );

      expect(
        () => repository.verifyOtp(otpId: 'otp-123', code: '000000'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('createPin', () {
    test('delegates to datasource', () async {
      when(
        () => mockDatasource.createPin(pin: '1234'),
      ).thenAnswer((_) async {});

      await repository.createPin(pin: '1234');
      verify(() => mockDatasource.createPin(pin: '1234')).called(1);
    });
  });

  group('refreshToken', () {
    test('returns mapped AuthToken entity', () async {
      when(
        () => mockDatasource.refreshToken(refreshToken: 'refresh-old'),
      ).thenAnswer(
        (_) async => const AuthTokenModel(
          accessToken: 'access-new',
          refreshToken: 'refresh-new',
          expiresAt: 1740000000000,
        ),
      );

      final result = await repository.refreshToken(refreshToken: 'refresh-old');
      expect(result.accessToken, 'access-new');
      expect(result.refreshToken, 'refresh-new');
    });
  });
}
