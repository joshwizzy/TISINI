import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payee.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/entities/send_state.dart';
import 'package:tisini/features/pay/domain/repositories/pay_repository.dart';
import 'package:tisini/features/pay/presentation/screens/send/send_amount_screen.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';
import 'package:tisini/features/pay/providers/send_controller_provider.dart';

class MockPayRepository extends Mock implements PayRepository {}

void main() {
  late MockPayRepository mockRepo;

  setUp(() {
    mockRepo = MockPayRepository();

    when(() => mockRepo.getPaymentRoutes()).thenAnswer(
      (_) async => const [
        PaymentRoute(
          rail: PaymentRail.mobileMoney,
          label: 'Mobile Money',
          isAvailable: true,
          fee: 500,
        ),
      ],
    );
  });

  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        payRepositoryProvider.overrideWithValue(mockRepo),
        sendControllerProvider.overrideWith(_MockSendController.new),
      ],
      child: const MaterialApp(home: SendAmountScreen()),
    );
  }

  group('SendAmountScreen', () {
    testWidgets('renders Amount app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Amount'), findsOneWidget);
    });

    testWidgets('renders currency label', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('UGX'), findsOneWidget);
    });

    testWidgets('renders Continue button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('Continue button is disabled initially', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });
  });
}

class _MockSendController extends SendController {
  @override
  Future<SendState> build() async {
    return const SendState.enteringAmount(
      payee: Payee(
        id: 'p-001',
        name: 'Jane Nakamya',
        identifier: '+256700100200',
        rail: PaymentRail.mobileMoney,
        isPinned: false,
      ),
      category: TransactionCategory.uncategorised,
    );
  }
}
