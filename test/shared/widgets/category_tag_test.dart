import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/shared/widgets/category_tag.dart';

void main() {
  Widget buildWidget({
    TransactionCategory category = TransactionCategory.people,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: CategoryTag(
          category: category,
          isSelected: isSelected,
          onTap: onTap,
        ),
      ),
    );
  }

  group('CategoryTag', () {
    testWidgets('renders category label', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('People'), findsOneWidget);
    });

    testWidgets('renders Sales label', (tester) async {
      await tester.pumpWidget(buildWidget(category: TransactionCategory.sales));

      expect(find.text('Sales'), findsOneWidget);
    });

    testWidgets('renders Bills label', (tester) async {
      await tester.pumpWidget(buildWidget(category: TransactionCategory.bills));

      expect(find.text('Bills'), findsOneWidget);
    });

    testWidgets('handles tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildWidget(onTap: () => tapped = true));

      await tester.tap(find.byType(GestureDetector));

      expect(tapped, isTrue);
    });

    testWidgets('renders selected state', (tester) async {
      await tester.pumpWidget(buildWidget(isSelected: true));

      expect(find.text('People'), findsOneWidget);
    });
  });
}
