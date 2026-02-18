import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/pensions/domain/entities/pension_contribution.dart';

class ContributionRow extends StatelessWidget {
  const ContributionRow({required this.contribution, super.key});

  final PensionContribution contribution;

  Color _statusColor(ContributionStatus status) {
    return switch (status) {
      ContributionStatus.completed => AppColors.success,
      ContributionStatus.pending => AppColors.warning,
      ContributionStatus.failed => AppColors.error,
    };
  }

  String _statusLabel(ContributionStatus status) {
    return switch (status) {
      ContributionStatus.completed => 'Completed',
      ContributionStatus.pending => 'Pending',
      ContributionStatus.failed => 'Failed',
    };
  }

  String _formatAmount(double value) {
    return NumberFormat.currency(symbol: '', decimalDigits: 0).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(contribution.createdAt),
                  style: AppTypography.bodyMedium,
                ),
                if (contribution.reference != null)
                  Text(
                    contribution.reference!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${contribution.currency} '
                '${_formatAmount(contribution.amount)}',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(
                    contribution.status,
                  ).withValues(alpha: 0.1),
                  borderRadius: AppRadii.pillBorder,
                ),
                child: Text(
                  _statusLabel(contribution.status),
                  style: AppTypography.labelSmall.copyWith(
                    color: _statusColor(contribution.status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
