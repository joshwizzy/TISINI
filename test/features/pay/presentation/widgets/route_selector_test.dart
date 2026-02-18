import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pay/domain/entities/payment_route.dart';
import 'package:tisini/features/pay/domain/repositories/pay_repository.dart';
import 'package:tisini/features/pay/presentation/widgets/route_selector.dart';
import 'package:tisini/features/pay/providers/pay_repository_provider.dart';

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
        PaymentRoute(
          rail: PaymentRail.bank,
          label: 'Bank Transfer',
          isAvailable: true,
          fee: 1500,
        ),
      ],
    );
  });

  Widget buildWidget({
    PaymentRoute? selectedRoute,
    ValueChanged<PaymentRoute>? onRouteSelected,
  }) {
    return ProviderScope(
      overrides: [payRepositoryProvider.overrideWithValue(mockRepo)],
      child: MaterialApp(
        home: Scaffold(
          body: RouteSelector(
            selectedRoute: selectedRoute,
            onRouteSelected: onRouteSelected ?? (_) {},
          ),
        ),
      ),
    );
  }

  group('RouteSelector', () {
    testWidgets('renders route chips after loading', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Mobile Money'), findsOneWidget);
      expect(find.text('Bank Transfer'), findsOneWidget);
    });

    testWidgets('calls onRouteSelected when tapped', (tester) async {
      PaymentRoute? selected;
      await tester.pumpWidget(
        buildWidget(onRouteSelected: (route) => selected = route),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mobile Money'));

      expect(selected, isNotNull);
      expect(selected!.rail, PaymentRail.mobileMoney);
    });
  });
}
