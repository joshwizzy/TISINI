import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String phoneNumber,
    required KycStatus kycStatus,
    String? fullName,
    String? businessName,
    String? email,
    KycAccountType? accountType,
  }) = _UserProfile;
}
