import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class ColumnMappingRow extends StatelessWidget {
  const ColumnMappingRow({
    required this.label,
    required this.columns,
    required this.selectedColumn,
    required this.onChanged,
    this.sampleValue,
    super.key,
  });

  final String label;
  final List<String> columns;
  final String? selectedColumn;
  final ValueChanged<String?> onChanged;
  final String? sampleValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<String>(
            initialValue: selectedColumn,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              hintText: 'Select column',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.grey,
              ),
            ),
            items: columns
                .map(
                  (col) => DropdownMenuItem(
                    value: col,
                    child: Text(col, style: AppTypography.bodyMedium),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
          if (sampleValue != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Sample: $sampleValue',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
