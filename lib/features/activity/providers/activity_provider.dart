import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/data/datasources/mock_activity_remote_datasource.dart';
import 'package:tisini/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';
import 'package:tisini/features/activity/domain/repositories/activity_repository.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepositoryImpl(datasource: MockActivityRemoteDatasource());
});

final transactionFiltersProvider = AutoDisposeStateProvider<TransactionFilters>(
  (ref) => const TransactionFilters(),
);

class TransactionListNotifier
    extends
        AutoDisposeAsyncNotifier<
          ({List<Transaction> transactions, bool hasMore})
        > {
  String? _nextCursor;

  @override
  Future<({List<Transaction> transactions, bool hasMore})> build() async {
    final filters = ref.watch(transactionFiltersProvider);
    final repo = ref.watch(activityRepositoryProvider);
    _nextCursor = null;

    final result = await repo.getTransactions(filters: filters);
    _nextCursor = result.nextCursor;
    return (transactions: result.transactions, hasMore: result.hasMore);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;

    final filters = ref.read(transactionFiltersProvider);
    final repo = ref.read(activityRepositoryProvider);

    final result = await repo.getTransactions(
      filters: filters,
      cursor: _nextCursor,
    );

    _nextCursor = result.nextCursor;
    state = AsyncData((
      transactions: [...current.transactions, ...result.transactions],
      hasMore: result.hasMore,
    ));
  }
}

final transactionListProvider =
    AutoDisposeAsyncNotifierProvider<
      TransactionListNotifier,
      ({List<Transaction> transactions, bool hasMore})
    >(TransactionListNotifier.new);

final transactionDetailProvider = FutureProvider.autoDispose
    .family<Transaction, String>((ref, id) async {
      final repo = ref.watch(activityRepositoryProvider);
      return repo.getTransaction(id);
    });

final updateCategoryProvider = FutureProvider.autoDispose
    .family<Transaction, ({String id, TransactionCategory category})>((
      ref,
      params,
    ) async {
      final repo = ref.watch(activityRepositoryProvider);
      return repo.updateCategory(
        transactionId: params.id,
        category: params.category,
      );
    });

final pinMerchantProvider = FutureProvider.autoDispose
    .family<Transaction, ({String id, MerchantRole role})>((ref, params) async {
      final repo = ref.watch(activityRepositoryProvider);
      return repo.pinMerchant(transactionId: params.id, role: params.role);
    });
