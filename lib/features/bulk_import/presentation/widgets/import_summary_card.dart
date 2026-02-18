import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/features/bulk_import/domain/entities/import_result.dart';

class ImportSummaryCard extends StatelessWidget {
  const ImportSummaryCard({required this.result, super.key});

  final ImportResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadii.cardBorder,
        border: Border.all(color: AppColors.darkBlue.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          _SummaryRow(
            icon: PhosphorIconsBold.checkCircle,
            iconColor: AppColors.success,
            label: 'Imported',
            value: '${result.totalImported}',
          ),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(
            icon: PhosphorIconsBold.tag,
            iconColor: AppColors.green,
            label: 'Categorised',
            value: '${result.categorised}',
          ),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(
            icon: PhosphorIconsBold.question,
            iconColor: AppColors.warning,
            label: 'Uncategorised',
            value: '${result.uncategorised}',
          ),
          if (result.errors.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(
              icon: PhosphorIconsBold.warningCircle,
              iconColor: AppColors.error,
              label: 'Errors',
              value: '${result.errors.length}',
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(label, style: AppTypography.bodyMedium)),
        Text(value, style: AppTypography.titleMedium),
      ],
    );
  }
}
