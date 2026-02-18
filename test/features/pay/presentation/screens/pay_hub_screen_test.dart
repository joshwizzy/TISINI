import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/repositories/pay_repository.dart';
import 'package:tisini/features/pay/presentation/screens/pay_hub_screen.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

class MockPayRepository extends Mock implements PayRepository {}

void main() {
  late MockPayRepository mockRepo;

  setUp(() {
    mockRepo = MockPayRepository();

    when(() => mockRepo.getRecentPayees()).thenAnswer(
      (_) async => [
        Payee(
          id: 'p-001',
          name: 'Jane Nakamya',
          identifier: '+256700100200',
          rail: PaymentRail.mobileMoney,
          isPinned: false,
          lastPaidAt: DateTime.now(),
        ),
      ],
    );

    when(() => mockRepo.getPinnedPayees()).thenAnswer(
      (_) async => const [
        Payee(
          id: 'p-002',
          name: 'ABC Supplies',
          identifier: 'BIZ-ABC',
          rail: PaymentRail.bank,
          isPinned: true,
        ),
      ],
    );
  });

  Widget buildWidget() {
    return ProviderScope(
      overrides: [payRepositoryProvider.overrideWithValue(mockRepo)],
      child: const MaterialApp(home: PayHubScreen()),
    );
  }

  group('PayHubScreen', () {
    testWidgets('renders Pay header', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Pay'), findsOneWidget);
    });

    testWidgets('renders search bar', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('renders quick actions', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Send'), findsOneWidget);
      expect(find.text('Request'), findsOneWidget);
      expect(find.text('Scan'), findsOneWidget);
    });

    testWidgets('renders categories section', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Suppliers'), findsOneWidget);
      expect(find.text('Bills'), findsOneWidget);
    });

    testWidgets('renders Wages and Statutory categories', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Wages'), findsOneWidget);
      expect(find.text('Statutory'), findsOneWidget);
    });
  });
}
