import 'package:tisini/features/auth/data/models/auth_token_model.dart';
import 'package:tisini/features/auth/data/models/otp_response_model.dart';
import 'package:tisini/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<OtpResponseModel> requestOtp({required String phoneNumber});

  Future<({AuthTokenModel token, UserModel user, bool isNewUser})> verifyOtp({
    required String otpId,
    required String code,
  });

  Future<void> createPin({required String pin});

  Future<AuthTokenModel> refreshToken({required String refreshToken});
}
