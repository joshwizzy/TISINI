import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/data/datasources/mock_activity_remote_datasource.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';

void main() {
  late MockActivityRemoteDatasource datasource;

  setUp(() {
    datasource = MockActivityRemoteDatasource();
  });

  group('getTransactions', () {
    test('returns all transactions without filters', () async {
      final result = await datasource.getTransactions();
      expect(result.transactions, hasLength(18));
      expect(result.hasMore, false);
    });

    test('supports pagination with limit', () async {
      final page1 = await datasource.getTransactions(limit: 5);
      expect(page1.transactions, hasLength(5));
      expect(page1.hasMore, true);
      expect(page1.nextCursor, isNotNull);

      final page2 = await datasource.getTransactions(
        cursor: page1.nextCursor,
        limit: 5,
      );
      expect(page2.transactions, hasLength(5));
      expect(page2.hasMore, true);
    });

    test('filters by direction', () async {
      const filters = TransactionFilters(
        direction: TransactionDirection.inbound,
      );
      final result = await datasource.getTransactions(filters: filters);
      for (final t in result.transactions) {
        expect(t.direction, 'inbound');
      }
    });

    test('filters by categories', () async {
      const filters = TransactionFilters(
        categories: [TransactionCategory.sales],
      );
      final result = await datasource.getTransactions(filters: filters);
      for (final t in result.transactions) {
        expect(t.category, 'sales');
      }
      expect(result.transactions, isNotEmpty);
    });

    test('filters by date range', () async {
      final now = DateTime.now();
      final filters = TransactionFilters(
        startDate: now.subtract(const Duration(days: 7)),
        endDate: now,
      );
      final result = await datasource.getTransactions(filters: filters);
      expect(result.transactions.length, lessThan(18));
    });

    test('empty filters returns all', () async {
      const filters = TransactionFilters();
      final result = await datasource.getTransactions(filters: filters);
      expect(result.transactions, hasLength(18));
    });
  });

  group('getTransaction', () {
    test('returns transaction by id', () async {
      final txn = await datasource.getTransaction('txn-001');
      expect(txn.id, 'txn-001');
      expect(txn.counterpartyName, 'Nakawa Hardware');
    });

    test('throws for unknown id', () async {
      expect(() => datasource.getTransaction('unknown'), throwsException);
    });
  });

  group('updateCategory', () {
    test('updates category', () async {
      final updated = await datasource.updateCategory(
        transactionId: 'txn-001',
        category: TransactionCategory.bills,
      );
      expect(updated.category, 'bills');

      final fetched = await datasource.getTransaction('txn-001');
      expect(fetched.category, 'bills');
    });

    test('throws for unknown id', () async {
      expect(
        () => datasource.updateCategory(
          transactionId: 'unknown',
          category: TransactionCategory.sales,
        ),
        throwsException,
      );
    });
  });

  group('pinMerchant', () {
    test('sets merchant role', () async {
      final updated = await datasource.pinMerchant(
        transactionId: 'txn-002',
        role: MerchantRole.supplier,
      );
      expect(updated.merchantRole, 'supplier');
    });
  });

  group('updateNote', () {
    test('sets note', () async {
      final updated = await datasource.updateNote(
        transactionId: 'txn-001',
        note: 'Test note',
      );
      expect(updated.note, 'Test note');
    });
  });

  group('createExport', () {
    test('creates export job', () async {
      final job = await datasource.createExport(
        startDate: DateTime(2026),
        endDate: DateTime(2026, 2),
      );
      expect(job.id, startsWith('exp-'));
      expect(job.status, 'completed');
      expect(job.downloadUrl, isNotNull);
    });
  });

  group('getEstimatedExportRows', () {
    test('returns count of matching transactions', () async {
      final count = await datasource.getEstimatedExportRows(
        startDate: DateTime(2020),
        endDate: DateTime(2030),
      );
      expect(count, 18);
    });

    test('returns 0 for range with no transactions', () async {
      final count = await datasource.getEstimatedExportRows(
        startDate: DateTime(2020),
        endDate: DateTime(2020, 2),
      );
      expect(count, 0);
    });
  });
}
