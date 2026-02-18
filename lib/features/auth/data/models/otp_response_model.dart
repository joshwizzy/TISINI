import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/auth/domain/entities/otp_response.dart';

part 'otp_response_model.freezed.dart';
part 'otp_response_model.g.dart';

@freezed
class OtpResponseModel with _$OtpResponseModel {
  const factory OtpResponseModel({
    @JsonKey(name: 'otp_id') required String otpId,
    @JsonKey(name: 'expires_in') required int expiresIn,
  }) = _OtpResponseModel;

  const OtpResponseModel._();

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OtpResponseModelFromJson(json);

  OtpResponse toEntity() => OtpResponse(otpId: otpId, expiresIn: expiresIn);
}
