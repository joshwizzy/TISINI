import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/features/pay/presentation/widgets/pay_category_tile.dart';

void main() {
  Widget buildWidget({VoidCallback? onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: PayCategoryTile(
          icon: PhosphorIconsBold.package,
          label: 'Suppliers',
          onTap: onTap,
        ),
      ),
    );
  }

  group('PayCategoryTile', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Suppliers'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('handles tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildWidget(onTap: () => tapped = true));

      await tester.tap(find.byType(GestureDetector));

      expect(tapped, isTrue);
    });
  });
}
