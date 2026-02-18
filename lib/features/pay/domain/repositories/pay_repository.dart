import 'package:tisini/features/pay/domain/entities/funding_source.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_request.dart';
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

  Future<PaymentRequest> createPaymentRequest({
    required double amount,
    required String currency,
    String? note,
  });

  Future<PaymentRequest> getPaymentRequest({required String requestId});

  Future<Payment> scanPay({
    required String payeeId,
    required double amount,
    required String currency,
    required String rail,
    String? qrData,
  });

  Future<List<Payee>> getBusinessPayees({required String category});

  Future<Payment> sendBusinessPayment({
    required String payeeId,
    required double amount,
    required String currency,
    required String rail,
    required String category,
    String? reference,
  });

  Future<List<FundingSource>> getTopupSources();

  Future<Payment> submitTopup({
    required String sourceRail,
    required String sourceIdentifier,
    required double amount,
    required String currency,
  });
}
