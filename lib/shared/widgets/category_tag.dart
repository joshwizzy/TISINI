import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';

class CategoryTag extends StatelessWidget {
  const CategoryTag({
    required this.category,
    super.key,
    this.isSelected = false,
    this.onTap,
  });

  final TransactionCategory category;
  final bool isSelected;
  final VoidCallback? onTap;

  Color _categoryColor(TransactionCategory category) {
    return switch (category) {
      TransactionCategory.sales => AppColors.success,
      TransactionCategory.inventory => AppColors.cyan,
      TransactionCategory.bills => AppColors.warning,
      TransactionCategory.people => AppColors.darkBlue,
      TransactionCategory.compliance => AppColors.red,
      TransactionCategory.agency => AppColors.grey,
      TransactionCategory.uncategorised => AppColors.grey,
    };
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

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(category);
    final bgColor = isSelected
        ? color.withValues(alpha: 0.15)
        : AppColors.background;
    final fgColor = isSelected ? color : AppColors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          border: Border.all(color: isSelected ? color : AppColors.cardBorder),
        ),
        child: Center(
          child: Text(
            _categoryLabel(category),
            style: AppTypography.labelMedium.copyWith(color: fgColor),
          ),
        ),
      ),
    );
  }
}
