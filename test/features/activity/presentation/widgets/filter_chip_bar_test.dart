import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';
import 'package:tisini/features/activity/presentation/widgets/filter_chip_bar.dart';

void main() {
  Widget buildWidget({
    required TransactionFilters filters,
    VoidCallback? onClearAll,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: FilterChipBar(filters: filters, onClearAll: onClearAll ?? () {}),
      ),
    );
  }

  group('FilterChipBar', () {
    testWidgets('hides when filters empty', (tester) async {
      await tester.pumpWidget(buildWidget(filters: const TransactionFilters()));
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text('Clear all'), findsNothing);
    });

    testWidgets('shows direction chip', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          filters: const TransactionFilters(
            direction: TransactionDirection.inbound,
          ),
        ),
      );
      expect(find.text('Inbound'), findsOneWidget);
      expect(find.text('Clear all'), findsOneWidget);
    });

    testWidgets('shows category chip for single category', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          filters: const TransactionFilters(
            categories: [TransactionCategory.sales],
          ),
        ),
      );
      expect(find.text('Sales'), findsOneWidget);
    });

    testWidgets('shows count for multiple categories', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          filters: const TransactionFilters(
            categories: [TransactionCategory.sales, TransactionCategory.bills],
          ),
        ),
      );
      expect(find.text('2 categories'), findsOneWidget);
    });

    testWidgets('shows date range chip', (tester) async {
      await tester.pumpWidget(
        buildWidget(filters: TransactionFilters(startDate: DateTime(2026))),
      );
      expect(find.text('Date range'), findsOneWidget);
    });

    testWidgets('clear all fires callback', (tester) async {
      var cleared = false;
      await tester.pumpWidget(
        buildWidget(
          filters: const TransactionFilters(
            direction: TransactionDirection.outbound,
          ),
          onClearAll: () => cleared = true,
        ),
      );

      await tester.tap(find.text('Clear all'));
      expect(cleared, true);
    });
  });
}
