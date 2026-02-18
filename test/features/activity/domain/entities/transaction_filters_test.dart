import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';

void main() {
  group('TransactionFilters', () {
    test('default filters are empty', () {
      const filters = TransactionFilters();
      expect(filters.isEmpty, true);
      expect(filters.activeCount, 0);
    });

    test('direction makes it non-empty', () {
      const filters = TransactionFilters(
        direction: TransactionDirection.inbound,
      );
      expect(filters.isEmpty, false);
      expect(filters.activeCount, 1);
    });

    test('categories make it non-empty', () {
      const filters = TransactionFilters(
        categories: [TransactionCategory.sales],
      );
      expect(filters.isEmpty, false);
      expect(filters.activeCount, 1);
    });

    test('date range makes it non-empty', () {
      final filters = TransactionFilters(
        startDate: DateTime(2026),
        endDate: DateTime(2026, 2),
      );
      expect(filters.isEmpty, false);
      expect(filters.activeCount, 1);
    });

    test('activeCount counts distinct filter groups', () {
      final filters = TransactionFilters(
        direction: TransactionDirection.outbound,
        categories: const [
          TransactionCategory.bills,
          TransactionCategory.people,
        ],
        startDate: DateTime(2026),
      );
      expect(filters.activeCount, 3);
    });

    test('equality works', () {
      const a = TransactionFilters(direction: TransactionDirection.inbound);
      const b = TransactionFilters(direction: TransactionDirection.inbound);
      expect(a, equals(b));
    });

    test('copyWith works', () {
      const original = TransactionFilters();
      final updated = original.copyWith(
        direction: TransactionDirection.outbound,
      );
      expect(updated.direction, TransactionDirection.outbound);
      expect(updated.categories, isEmpty);
    });
  });
}
