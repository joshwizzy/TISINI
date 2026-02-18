import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/domain/entities/connected_account.dart';

part 'connected_account_model.freezed.dart';
part 'connected_account_model.g.dart';

@freezed
class ConnectedAccountModel with _$ConnectedAccountModel {
  const factory ConnectedAccountModel({
    required String id,
    required String provider,
    required String identifier,
    @JsonKey(name: 'connected_at') required int connectedAt,
  }) = _ConnectedAccountModel;

  const ConnectedAccountModel._();

  factory ConnectedAccountModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectedAccountModelFromJson(json);

  ConnectedAccount toEntity() => ConnectedAccount(
    id: id,
    provider: _parseProvider(provider),
    identifier: identifier,
    connectedAt: DateTime.fromMillisecondsSinceEpoch(connectedAt),
  );

  static AccountProvider _parseProvider(String provider) {
    return switch (provider) {
      'mtn' => AccountProvider.mtn,
      'airtel' => AccountProvider.airtel,
      'stanbic' => AccountProvider.stanbic,
      'dfcu' => AccountProvider.dfcu,
      'equity' => AccountProvider.equity,
      'centenary' => AccountProvider.centenary,
      _ => AccountProvider.mtn,
    };
  }
}
