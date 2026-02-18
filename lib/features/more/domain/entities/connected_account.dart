import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/core/enums.dart';

part 'connected_account.freezed.dart';

@freezed
class ConnectedAccount with _$ConnectedAccount {
  const factory ConnectedAccount({
    required String id,
    required AccountProvider provider,
    required String identifier,
    required DateTime connectedAt,
  }) = _ConnectedAccount;
}
