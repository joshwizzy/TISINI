import 'package:tisini/features/pay/data/models/funding_source_model.dart';
import 'package:tisini/features/pay/data/models/payee_model.dart';
import 'package:tisini/features/pay/data/models/payment_model.dart';
import 'package:tisini/features/pay/data/models/payment_receipt_model.dart';
import 'package:tisini/features/pay/data/models/payment_request_model.dart';
import 'package:tisini/features/pay/data/models/payment_route_model.dart';

abstract class PayRemoteDatasource {
  Future<List<PayeeModel>> searchPayees({required String query});

  Future<List<PayeeModel>> getRecentPayees();

  Future<List<PayeeModel>> getPinnedPayees();

  Future<List<PaymentRouteModel>> getPaymentRoutes();

  Future<PaymentModel> sendPayment({
    required String payeeId,
    required double amount,
    required String currency,
    required String rail,
    required String category,
    String? reference,
    String? note,
  });

  Future<PaymentReceiptModel> getReceipt({required String transactionId});

  Future<PaymentRequestModel> createPaymentRequest({
    required double amount,
    required String currency,
    String? note,
  });

  Future<PaymentRequestModel> getPaymentRequest({required String requestId});

  Future<PaymentModel> scanPay({
    required String payeeId,
    required double amount,
    required String currency,
    required String rail,
    String? qrData,
  });

  Future<List<PayeeModel>> getBusinessPayees({required String category});

  Future<PaymentModel> sendBusinessPayment({
    required String payeeId,
    required double amount,
    required String currency,
    required String rail,
    required String category,
    String? reference,
  });

  Future<List<FundingSourceModel>> getTopupSources();

  Future<PaymentModel> submitTopup({
    required String sourceRail,
    required String sourceIdentifier,
    required double amount,
    required String currency,
  });
}
