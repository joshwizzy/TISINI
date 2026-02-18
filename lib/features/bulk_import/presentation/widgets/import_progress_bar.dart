import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class ImportProgressBar extends StatelessWidget {
  const ImportProgressBar({
    required this.processedRows,
    required this.totalRows,
    required this.statusLabel,
    super.key,
  });

  final int processedRows;
  final int totalRows;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final progress = totalRows > 0 ? processedRows / totalRows : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.darkBlue.withValues(alpha: 0.1),
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green),
          minHeight: 8,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$processedRows / $totalRows rows',
              style: AppTypography.bodySmall,
            ),
            Text(
              statusLabel,
              style: AppTypography.labelSmall.copyWith(color: AppColors.green),
            ),
          ],
        ),
      ],
    );
  }
}
