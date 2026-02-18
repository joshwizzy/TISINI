import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

final businessPayeesProvider = FutureProvider.autoDispose
    .family<List<Payee>, String>((ref, category) async {
      final repository = ref.watch(payRepositoryProvider);
      return repository.getBusinessPayees(category: category);
    });
