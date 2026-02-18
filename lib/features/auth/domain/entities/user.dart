import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String phoneNumber,
    required KycStatus kycStatus,
    required DateTime createdAt,
    String? fullName,
    String? businessName,
  }) = _User;
}
