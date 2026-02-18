import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';

abstract class PayRepository {
  Future<List<Payee>> searchPayees({required String query});

  Future<List<Payee>> getRecentPayees();

  Future<List<Payee>> getPinnedPayees();

  Future<List<PaymentRoute>> getPaymentRoutes();

  Future<Payment> sendPayment({
    required String payeeId,
    required double amount,
    required String currency,
    required String rail,
    required String category,
    String? reference,
    String? note,
  });

  Future<PaymentReceipt> getReceipt({required String transactionId});
}
