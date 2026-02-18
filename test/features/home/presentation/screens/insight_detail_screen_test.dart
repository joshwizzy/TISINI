import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/home/domain/entities/attention_item.dart';
import 'package:tisini/features/home/domain/repositories/home_repository.dart';
import 'package:tisini/features/home/presentation/screens/insight_detail_screen.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();

    when(() => mockRepository.getInsight(id: 'att-001')).thenAnswer(
      (_) async => AttentionItem(
        id: 'att-001',
        title: 'Complete KYC',
        description: 'Verify your identity to unlock features',
        actionLabel: 'Start verification',
        actionRoute: '/kyc',
        priority: PiaCardPriority.high,
        createdAt: DateTime(2025, 6, 15),
      ),
    );
  });

  Widget buildWidget() {
    return ProviderScope(
      overrides: [homeRepositoryProvider.overrideWithValue(mockRepository)],
      child: const MaterialApp(home: InsightDetailScreen(insightId: 'att-001')),
    );
  }

  group('InsightDetailScreen', () {
    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Insight'), findsOneWidget);
    });

    testWidgets('renders insight title', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Complete KYC'), findsOneWidget);
    });

    testWidgets('renders description', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(
        find.text('Verify your identity to unlock features'),
        findsOneWidget,
      );
    });

    testWidgets('renders CTA button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Start verification'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
