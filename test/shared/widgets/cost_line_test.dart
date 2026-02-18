import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/shared/widgets/cost_line.dart';

void main() {
  Widget buildWidget({
    double amount = 150000,
    double fee = 500,
    double total = 150500,
    String currency = 'UGX',
  }) {
    return MaterialApp(
      home: Scaffold(
        body: CostLine(
          amount: amount,
          fee: fee,
          total: total,
          currency: currency,
        ),
      ),
    );
  }

  group('CostLine', () {
    testWidgets('renders amount', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('UGX 150,000'), findsOneWidget);
    });

    testWidgets('renders fee', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Fee'), findsOneWidget);
      expect(find.text('UGX 500'), findsOneWidget);
    });

    testWidgets('renders total', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Total'), findsOneWidget);
      expect(find.text('UGX 150,500'), findsOneWidget);
    });

    testWidgets('shows Free when fee is zero', (tester) async {
      await tester.pumpWidget(buildWidget(fee: 0, total: 150000));

      expect(find.text('Free'), findsOneWidget);
    });
  });
}
