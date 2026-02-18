import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/more/domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @JsonKey(name: 'kyc_status') required String kycStatus,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'business_name') String? businessName,
    String? email,
    @JsonKey(name: 'account_type') String? accountType,
  }) = _UserProfileModel;

  const UserProfileModel._();

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  UserProfile toEntity() => UserProfile(
    id: id,
    phoneNumber: phoneNumber,
    fullName: fullName,
    businessName: businessName,
    email: email,
    kycStatus: _parseKycStatus(kycStatus),
    accountType: accountType != null ? _parseAccountType(accountType!) : null,
  );

  static KycStatus _parseKycStatus(String status) {
    return switch (status) {
      'not_started' => KycStatus.notStarted,
      'in_progress' => KycStatus.inProgress,
      'pending' => KycStatus.pending,
      'approved' => KycStatus.approved,
      'failed' => KycStatus.failed,
      _ => KycStatus.notStarted,
    };
  }

  static KycAccountType _parseAccountType(String type) {
    return switch (type) {
      'business' => KycAccountType.business,
      'gig' => KycAccountType.gig,
      _ => KycAccountType.gig,
    };
  }
}
