import 'package:tisini/features/pay/data/datasources/pay_remote_datasource.dart';
import 'package:tisini/features/pay/domain/entities/funding_source.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
import 'package:tisini/features/pay/domain/entities/payment_request.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/repositories/pay_repository.dart';

class PayRepositoryImpl implements PayRepository {
  PayRepositoryImpl({required PayRemoteDatasource datasource})
    : _datasource = datasource;

  final PayRemoteDatasource _datasource;

  @override
  Future<List<Payee>> searchPayees({required String query}) async {
    final models = await _datasource.searchPayees(query: query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Payee>> getRecentPayees() async {
    final models = await _datasource.getRecentPayees();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Payee>> getPinnedPayees() async {
    final models = await _datasource.getPinnedPayees();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PaymentRoute>> getPaymentRoutes() async {
    final models = await _datasource.getPaymentRoutes();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Payment> sendPayment({
    required String payeeId,
    required double amount,
    required String currency,
    required String rail,
    required String category,
    String? reference,
    String? note,
  }) async {
    final model = await _datasource.sendPayment(
      payeeId: payeeId,
      amount: amount,
      currency: currency,
      rail: rail,
      category: category,
      reference: reference,
      note: note,
    );
    return model.toEntity();
  }

  @override
  Future<PaymentReceipt> getReceipt({required String transactionId}) async {
    final model = await _datasource.getReceipt(transactionId: transactionId);
    return model.toEntity();
  }

  @override
  Future<PaymentRequest> createPaymentRequest({
    required double amount,
    required String currency,
    String? note,
  }) async {
    final model = await _datasource.createPaymentRequest(
      amount: amount,
      currency: currency,
      note: note,
    );
    return model.toEntity();
  }

  @override
  Future<PaymentRequest> getPaymentRequest({required String requestId}) async {
    final model = await _datasource.getPaymentRequest(requestId: requestId);
    return model.toEntity();
  }

  @override
  Future<Payment> scanPay({
    required String payeeId,
    required double amount,
    required String currency,
    required String rail,
    String? qrData,
  }) async {
    final model = await _datasource.scanPay(
      payeeId: payeeId,
      amount: amount,
      currency: currency,
      rail: rail,
      qrData: qrData,
    );
    return model.toEntity();
  }

  @override
  Future<List<Payee>> getBusinessPayees({required String category}) async {
    final models = await _datasource.getBusinessPayees(category: category);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Payment> sendBusinessPayment({
    required String payeeId,
    required double amount,
    required String currency,
    required String rail,
    required String category,
    String? reference,
  }) async {
    final model = await _datasource.sendBusinessPayment(
      payeeId: payeeId,
      amount: amount,
      currency: currency,
      rail: rail,
      category: category,
      reference: reference,
    );
    return model.toEntity();
  }

  @override
  Future<List<FundingSource>> getTopupSources() async {
    final models = await _datasource.getTopupSources();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Payment> submitTopup({
    required String sourceRail,
    required String sourceIdentifier,
    required double amount,
    required String currency,
  }) async {
    final model = await _datasource.submitTopup(
      sourceRail: sourceRail,
      sourceIdentifier: sourceIdentifier,
      amount: amount,
      currency: currency,
    );
    return model.toEntity();
  }
}
