import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

final receiptProvider = FutureProvider.autoDispose
    .family<PaymentReceipt, String>((ref, transactionId) async {
      final repository = ref.watch(payRepositoryProvider);
      return repository.getReceipt(transactionId: transactionId);
    });
