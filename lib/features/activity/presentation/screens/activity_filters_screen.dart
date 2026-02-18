import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';
import 'package:tisini/features/activity/providers/activity_provider.dart';
import 'package:tisini/shared/widgets/category_tag.dart';

class ActivityFiltersScreen extends ConsumerStatefulWidget {
  const ActivityFiltersScreen({super.key});

  @override
  ConsumerState<ActivityFiltersScreen> createState() =>
      _ActivityFiltersScreenState();
}

class _ActivityFiltersScreenState extends ConsumerState<ActivityFiltersScreen> {
  TransactionDirection? _direction;
  List<TransactionCategory> _categories = [];
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(transactionFiltersProvider);
    _direction = filters.direction;
    _categories = List.from(filters.categories);
    if (filters.startDate != null && filters.endDate != null) {
      _dateRange = DateTimeRange(
        start: filters.startDate!,
        end: filters.endDate!,
      );
    }
  }

  void _apply() {
    ref.read(transactionFiltersProvider.notifier).state = TransactionFilters(
      direction: _direction,
      categories: _categories,
      startDate: _dateRange?.start,
      endDate: _dateRange?.end,
    );
    Navigator.of(context).pop();
  }

  void _clear() {
    ref.read(transactionFiltersProvider.notifier).state =
        const TransactionFilters();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [TextButton(onPressed: _clear, child: const Text('Clear'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const Text('Direction', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<TransactionDirection?>(
            segments: const [
              ButtonSegment(value: null, label: Text('All')),
              ButtonSegment(
                value: TransactionDirection.inbound,
                label: Text('In'),
              ),
              ButtonSegment(
                value: TransactionDirection.outbound,
                label: Text('Out'),
              ),
            ],
            selected: {_direction},
            onSelectionChanged: (selected) {
              setState(() => _direction = selected.first);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Categories', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: TransactionCategory.values.map((cat) {
              final isSelected = _categories.contains(cat);
              return CategoryTag(
                category: cat,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _categories.remove(cat);
                    } else {
                      _categories.add(cat);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Date Range', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
                initialDateRange: _dateRange,
              );
              if (picked != null) {
                setState(() => _dateRange = picked);
              }
            },
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text(
              _dateRange != null
                  ? '${_formatDate(_dateRange!.start)}'
                        ' - ${_formatDate(_dateRange!.end)}'
                  : 'Select date range',
            ),
          ),
          if (_dateRange != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(() => _dateRange = null),
                child: Text(
                  'Clear dates',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          FilledButton(onPressed: _apply, child: const Text('Apply')),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
