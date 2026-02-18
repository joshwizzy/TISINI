import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_request.freezed.dart';

@freezed
class OtpRequest with _$OtpRequest {
  const factory OtpRequest({required String phoneNumber}) = _OtpRequest;
}
