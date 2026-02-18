import 'package:tisini/features/pay/data/datasources/pay_remote_datasource.dart';
import 'package:tisini/features/pay/data/models/payee_model.dart';
import 'package:tisini/features/pay/data/models/payment_model.dart';
import 'package:tisini/features/pay/data/models/payment_receipt_model.dart';
import 'package:tisini/features/pay/data/models/payment_route_model.dart';

class MockPayRemoteDatasource implements PayRemoteDatasource {
  static const _delay = Duration(milliseconds: 300);

  static final _payees = [
    PayeeModel(
      id: 'p-001',
      name: 'Jane Nakamya',
      identifier: '+256700100200',
      rail: 'mobile_money',
      isPinned: false,
      lastPaidAt: DateTime.now()
          .subtract(const Duration(days: 2))
          .millisecondsSinceEpoch,
    ),
    const PayeeModel(
      id: 'p-002',
      name: 'ABC Supplies',
      identifier: 'BIZ-ABC-001',
      rail: 'bank',
      merchantRole: 'supplier',
      isPinned: true,
    ),
    PayeeModel(
      id: 'p-003',
      name: 'Kampala Traders Ltd',
      identifier: 'BIZ-KTL-001',
      rail: 'mobile_money',
      merchantRole: 'supplier',
      isPinned: true,
      lastPaidAt: DateTime.now()
          .subtract(const Duration(days: 5))
          .millisecondsSinceEpoch,
    ),
    PayeeModel(
      id: 'p-004',
      name: 'UMEME',
      identifier: 'BIZ-UMEME',
      rail: 'mobile_money',
      merchantRole: 'utilities',
      isPinned: false,
      lastPaidAt: DateTime.now()
          .subtract(const Duration(days: 3))
          .millisecondsSinceEpoch,
    ),
    const PayeeModel(
      id: 'p-005',
      name: 'Uganda Revenue Authority',
      identifier: 'GOV-URA',
      rail: 'bank',
      merchantRole: 'tax',
      isPinned: false,
    ),
    PayeeModel(
      id: 'p-006',
      name: 'Peter Okello',
      identifier: '+256770200300',
      rail: 'mobile_money',
      isPinned: false,
      lastPaidAt: DateTime.now()
          .subtract(const Duration(hours: 12))
          .millisecondsSinceEpoch,
    ),
  ];

  static const _routes = [
    PaymentRouteModel(
      rail: 'mobile_money',
      label: 'Mobile Money',
      isAvailable: true,
      fee: 500,
      estimatedTime: 'Instant',
    ),
    PaymentRouteModel(
      rail: 'bank',
      label: 'Bank Transfer',
      isAvailable: true,
      fee: 1500,
      estimatedTime: '1-2 hours',
    ),
    PaymentRouteModel(rail: 'wallet', label: 'Wallet', isAvailable: true),
    PaymentRouteModel(
      rail: 'card',
      label: 'Card',
      isAvailable: false,
      fee: 2500,
      estimatedTime: 'Instant',
    ),
  ];

  @override
  Future<List<PayeeModel>> searchPayees({required String query}) async {
    await Future<void>.delayed(_delay);
    final lowerQuery = query.toLowerCase();
    return _payees
        .where(
          (p) =>
              p.name.toLowerCase().contains(lowerQuery) ||
              p.identifier.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  @override
  Future<List<PayeeModel>> getRecentPayees() async {
    await Future<void>.delayed(_delay);
    return _payees.where((p) => p.lastPaidAt != null).toList()
      ..sort((a, b) => b.lastPaidAt!.compareTo(a.lastPaidAt!));
  }

  @override
  Future<List<PayeeModel>> getPinnedPayees() async {
    await Future<void>.delayed(_delay);
    return _payees.where((p) => p.isPinned).toList();
  }

  @override
  Future<List<PaymentRouteModel>> getPaymentRoutes() async {
    await Future<void>.delayed(_delay);
    return _routes;
  }

  @override
  Future<PaymentModel> sendPayment({
    required String payeeId,
    required double amount,
    required String currency,
    required String rail,
    required String category,
    String? reference,
    String? note,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    final payee = _payees.firstWhere((p) => p.id == payeeId);
    final fee = _routes.where((r) => r.rail == rail).firstOrNull?.fee ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    return PaymentModel(
      id: 'pay-${now.hashCode.abs()}',
      type: 'send',
      status: 'completed',
      direction: 'outbound',
      amount: amount,
      currency: currency,
      rail: rail,
      payee: payee,
      reference: reference,
      fee: fee,
      total: amount + fee,
      category: category,
      note: note,
      createdAt: now,
      completedAt: now,
    );
  }

  @override
  Future<PaymentReceiptModel> getReceipt({
    required String transactionId,
  }) async {
    await Future<void>.delayed(_delay);
    final now = DateTime.now().millisecondsSinceEpoch;

    return PaymentReceiptModel(
      transactionId: transactionId,
      receiptNumber: 'RCP-$transactionId',
      type: 'send',
      status: 'completed',
      amount: 150000,
      currency: 'UGX',
      fee: 500,
      total: 150500,
      rail: 'mobile_money',
      payeeName: 'Jane Nakamya',
      payeeIdentifier: '+256700100200',
      timestamp: now,
    );
  }
}
