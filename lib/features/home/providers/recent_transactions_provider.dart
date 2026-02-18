import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';

final recentTransactionsProvider = FutureProvider<List<Transaction>>((
  ref,
) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getRecentTransactions();
});
