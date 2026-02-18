import 'package:tisini/core/errors/exceptions.dart';
import 'package:tisini/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tisini/features/auth/data/models/auth_token_model.dart';
import 'package:tisini/features/auth/data/models/otp_response_model.dart';
import 'package:tisini/features/auth/data/models/user_model.dart';

class MockAuthRemoteDatasource implements AuthRemoteDatasource {
  static const _validOtpCode = '123456';
  static const _delay = Duration(milliseconds: 500);

  @override
  Future<OtpResponseModel> requestOtp({required String phoneNumber}) async {
    await Future<void>.delayed(_delay);
    return const OtpResponseModel(otpId: 'mock-otp-id-001', expiresIn: 60);
  }

  @override
  Future<({AuthTokenModel token, UserModel user, bool isNewUser})> verifyOtp({
    required String otpId,
    required String code,
  }) async {
    await Future<void>.delayed(_delay);

    if (code != _validOtpCode) {
      throw const ServerException(
        'Invalid OTP code',
        statusCode: 400,
        code: 'OTP_INVALID',
      );
    }

    final now = DateTime.now();
    return (
      token: AuthTokenModel(
        accessToken: 'mock-access-token-${now.millisecondsSinceEpoch}',
        refreshToken: 'mock-refresh-token-${now.millisecondsSinceEpoch}',
        expiresAt: now.add(const Duration(hours: 1)).millisecondsSinceEpoch,
      ),
      user: UserModel(
        id: 'mock-user-001',
        phoneNumber: '+256700000000',
        kycStatus: 'not_started',
        createdAt: now.millisecondsSinceEpoch,
      ),
      isNewUser: true,
    );
  }

  @override
  Future<void> createPin({required String pin}) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<AuthTokenModel> refreshToken({required String refreshToken}) async {
    await Future<void>.delayed(_delay);

    final now = DateTime.now();
    return AuthTokenModel(
      accessToken:
          'mock-access-token-refreshed-'
          '${now.millisecondsSinceEpoch}',
      refreshToken:
          'mock-refresh-token-refreshed-'
          '${now.millisecondsSinceEpoch}',
      expiresAt: now.add(const Duration(hours: 1)).millisecondsSinceEpoch,
    );
  }
}
