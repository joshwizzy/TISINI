import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/activity/domain/entities/transaction.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';
import 'package:tisini/features/activity/presentation/widgets/date_group_header.dart';
import 'package:tisini/features/activity/presentation/widgets/filter_chip_bar.dart';
import 'package:tisini/features/activity/providers/activity_provider.dart';
import 'package:tisini/shared/widgets/transaction_row.dart';

class ActivityListScreen extends ConsumerStatefulWidget {
  const ActivityListScreen({super.key});

  @override
  ConsumerState<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends ConsumerState<ActivityListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      ref.read(transactionListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(transactionListProvider);
    final filters = ref.watch(transactionFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [
          IconButton(
            icon: Icon(
              PhosphorIconsBold.funnel,
              color: filters.isEmpty ? null : AppColors.cyan,
            ),
            onPressed: () => context.pushNamed(RouteNames.activityFilters),
          ),
          IconButton(
            icon: const Icon(PhosphorIconsBold.export),
            onPressed: () => context.pushNamed(RouteNames.exportPeriod),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!filters.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: FilterChipBar(
                filters: filters,
                onClearAll: () {
                  ref.read(transactionFiltersProvider.notifier).state =
                      const TransactionFilters();
                },
              ),
            ),
          Expanded(
            child: listAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Something went wrong',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => ref.invalidate(transactionListProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (data) {
                if (data.transactions.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIconsBold.clockCounterClockwise,
                          size: 48,
                          color: AppColors.grey,
                        ),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          'No transactions yet',
                          style: AppTypography.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(transactionListProvider);
                    await ref.read(transactionListProvider.future);
                  },
                  child: _buildTransactionList(data.transactions),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    final items = <Widget>[];
    DateTime? lastDate;

    for (final txn in transactions) {
      final txnDate = DateTime(
        txn.createdAt.year,
        txn.createdAt.month,
        txn.createdAt.day,
      );

      if (lastDate == null || txnDate != lastDate) {
        items.add(DateGroupHeader(date: txnDate));
        lastDate = txnDate;
      }

      items.add(
        TransactionRow(
          transaction: txn,
          onTap: () => context.pushNamed(
            RouteNames.transactionDetail,
            pathParameters: {'id': txn.id},
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      itemCount: items.length,
      itemBuilder: (_, index) => items[index],
    );
  }
}
