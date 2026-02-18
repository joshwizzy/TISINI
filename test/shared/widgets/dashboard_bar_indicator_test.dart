import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/shared/widgets/dashboard_bar_indicator.dart';

void main() {
  Widget buildWidget({
    String label = 'Payment Consistency',
    int value = 72,
    int maxValue = 90,
    Color color = AppColors.cyan,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: DashboardBarIndicator(
          label: label,
          value: value,
          maxValue: maxValue,
          color: color,
        ),
      ),
    );
  }

  group('DashboardBarIndicator', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Payment Consistency'), findsOneWidget);
    });

    testWidgets('renders value/maxValue text', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('72/90'), findsOneWidget);
    });

    testWidgets('renders with zero maxValue', (tester) async {
      await tester.pumpWidget(buildWidget(value: 0, maxValue: 0));

      expect(find.text('0/0'), findsOneWidget);
    });
  });
}
