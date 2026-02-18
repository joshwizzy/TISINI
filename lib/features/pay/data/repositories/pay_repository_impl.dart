import 'package:tisini/features/pay/data/datasources/pay_remote_datasource.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment.dart';
import 'package:tisini/features/pay/domain/entities/payment_receipt.dart';
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
}
