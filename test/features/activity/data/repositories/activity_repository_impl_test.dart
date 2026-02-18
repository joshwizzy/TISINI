import 'package:flutter_test/flutter_test.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/data/datasources/mock_activity_remote_datasource.dart';
import 'package:tisini/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';

void main() {
  late ActivityRepositoryImpl repository;

  setUp(() {
    repository = ActivityRepositoryImpl(
      datasource: MockActivityRemoteDatasource(),
    );
  });

  group('getTransactions', () {
    test('returns domain entities', () async {
      final result = await repository.getTransactions();
      expect(result.transactions, isNotEmpty);
      expect(result.transactions.first, isA<Transaction>());
      expect(result.transactions.first.createdAt, isA<DateTime>());
    });

    test('supports filtering', () async {
      const filters = TransactionFilters(
        direction: TransactionDirection.inbound,
      );
      final result = await repository.getTransactions(filters: filters);
      for (final t in result.transactions) {
        expect(t.direction, TransactionDirection.inbound);
      }
    });

    test('supports pagination', () async {
      final page1 = await repository.getTransactions(limit: 5);
      expect(page1.transactions, hasLength(5));
      expect(page1.hasMore, true);

      final page2 = await repository.getTransactions(
        cursor: page1.nextCursor,
        limit: 5,
      );
      expect(page2.transactions, hasLength(5));
    });
  });

  group('getTransaction', () {
    test('returns domain entity by id', () async {
      final txn = await repository.getTransaction('txn-001');
      expect(txn.id, 'txn-001');
      expect(txn.counterpartyName, 'Nakawa Hardware');
      expect(txn.category, TransactionCategory.inventory);
    });
  });

  group('updateCategory', () {
    test('updates and returns domain entity', () async {
      final updated = await repository.updateCategory(
        transactionId: 'txn-001',
        category: TransactionCategory.bills,
      );
      expect(updated.category, TransactionCategory.bills);
    });
  });

  group('pinMerchant', () {
    test('updates and returns domain entity', () async {
      final updated = await repository.pinMerchant(
        transactionId: 'txn-002',
        role: MerchantRole.supplier,
      );
      expect(updated.merchantRole, MerchantRole.supplier);
    });
  });

  group('updateNote', () {
    test('updates and returns domain entity', () async {
      final updated = await repository.updateNote(
        transactionId: 'txn-001',
        note: 'Test note',
      );
      expect(updated.note, 'Test note');
    });
  });

  group('createExport', () {
    test('returns domain entity', () async {
      final job = await repository.createExport(
        startDate: DateTime(2026),
        endDate: DateTime(2026, 2),
      );
      expect(job.id, startsWith('exp-'));
      expect(job.status, PaymentStatus.completed);
      expect(job.downloadUrl, isNotNull);
    });
  });

  group('getEstimatedExportRows', () {
    test('returns count', () async {
      final count = await repository.getEstimatedExportRows(
        startDate: DateTime(2020),
        endDate: DateTime(2030),
      );
      expect(count, 18);
    });
  });
}
