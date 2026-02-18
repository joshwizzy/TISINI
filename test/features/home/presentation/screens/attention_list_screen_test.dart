import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/home/domain/entities/attention_item.dart';
import 'package:tisini/features/home/domain/repositories/home_repository.dart';
import 'package:tisini/features/home/presentation/screens/attention_list_screen.dart';
import 'package:tisini/features/home/providers/home_repository_provider.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
  });

  Widget buildWidget() {
    return ProviderScope(
      overrides: [homeRepositoryProvider.overrideWithValue(mockRepository)],
      child: const MaterialApp(home: AttentionListScreen()),
    );
  }

  group('AttentionListScreen', () {
    testWidgets('renders app bar title', (tester) async {
      when(
        () => mockRepository.getAttentionItems(),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Attention'), findsOneWidget);
    });

    testWidgets('renders empty state when no items', (tester) async {
      when(
        () => mockRepository.getAttentionItems(),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('All caught up'), findsOneWidget);
    });

    testWidgets('renders attention items', (tester) async {
      when(() => mockRepository.getAttentionItems()).thenAnswer(
        (_) async => [
          AttentionItem(
            id: 'att-001',
            title: 'Complete KYC',
            description: 'Verify your identity',
            actionLabel: 'Start verification',
            actionRoute: '/kyc',
            priority: PiaCardPriority.high,
            createdAt: DateTime(2025, 6, 15),
          ),
        ],
      );

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Complete KYC'), findsOneWidget);
      expect(find.text('Verify your identity'), findsOneWidget);
      expect(find.text('Start verification'), findsOneWidget);
    });
  });
}
