import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/features/pay/presentation/widgets/amount_input.dart';

void main() {
  Widget buildWidget({
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AmountInput(
          controller: controller ?? TextEditingController(),
          currency: 'UGX',
          onChanged: onChanged,
        ),
      ),
    );
  }

  group('AmountInput', () {
    testWidgets('renders currency label', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('UGX'), findsOneWidget);
    });

    testWidgets('renders text field', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('calls onChanged when text changes', (tester) async {
      String? changedValue;
      await tester.pumpWidget(
        buildWidget(onChanged: (value) => changedValue = value),
      );

      await tester.enterText(find.byType(TextField), '150000');

      expect(changedValue, '150000');
    });

    testWidgets('only accepts digits', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(buildWidget(controller: controller));

      await tester.enterText(find.byType(TextField), '123abc');

      expect(controller.text, '123');
    });
  });
}
