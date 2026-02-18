import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pay/domain/entities/business_pay_state.dart';
import 'package:tisini/features/pay/presentation/screens/business/business_category_screen.dart';
import 'package:tisini/features/pay/providers/business_pay_controller_provider.dart';

void main() {
  Widget buildWidget() {
    return ProviderScope(
      overrides: [
        businessPayControllerProvider.overrideWith(
          _MockBusinessPayController.new,
        ),
      ],
      child: const MaterialApp(home: BusinessCategoryScreen()),
    );
  }

  group('BusinessCategoryScreen', () {
    testWidgets('renders Business Pay app bar', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Business Pay'), findsOneWidget);
    });

    testWidgets('renders Suppliers category', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Suppliers'), findsOneWidget);
    });

    testWidgets('renders Bills category', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Bills'), findsOneWidget);
    });

    testWidgets('renders Wages category', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Wages'), findsOneWidget);
    });

    testWidgets('renders Statutory category', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Statutory'), findsOneWidget);
    });
  });
}

class _MockBusinessPayController extends BusinessPayController {
  @override
  Future<BusinessPayState> build() async {
    return const BusinessPayState.selectingCategory();
  }
}
