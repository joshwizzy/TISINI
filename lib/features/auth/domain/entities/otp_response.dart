import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_response.freezed.dart';

@freezed
class OtpResponse with _$OtpResponse {
  const factory OtpResponse({required String otpId, required int expiresIn}) =
      _OtpResponse;
}
