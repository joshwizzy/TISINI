import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/export_job.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';

abstract class ActivityRepository {
  Future<({List<Transaction> transactions, String? nextCursor, bool hasMore})>
  getTransactions({
    TransactionFilters? filters,
    String? cursor,
    int limit = 20,
  });

  Future<Transaction> getTransaction(String id);

  Future<Transaction> updateCategory({
    required String transactionId,
    required TransactionCategory category,
  });

  Future<Transaction> pinMerchant({
    required String transactionId,
    required MerchantRole role,
  });

  Future<Transaction> updateNote({
    required String transactionId,
    required String note,
  });

  Future<ExportJob> createExport({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<int> getEstimatedExportRows({
    required DateTime startDate,
    required DateTime endDate,
  });
}
