import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class NextDueBanner extends StatelessWidget {
  const NextDueBanner({
    required this.currency,
    required this.onContribute,
    super.key,
    this.nextDueDate,
    this.nextDueAmount,
  });

  final DateTime? nextDueDate;
  final double? nextDueAmount;
  final String currency;
  final VoidCallback onContribute;

  String _formatAmount(double value) {
    return NumberFormat.currency(symbol: '', decimalDigits: 0).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.darkBlue.withValues(alpha: 0.05),
        borderRadius: AppRadii.cardBorder,
        border: Border.all(color: AppColors.darkBlue.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Next Contribution Due', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          if (nextDueDate != null)
            Text(
              DateFormat('dd MMM yyyy').format(nextDueDate!),
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
            ),
          if (nextDueAmount != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              '$currency ${_formatAmount(nextDueAmount!)}',
              style: AppTypography.amountMedium,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onContribute,
              child: const Text('Contribute now'),
            ),
          ),
        ],
      ),
    );
  }
}
