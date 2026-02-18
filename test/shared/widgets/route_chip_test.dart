import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/shared/widgets/route_chip.dart';

void main() {
  Widget buildWidget({
    PaymentRail rail = PaymentRail.mobileMoney,
    String label = 'Mobile Money',
    bool isSelected = false,
    VoidCallback? onTap,
    bool isAvailable = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: RouteChip(
          rail: rail,
          label: label,
          isSelected: isSelected,
          onTap: onTap,
          isAvailable: isAvailable,
        ),
      ),
    );
  }

  group('RouteChip', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Mobile Money'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('handles tap when available', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildWidget(onTap: () => tapped = true));

      await tester.tap(find.byType(GestureDetector).first);

      expect(tapped, isTrue);
    });

    testWidgets('does not handle tap when unavailable', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildWidget(onTap: () => tapped = true, isAvailable: false),
      );

      await tester.tap(find.byType(GestureDetector).first);

      expect(tapped, isFalse);
    });

    testWidgets('renders selected state', (tester) async {
      await tester.pumpWidget(buildWidget(isSelected: true));

      expect(find.text('Mobile Money'), findsOneWidget);
    });
  });
}
