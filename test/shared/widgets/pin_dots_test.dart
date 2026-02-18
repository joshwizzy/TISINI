import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/shared/widgets/pin_dots.dart';

void main() {
  Widget buildApp({int filledCount = 0, bool hasError = false}) {
    return MaterialApp(
      home: Scaffold(
        body: PinDots(filledCount: filledCount, hasError: hasError),
      ),
    );
  }

  group('PinDots', () {
    testWidgets('renders 4 dots', (tester) async {
      await tester.pumpWidget(buildApp());
      final containers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(containers.length, 4);
    });

    testWidgets('all dots empty when filledCount is 0', (tester) async {
      await tester.pumpWidget(buildApp());
      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();
      for (final container in containers) {
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, Colors.transparent);
      }
    });

    testWidgets('fills correct number of dots', (tester) async {
      await tester.pumpWidget(buildApp(filledCount: 2));
      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();

      // First 2 filled
      for (var i = 0; i < 2; i++) {
        final decoration = containers[i].decoration! as BoxDecoration;
        expect(decoration.color, AppColors.darkBlue);
      }
      // Last 2 empty
      for (var i = 2; i < 4; i++) {
        final decoration = containers[i].decoration! as BoxDecoration;
        expect(decoration.color, Colors.transparent);
      }
    });

    testWidgets('shows red dots when hasError is true', (tester) async {
      await tester.pumpWidget(buildApp(filledCount: 4, hasError: true));
      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();
      for (final container in containers) {
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, AppColors.red);
      }
    });
  });
}
