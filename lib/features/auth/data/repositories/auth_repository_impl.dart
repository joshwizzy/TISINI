import 'package:tisini/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tisini/features/auth/domain/entities/auth_token.dart';
import 'package:tisini/features/auth/domain/entities/otp_response.dart';
import 'package:tisini/features/auth/domain/entities/user.dart';
import 'package:tisini/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDatasource datasource})
    : _datasource = datasource;

  final AuthRemoteDatasource _datasource;

  @override
  Future<OtpResponse> requestOtp({required String phoneNumber}) async {
    final model = await _datasource.requestOtp(phoneNumber: phoneNumber);
    return model.toEntity();
  }

  @override
  Future<({AuthToken token, User user, bool isNewUser})> verifyOtp({
    required String otpId,
    required String code,
  }) async {
    final result = await _datasource.verifyOtp(otpId: otpId, code: code);
    return (
      token: result.token.toEntity(),
      user: result.user.toEntity(),
      isNewUser: result.isNewUser,
    );
  }

  @override
  Future<void> createPin({required String pin}) async {
    await _datasource.createPin(pin: pin);
  }

  @override
  Future<AuthToken> refreshToken({required String refreshToken}) async {
    final model = await _datasource.refreshToken(refreshToken: refreshToken);
    return model.toEntity();
  }
}
