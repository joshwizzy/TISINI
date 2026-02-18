import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/features/pay/data/datasources/pay_remote_datasource.dart';
import 'package:tisini/features/pay/data/models/payee_model.dart';
import 'package:tisini/features/pay/data/models/payment_model.dart';
import 'package:tisini/features/pay/data/models/payment_receipt_model.dart';
import 'package:tisini/features/pay/data/models/payment_route_model.dart';
import 'package:tisini/features/pay/data/repositories/pay_repository_impl.dart';

class MockPayRemoteDatasource extends Mock implements PayRemoteDatasource {}

void main() {
  late MockPayRemoteDatasource mockDatasource;
  late PayRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockPayRemoteDatasource();
    repository = PayRepositoryImpl(datasource: mockDatasource);
  });

  group('searchPayees', () {
    test('returns list of Payee', () async {
      when(() => mockDatasource.searchPayees(query: 'jane')).thenAnswer(
        (_) async => const [
          PayeeModel(
            id: 'p-001',
            name: 'Jane Nakamya',
            identifier: '+256700100200',
            rail: 'mobile_money',
            isPinned: false,
          ),
        ],
      );

      final result = await repository.searchPayees(query: 'jane');

      expect(result, hasLength(1));
      expect(result.first.name, 'Jane Nakamya');
      verify(() => mockDatasource.searchPayees(query: 'jane')).called(1);
    });
  });

  group('getRecentPayees', () {
    test('returns list of Payee', () async {
      when(() => mockDatasource.getRecentPayees()).thenAnswer(
        (_) async => [
          PayeeModel(
            id: 'p-001',
            name: 'Jane',
            identifier: '+256700100200',
            rail: 'mobile_money',
            isPinned: false,
            lastPaidAt: DateTime.now().millisecondsSinceEpoch,
          ),
        ],
      );

      final result = await repository.getRecentPayees();

      expect(result, hasLength(1));
    });
  });

  group('getPinnedPayees', () {
    test('returns list of pinned Payee', () async {
      when(() => mockDatasource.getPinnedPayees()).thenAnswer(
        (_) async => const [
          PayeeModel(
            id: 'p-002',
            name: 'ABC Supplies',
            identifier: 'BIZ-ABC',
            rail: 'bank',
            isPinned: true,
          ),
        ],
      );

      final result = await repository.getPinnedPayees();

      expect(result, hasLength(1));
      expect(result.first.isPinned, true);
    });
  });

  group('getPaymentRoutes', () {
    test('returns list of PaymentRoute', () async {
      when(() => mockDatasource.getPaymentRoutes()).thenAnswer(
        (_) async => const [
          PaymentRouteModel(
            rail: 'mobile_money',
            label: 'Mobile Money',
            isAvailable: true,
            fee: 500,
          ),
          PaymentRouteModel(
            rail: 'bank',
            label: 'Bank Transfer',
            isAvailable: true,
            fee: 1500,
          ),
        ],
      );

      final result = await repository.getPaymentRoutes();

      expect(result, hasLength(2));
      expect(result.first.label, 'Mobile Money');
    });
  });

  group('sendPayment', () {
    test('returns Payment', () async {
      when(
        () => mockDatasource.sendPayment(
          payeeId: 'p-001',
          amount: 150000,
          currency: 'UGX',
          rail: 'mobile_money',
          category: 'people',
        ),
      ).thenAnswer(
        (_) async => const PaymentModel(
          id: 'pay-001',
          type: 'send',
          status: 'completed',
          direction: 'outbound',
          amount: 150000,
          currency: 'UGX',
          rail: 'mobile_money',
          payee: PayeeModel(
            id: 'p-001',
            name: 'Jane',
            identifier: '+256700100200',
            rail: 'mobile_money',
            isPinned: false,
          ),
          fee: 500,
          total: 150500,
          category: 'people',
          createdAt: 1718400000000,
        ),
      );

      final result = await repository.sendPayment(
        payeeId: 'p-001',
        amount: 150000,
        currency: 'UGX',
        rail: 'mobile_money',
        category: 'people',
      );

      expect(result.id, 'pay-001');
      expect(result.total, 150500);
    });
  });

  group('getReceipt', () {
    test('returns PaymentReceipt', () async {
      when(() => mockDatasource.getReceipt(transactionId: 'tx-001')).thenAnswer(
        (_) async => const PaymentReceiptModel(
          transactionId: 'tx-001',
          receiptNumber: 'RCP-001',
          type: 'send',
          status: 'completed',
          amount: 150000,
          currency: 'UGX',
          fee: 500,
          total: 150500,
          rail: 'mobile_money',
          payeeName: 'Jane',
          payeeIdentifier: '+256700100200',
          timestamp: 1718400000000,
        ),
      );

      final result = await repository.getReceipt(transactionId: 'tx-001');

      expect(result.transactionId, 'tx-001');
      expect(result.receiptNumber, 'RCP-001');
    });
  });
}
