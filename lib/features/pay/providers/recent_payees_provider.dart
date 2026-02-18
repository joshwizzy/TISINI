import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

final recentPayeesProvider = FutureProvider.autoDispose<List<Payee>>((
  ref,
) async {
  final repository = ref.watch(payRepositoryProvider);
  return repository.getRecentPayees();
});
