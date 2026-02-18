import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/home/domain/entities/wallet_balance.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';

final walletBalanceProvider = FutureProvider<WalletBalance>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getWalletBalance();
});
