import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/presentation/widgets/category_selector_sheet.dart';

void main() {
  group('CategorySelectorSheet', () {
    testWidgets('shows all categories', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategorySelectorSheet(
              selected: TransactionCategory.sales,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Select Category'), findsOneWidget);
      expect(find.text('Sales'), findsOneWidget);
      expect(find.text('Inventory'), findsOneWidget);
      expect(find.text('Bills'), findsOneWidget);
      expect(find.text('People'), findsOneWidget);
      expect(find.text('Compliance'), findsOneWidget);
      expect(find.text('Agency'), findsOneWidget);
      expect(find.text('Uncategorised'), findsOneWidget);
    });

    testWidgets('fires onSelected when category tapped', (tester) async {
      TransactionCategory? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategorySelectorSheet(
              selected: TransactionCategory.sales,
              onSelected: (cat) => selected = cat,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Bills'));
      expect(selected, TransactionCategory.bills);
    });
  });
}
