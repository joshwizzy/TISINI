import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';
import 'package:tisini/features/home/domain/entities/tisini_index.dart';
import 'package:tisini/features/home/domain/entities/wallet_balance.dart';
import 'package:tisini/features/home/domain/repositories/home_repository.dart';
import 'package:tisini/features/home/presentation/screens/home_screen.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();

    when(() => mockRepository.getWalletBalance()).thenAnswer(
      (_) async => const WalletBalance(balance: 1250000, currency: 'UGX'),
    );

    when(() => mockRepository.getDashboard()).thenAnswer(
      (_) async => TisiniIndex(
        score: 64,
        paymentConsistency: 72,
        complianceReadiness: 55,
        businessMomentum: 68,
        dataCompleteness: 61,
        changeReason: 'Consistent payments',
        changeAmount: 3,
        updatedAt: DateTime(2025, 6, 15),
      ),
    );

    when(
      () => mockRepository.getPiaGuidanceCard(),
    ).thenAnswer((_) async => null);

    when(() => mockRepository.getRecentTransactions()).thenAnswer(
      (_) async => [
        Transaction(
          id: 'tx-001',
          type: PaymentType.send,
          direction: TransactionDirection.outbound,
          status: PaymentStatus.completed,
          amount: 150000,
          currency: 'UGX',
          counterpartyName: 'Jane Nakamya',
          counterpartyIdentifier: '+256700100200',
          category: TransactionCategory.people,
          rail: PaymentRail.mobileMoney,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
    );
  });

  Widget buildWidget() {
    return ProviderScope(
      overrides: [homeRepositoryProvider.overrideWithValue(mockRepository)],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  group('HomeScreen', () {
    testWidgets('renders welcome header', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Welcome back'), findsOneWidget);
    });

    testWidgets('renders wallet balance', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Available balance'), findsOneWidget);
      expect(find.text('UGX 1,250,000'), findsOneWidget);
    });

    testWidgets('renders quick action buttons', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Send'), findsOneWidget);
      expect(find.text('Request'), findsOneWidget);
      expect(find.text('Scan'), findsOneWidget);
      expect(find.text('Top Up'), findsOneWidget);
    });

    testWidgets('renders tisini index mini', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('tisini index'), findsOneWidget);
      expect(find.text('Consistent payments'), findsOneWidget);
    });

    testWidgets('renders recent transactions', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Recent transactions'), findsOneWidget);
      expect(find.text('Jane Nakamya'), findsOneWidget);
    });

    testWidgets('renders see all link', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('See all'), findsOneWidget);
    });
  });
}
