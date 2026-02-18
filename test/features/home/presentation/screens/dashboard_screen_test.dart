import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/home/domain/entities/badge.dart' as tisini;
import 'package:tisini/features/home/domain/entities/dashboard_indicator.dart';
import 'package:tisini/features/home/domain/entities/tisini_index.dart';
import 'package:tisini/features/home/domain/repositories/home_repository.dart';
import 'package:tisini/features/home/presentation/screens/dashboard_screen.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();

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

    when(() => mockRepository.getDashboardIndicators()).thenAnswer(
      (_) async => const [
        DashboardIndicator(
          type: IndicatorType.paymentConsistency,
          label: 'Payment Consistency',
          value: 72,
          maxValue: 90,
          percentage: 0.8,
        ),
      ],
    );

    when(() => mockRepository.getBadges()).thenAnswer(
      (_) async => const [
        tisini.Badge(
          id: 'badge-001',
          label: 'First Payment',
          iconName: 'rocket',
          isEarned: true,
        ),
      ],
    );

    when(
      () => mockRepository.getPiaGuidanceCard(),
    ).thenAnswer((_) async => null);
  });

  Widget buildWidget() {
    return ProviderScope(
      overrides: [homeRepositoryProvider.overrideWithValue(mockRepository)],
      child: const MaterialApp(home: DashboardScreen()),
    );
  }

  group('DashboardScreen', () {
    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('renders tisini index score', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('64'), findsOneWidget);
    });

    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Operational view (not a rating)'), findsOneWidget);
    });

    testWidgets('renders change indicator', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('Consistent payments'), findsOneWidget);
    });

    testWidgets('renders indicators section', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Indicators'), findsOneWidget);
      expect(find.text('Payment Consistency'), findsOneWidget);
      expect(find.text('72/90'), findsOneWidget);
    });

    testWidgets('renders badges section', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Badges'), findsOneWidget);
      expect(find.text('First Payment'), findsOneWidget);
    });
  });
}
