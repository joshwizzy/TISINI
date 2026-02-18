import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/features/activity/data/models/transaction_model.dart';
import 'package:tisini/features/home/data/datasources/home_remote_datasource.dart';
import 'package:tisini/features/home/data/models/attention_item_model.dart';
import 'package:tisini/features/home/data/models/badge_model.dart';
import 'package:tisini/features/home/data/models/dashboard_indicator_model.dart';
import 'package:tisini/features/home/data/models/tisini_index_model.dart';
import 'package:tisini/features/home/data/models/wallet_balance_model.dart';
import 'package:tisini/features/home/data/repositories/home_repository_impl.dart';
import 'package:tisini/features/pia/data/models/pia_card_model.dart';

class MockHomeRemoteDatasource extends Mock implements HomeRemoteDatasource {}

void main() {
  late MockHomeRemoteDatasource mockDatasource;
  late HomeRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockHomeRemoteDatasource();
    repository = HomeRepositoryImpl(datasource: mockDatasource);
  });

  group('getDashboard', () {
    test('returns TisiniIndex from datasource', () async {
      when(() => mockDatasource.getDashboard()).thenAnswer(
        (_) async => const TisiniIndexModel(
          score: 64,
          paymentConsistency: 72,
          complianceReadiness: 55,
          businessMomentum: 68,
          dataCompleteness: 61,
          changeReason: 'Reason',
          changeAmount: 3,
          updatedAt: 1718400000000,
        ),
      );

      final result = await repository.getDashboard();

      expect(result.score, 64);
      expect(result.paymentConsistency, 72);
      verify(() => mockDatasource.getDashboard()).called(1);
    });
  });

  group('getDashboardIndicators', () {
    test('returns list of DashboardIndicator', () async {
      when(() => mockDatasource.getDashboardIndicators()).thenAnswer(
        (_) async => const [
          DashboardIndicatorModel(
            type: 'payment_consistency',
            label: 'Payment',
            value: 72,
            maxValue: 90,
            percentage: 0.8,
          ),
        ],
      );

      final result = await repository.getDashboardIndicators();

      expect(result, hasLength(1));
      expect(result.first.value, 72);
    });
  });

  group('getAttentionItems', () {
    test('returns list of AttentionItem', () async {
      when(() => mockDatasource.getAttentionItems()).thenAnswer(
        (_) async => const [
          AttentionItemModel(
            id: 'att-001',
            title: 'KYC',
            description: 'Verify',
            actionLabel: 'Start',
            actionRoute: '/kyc',
            priority: 'high',
            createdAt: 1718400000000,
          ),
        ],
      );

      final result = await repository.getAttentionItems();

      expect(result, hasLength(1));
      expect(result.first.id, 'att-001');
    });
  });

  group('getInsight', () {
    test('returns single AttentionItem', () async {
      when(() => mockDatasource.getInsight(id: 'att-001')).thenAnswer(
        (_) async => const AttentionItemModel(
          id: 'att-001',
          title: 'KYC',
          description: 'Verify',
          actionLabel: 'Start',
          actionRoute: '/kyc',
          priority: 'high',
          createdAt: 1718400000000,
        ),
      );

      final result = await repository.getInsight(id: 'att-001');

      expect(result.id, 'att-001');
    });
  });

  group('getWalletBalance', () {
    test('returns WalletBalance', () async {
      when(() => mockDatasource.getWalletBalance()).thenAnswer(
        (_) async =>
            const WalletBalanceModel(balance: 1250000, currency: 'UGX'),
      );

      final result = await repository.getWalletBalance();

      expect(result.balance, 1250000);
      expect(result.currency, 'UGX');
    });
  });

  group('getRecentTransactions', () {
    test('returns list of Transaction', () async {
      when(() => mockDatasource.getRecentTransactions()).thenAnswer(
        (_) async => const [
          TransactionModel(
            id: 'tx-001',
            type: 'send',
            direction: 'outbound',
            status: 'completed',
            amount: 150000,
            currency: 'UGX',
            counterpartyName: 'Jane',
            counterpartyIdentifier: '+256700100200',
            category: 'people',
            rail: 'mobile_money',
            createdAt: 1718400000000,
          ),
        ],
      );

      final result = await repository.getRecentTransactions();

      expect(result, hasLength(1));
      expect(result.first.counterpartyName, 'Jane');
    });
  });

  group('getBadges', () {
    test('returns list of Badge', () async {
      when(() => mockDatasource.getBadges()).thenAnswer(
        (_) async => const [
          BadgeModel(
            id: 'badge-001',
            label: 'First Payment',
            iconName: 'rocket',
            isEarned: true,
          ),
        ],
      );

      final result = await repository.getBadges();

      expect(result, hasLength(1));
      expect(result.first.label, 'First Payment');
    });
  });

  group('getPiaGuidanceCard', () {
    test('returns PiaCard when available', () async {
      when(() => mockDatasource.getPiaGuidanceCard()).thenAnswer(
        (_) async => const PiaCardModel(
          id: 'pia-001',
          title: 'Guidance',
          what: 'What',
          why: 'Why',
          details: 'Details',
          actions: [],
          priority: 'medium',
          status: 'active',
          isPinned: false,
          createdAt: 1718400000000,
        ),
      );

      final result = await repository.getPiaGuidanceCard();

      expect(result, isNotNull);
      expect(result!.id, 'pia-001');
    });

    test('returns null when no guidance card', () async {
      when(
        () => mockDatasource.getPiaGuidanceCard(),
      ).thenAnswer((_) async => null);

      final result = await repository.getPiaGuidanceCard();

      expect(result, isNull);
    });
  });
}
