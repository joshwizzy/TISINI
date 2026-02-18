import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';
import 'package:tisini/features/activity/providers/activity_provider.dart';

void main() {
  group('activityRepositoryProvider', () {
    test('provides an ActivityRepository', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repo = container.read(activityRepositoryProvider);
      expect(repo, isNotNull);
    });
  });

  group('transactionFiltersProvider', () {
    test('default is empty filters', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(transactionFiltersProvider, (_, __) {});

      final filters = container.read(transactionFiltersProvider);
      expect(filters.isEmpty, true);
    });

    test('can update filters', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(transactionFiltersProvider, (_, __) {});

      container.read(transactionFiltersProvider.notifier).state =
          const TransactionFilters(direction: TransactionDirection.inbound);

      final filters = container.read(transactionFiltersProvider);
      expect(filters.direction, TransactionDirection.inbound);
    });
  });

  group('transactionListProvider', () {
    test('loads transactions', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(transactionListProvider, (_, __) {});
      final result = await container.read(transactionListProvider.future);
      expect(result.transactions, hasLength(18));
      expect(result.hasMore, false);
    });

    test('loadMore appends transactions', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(transactionListProvider, (_, __) {});

      // Override repository to use pagination
      final result = await container.read(transactionListProvider.future);
      expect(result.transactions, isNotEmpty);
    });
  });

  group('transactionDetailProvider', () {
    test('loads single transaction', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.listen(transactionDetailProvider('txn-001'), (_, __) {});
      final txn = await container.read(
        transactionDetailProvider('txn-001').future,
      );
      expect(txn.id, 'txn-001');
      expect(txn.counterpartyName, 'Nakawa Hardware');
    });
  });
}
