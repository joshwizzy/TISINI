import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/auth/domain/entities/auth_token.dart';
import 'package:tisini/features/auth/domain/entities/user.dart';

part 'login_state.freezed.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.initial() = LoginStateInitial;
  const factory LoginState.requestingOtp() = LoginStateRequestingOtp;
  const factory LoginState.otpSent({
    required String otpId,
    required int expiresIn,
    required String phoneNumber,
  }) = LoginStateOtpSent;
  const factory LoginState.verifyingOtp() = LoginStateVerifyingOtp;
  const factory LoginState.verified({
    required AuthToken token,
    required User user,
    required bool isNewUser,
  }) = LoginStateVerified;
  const factory LoginState.error({required String message, String? code}) =
      LoginStateError;
}
