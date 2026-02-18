import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/data/models/export_job_model.dart';
import 'package:tisini/features/activity/data/models/transaction_model.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';

abstract class ActivityRemoteDatasource {
  Future<
    ({List<TransactionModel> transactions, String? nextCursor, bool hasMore})
  >
  getTransactions({
    TransactionFilters? filters,
    String? cursor,
    int limit = 20,
  });

  Future<TransactionModel> getTransaction(String id);

  Future<TransactionModel> updateCategory({
    required String transactionId,
    required TransactionCategory category,
  });

  Future<TransactionModel> pinMerchant({
    required String transactionId,
    required MerchantRole role,
  });

  Future<TransactionModel> updateNote({
    required String transactionId,
    required String note,
  });

  Future<ExportJobModel> createExport({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<int> getEstimatedExportRows({
    required DateTime startDate,
    required DateTime endDate,
  });
}
