import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/shared/widgets/tisini_index_ring.dart';

void main() {
  Widget buildWidget({
    int score = 64,
    double size = 200,
    bool showLabel = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: TisiniIndexRing(score: score, size: size, showLabel: showLabel),
      ),
    );
  }

  group('TisiniIndexRing', () {
    testWidgets('renders score text after animation', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('64'), findsOneWidget);
    });

    testWidgets('shows label when showLabel is true', (tester) async {
      await tester.pumpWidget(buildWidget(showLabel: true));
      await tester.pumpAndSettle();

      expect(find.text('Operational view (not a rating)'), findsOneWidget);
    });

    testWidgets('hides label when showLabel is false', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Operational view (not a rating)'), findsNothing);
    });

    testWidgets('renders CustomPaint', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);
    });

    test('zoneColor returns red for 0-30', () {
      expect(TisiniIndexRing.zoneColor(0), AppColors.zoneRed);
      expect(TisiniIndexRing.zoneColor(15), AppColors.zoneRed);
      expect(TisiniIndexRing.zoneColor(30), AppColors.zoneRed);
    });

    test('zoneColor returns amber for 31-60', () {
      expect(TisiniIndexRing.zoneColor(31), AppColors.zoneAmber);
      expect(TisiniIndexRing.zoneColor(45), AppColors.zoneAmber);
      expect(TisiniIndexRing.zoneColor(60), AppColors.zoneAmber);
    });

    test('zoneColor returns green for 61-90', () {
      expect(TisiniIndexRing.zoneColor(61), AppColors.zoneGreen);
      expect(TisiniIndexRing.zoneColor(75), AppColors.zoneGreen);
      expect(TisiniIndexRing.zoneColor(90), AppColors.zoneGreen);
    });
  });
}
