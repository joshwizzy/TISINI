import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class PermissionCard extends StatelessWidget {
  const PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isGranted,
    this.onRequest,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isGranted;
  final VoidCallback? onRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadii.cardBorder,
        border: const Border.fromBorderSide(AppBorders.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: AppColors.darkBlue),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(description, style: AppTypography.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (isGranted)
            const Icon(
              PhosphorIconsBold.checkCircle,
              color: AppColors.green,
              size: 24,
            )
          else
            TextButton(
              onPressed: onRequest,
              child: Text(
                'Enable',
                style: AppTypography.labelLarge.copyWith(color: AppColors.cyan),
              ),
            ),
        ],
      ),
    );
  }
}
