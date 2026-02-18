import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/auth/domain/entities/auth_token.dart';

part 'auth_token_model.freezed.dart';
part 'auth_token_model.g.dart';

@freezed
class AuthTokenModel with _$AuthTokenModel {
  const factory AuthTokenModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_at') required int expiresAt,
  }) = _AuthTokenModel;

  const AuthTokenModel._();

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);

  AuthToken toEntity() => AuthToken(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresAt: DateTime.fromMillisecondsSinceEpoch(expiresAt),
  );
}
