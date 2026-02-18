import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/repositories/pay_repository.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_recipient_screen.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

class MockPayRepository extends Mock implements PayRepository {}

void main() {
  late MockPayRepository mockRepo;

  setUp(() {
    mockRepo = MockPayRepository();

    when(() => mockRepo.getRecentPayees()).thenAnswer(
      (_) async => const [
        Payee(
          id: 'p-001',
          name: 'Jane Nakamya',
          identifier: '+256700100200',
          rail: PaymentRail.mobileMoney,
          isPinned: false,
        ),
      ],
    );
  });

  Widget buildWidget() {
    return ProviderScope(
      overrides: [payRepositoryProvider.overrideWithValue(mockRepo)],
      child: const MaterialApp(home: SendRecipientScreen()),
    );
  }

  group('SendRecipientScreen', () {
    testWidgets('renders Send app bar', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Send'), findsOneWidget);
    });

    testWidgets('renders search field', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('renders recent payees after loading', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Recent'), findsOneWidget);
      expect(find.text('Jane Nakamya'), findsOneWidget);
    });
  });
}
