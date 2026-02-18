import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tisini/features/home/domain/entities/wallet_balance.dart';

part 'wallet_balance_model.freezed.dart';
part 'wallet_balance_model.g.dart';

@freezed
class WalletBalanceModel with _$WalletBalanceModel {
  const factory WalletBalanceModel({
    required double balance,
    required String currency,
  }) = _WalletBalanceModel;

  const WalletBalanceModel._();

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceModelFromJson(json);

  WalletBalance toEntity() =>
      WalletBalance(balance: balance, currency: currency);
}
