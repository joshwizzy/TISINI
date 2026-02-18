import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/features/pay/data/datasources/pay_remote_datasource.dart';
import 'package:tisini/features/pay/data/models/funding_source_model.dart';
import 'package:tisini/features/pay/data/models/payee_model.dart';
import 'package:tisini/features/pay/data/models/payment_model.dart';
import 'package:tisini/features/pay/data/models/payment_receipt_model.dart';
import 'package:tisini/features/pay/data/models/payment_request_model.dart';
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

  group('createPaymentRequest', () {
    test('returns PaymentRequest', () async {
      when(
        () => mockDatasource.createPaymentRequest(
          amount: 50000,
          currency: 'UGX',
          note: 'Test',
        ),
      ).thenAnswer(
        (_) async => const PaymentRequestModel(
          id: 'req-001',
          amount: 50000,
          currency: 'UGX',
          shareLink: 'https://pay.tisini.co/r/req-001',
          status: 'pending',
          createdAt: 1718400000000,
          note: 'Test',
        ),
      );

      final result = await repository.createPaymentRequest(
        amount: 50000,
        currency: 'UGX',
        note: 'Test',
      );

      expect(result.id, 'req-001');
      expect(result.shareLink, 'https://pay.tisini.co/r/req-001');
    });
  });

  group('getPaymentRequest', () {
    test('returns PaymentRequest', () async {
      when(
        () => mockDatasource.getPaymentRequest(requestId: 'req-001'),
      ).thenAnswer(
        (_) async => const PaymentRequestModel(
          id: 'req-001',
          amount: 50000,
          currency: 'UGX',
          shareLink: 'https://pay.tisini.co/r/req-001',
          status: 'pending',
          createdAt: 1718400000000,
        ),
      );

      final result = await repository.getPaymentRequest(requestId: 'req-001');

      expect(result.id, 'req-001');
    });
  });

  group('scanPay', () {
    test('returns Payment', () async {
      when(
        () => mockDatasource.scanPay(
          payeeId: 'p-001',
          amount: 10000,
          currency: 'UGX',
          rail: 'mobile_money',
        ),
      ).thenAnswer(
        (_) async => const PaymentModel(
          id: 'pay-scan-001',
          type: 'scan_pay',
          status: 'completed',
          direction: 'outbound',
          amount: 10000,
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
          total: 10500,
          category: 'uncategorised',
          createdAt: 1718400000000,
        ),
      );

      final result = await repository.scanPay(
        payeeId: 'p-001',
        amount: 10000,
        currency: 'UGX',
        rail: 'mobile_money',
      );

      expect(result.id, 'pay-scan-001');
    });
  });

  group('getBusinessPayees', () {
    test('returns list of Payee by category', () async {
      when(
        () => mockDatasource.getBusinessPayees(category: 'Suppliers'),
      ).thenAnswer(
        (_) async => const [
          PayeeModel(
            id: 'p-002',
            name: 'ABC Supplies',
            identifier: 'BIZ-ABC',
            rail: 'bank',
            merchantRole: 'supplier',
            isPinned: true,
          ),
        ],
      );

      final result = await repository.getBusinessPayees(category: 'Suppliers');

      expect(result, hasLength(1));
      expect(result.first.name, 'ABC Supplies');
    });
  });

  group('sendBusinessPayment', () {
    test('returns Payment', () async {
      when(
        () => mockDatasource.sendBusinessPayment(
          payeeId: 'p-002',
          amount: 500000,
          currency: 'UGX',
          rail: 'bank',
          category: 'inventory',
        ),
      ).thenAnswer(
        (_) async => const PaymentModel(
          id: 'pay-biz-001',
          type: 'business_pay',
          status: 'completed',
          direction: 'outbound',
          amount: 500000,
          currency: 'UGX',
          rail: 'bank',
          payee: PayeeModel(
            id: 'p-002',
            name: 'ABC Supplies',
            identifier: 'BIZ-ABC',
            rail: 'bank',
            isPinned: true,
          ),
          fee: 1500,
          total: 501500,
          category: 'inventory',
          createdAt: 1718400000000,
        ),
      );

      final result = await repository.sendBusinessPayment(
        payeeId: 'p-002',
        amount: 500000,
        currency: 'UGX',
        rail: 'bank',
        category: 'inventory',
      );

      expect(result.id, 'pay-biz-001');
      expect(result.total, 501500);
    });
  });

  group('getTopupSources', () {
    test('returns list of FundingSource', () async {
      when(() => mockDatasource.getTopupSources()).thenAnswer(
        (_) async => const [
          FundingSourceModel(
            rail: 'mobile_money',
            label: 'MTN Mobile Money',
            identifier: '+256700100200',
            isAvailable: true,
          ),
          FundingSourceModel(
            rail: 'bank',
            label: 'Stanbic Bank',
            identifier: '0100123456',
            isAvailable: true,
          ),
        ],
      );

      final result = await repository.getTopupSources();

      expect(result, hasLength(2));
      expect(result.first.label, 'MTN Mobile Money');
    });
  });

  group('submitTopup', () {
    test('returns Payment', () async {
      when(
        () => mockDatasource.submitTopup(
          sourceRail: 'mobile_money',
          sourceIdentifier: '+256700100200',
          amount: 100000,
          currency: 'UGX',
        ),
      ).thenAnswer(
        (_) async => const PaymentModel(
          id: 'pay-topup-001',
          type: 'top_up',
          status: 'completed',
          direction: 'inbound',
          amount: 100000,
          currency: 'UGX',
          rail: 'mobile_money',
          payee: PayeeModel(
            id: 'wallet',
            name: 'Wallet Top Up',
            identifier: 'TISINI Wallet',
            rail: 'wallet',
            isPinned: false,
          ),
          fee: 500,
          total: 100500,
          category: 'uncategorised',
          createdAt: 1718400000000,
        ),
      );

      final result = await repository.submitTopup(
        sourceRail: 'mobile_money',
        sourceIdentifier: '+256700100200',
        amount: 100000,
        currency: 'UGX',
      );

      expect(result.id, 'pay-topup-001');
      expect(result.total, 100500);
    });
  });
}
