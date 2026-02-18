import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

final paymentRoutesProvider = FutureProvider.autoDispose<List<PaymentRoute>>((
  ref,
) async {
  final repository = ref.watch(payRepositoryProvider);
  return repository.getPaymentRoutes();
});
