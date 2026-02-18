import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/activity/domain/entities/transaction_filters.dart';

class FilterChipBar extends StatelessWidget {
  const FilterChipBar({
    required this.filters,
    required this.onClearAll,
    super.key,
  });

  final TransactionFilters filters;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    if (filters.direction != null) {
      final label = filters.direction == TransactionDirection.inbound
          ? 'Inbound'
          : 'Outbound';
      chips.add(_buildChip(label));
    }

    if (filters.categories.isNotEmpty) {
      final label = filters.categories.length == 1
          ? _categoryLabel(filters.categories.first)
          : '${filters.categories.length} categories';
      chips.add(_buildChip(label));
    }

    if (filters.startDate != null || filters.endDate != null) {
      chips.add(_buildChip('Date range'));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        children: [
          ...chips,
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: onClearAll,
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                border: Border.all(color: AppColors.error),
              ),
              child: Center(
                child: Text(
                  'Clear all',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.cyan.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadii.pill),
          border: Border.all(color: AppColors.cyan),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(color: AppColors.cyan),
          ),
        ),
      ),
    );
  }

  String _categoryLabel(TransactionCategory category) {
    return switch (category) {
      TransactionCategory.sales => 'Sales',
      TransactionCategory.inventory => 'Inventory',
      TransactionCategory.bills => 'Bills',
      TransactionCategory.people => 'People',
      TransactionCategory.compliance => 'Compliance',
      TransactionCategory.agency => 'Agency',
      TransactionCategory.uncategorised => 'Uncategorised',
    };
  }
}
