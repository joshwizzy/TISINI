import 'package:tisini/features/auth/domain/entities/auth_token.dart';
import 'package:tisini/features/auth/domain/entities/otp_response.dart';
import 'package:tisini/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<OtpResponse> requestOtp({required String phoneNumber});

  Future<({AuthToken token, User user, bool isNewUser})> verifyOtp({
    required String otpId,
    required String code,
  });

  Future<void> createPin({required String pin});

  Future<AuthToken> refreshToken({required String refreshToken});
}
