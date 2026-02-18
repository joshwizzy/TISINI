import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/shared/widgets/category_tag.dart';

class CategorySelectorSheet extends StatelessWidget {
  const CategorySelectorSheet({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final TransactionCategory selected;
  final ValueChanged<TransactionCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Category', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: TransactionCategory.values.map((cat) {
              return CategoryTag(
                category: cat,
                isSelected: cat == selected,
                onTap: () {
                  onSelected(cat);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
