import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/auth/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @JsonKey(name: 'kyc_status') required String kycStatus,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'business_name') String? businessName,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  User toEntity() => User(
    id: id,
    phoneNumber: phoneNumber,
    fullName: fullName,
    businessName: businessName,
    kycStatus: _parseKycStatus(kycStatus),
    createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
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
}
