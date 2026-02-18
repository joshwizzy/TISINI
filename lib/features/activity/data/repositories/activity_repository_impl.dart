import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/data/datasources/activity_remote_datasource.dart';
import 'package:tisini/features/activity/domain/entities/export_job.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';
import 'package:tisini/features/activity/domain/repositories/activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl({required ActivityRemoteDatasource datasource})
    : _datasource = datasource;

  final ActivityRemoteDatasource _datasource;

  @override
  Future<({List<Transaction> transactions, String? nextCursor, bool hasMore})>
  getTransactions({
    TransactionFilters? filters,
    String? cursor,
    int limit = 20,
  }) async {
    final result = await _datasource.getTransactions(
      filters: filters,
      cursor: cursor,
      limit: limit,
    );
    return (
      transactions: result.transactions.map((m) => m.toEntity()).toList(),
      nextCursor: result.nextCursor,
      hasMore: result.hasMore,
    );
  }

  @override
  Future<Transaction> getTransaction(String id) async {
    final model = await _datasource.getTransaction(id);
    return model.toEntity();
  }

  @override
  Future<Transaction> updateCategory({
    required String transactionId,
    required TransactionCategory category,
  }) async {
    final model = await _datasource.updateCategory(
      transactionId: transactionId,
      category: category,
    );
    return model.toEntity();
  }

  @override
  Future<Transaction> pinMerchant({
    required String transactionId,
    required MerchantRole role,
  }) async {
    final model = await _datasource.pinMerchant(
      transactionId: transactionId,
      role: role,
    );
    return model.toEntity();
  }

  @override
  Future<Transaction> updateNote({
    required String transactionId,
    required String note,
  }) async {
    final model = await _datasource.updateNote(
      transactionId: transactionId,
      note: note,
    );
    return model.toEntity();
  }

  @override
  Future<ExportJob> createExport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final model = await _datasource.createExport(
      startDate: startDate,
      endDate: endDate,
    );
    return model.toEntity();
  }

  @override
  Future<int> getEstimatedExportRows({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _datasource.getEstimatedExportRows(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
