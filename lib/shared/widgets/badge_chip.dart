import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_typography.dart';

class BadgeChip extends StatelessWidget {
  const BadgeChip({
    required this.label,
    required this.iconName,
    required this.isEarned,
    super.key,
  });

  final String label;
  final String iconName;
  final bool isEarned;

  IconData _resolveIcon() {
    return switch (iconName) {
      'rocket' => PhosphorIconsBold.rocket,
      'shieldCheck' => PhosphorIconsBold.shieldCheck,
      'chartLineUp' => PhosphorIconsBold.chartLineUp,
      'database' => PhosphorIconsBold.database,
      'piggyBank' => PhosphorIconsBold.piggyBank,
      'trophy' => PhosphorIconsBold.trophy,
      'star' => PhosphorIconsBold.star,
      _ => PhosphorIconsBold.medal,
    };
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = isEarned ? AppColors.darkBlue : AppColors.grey;
    final labelColor = isEarned ? AppColors.darkBlue : AppColors.grey;
    final bgColor = isEarned
        ? AppColors.green.withValues(alpha: 0.15)
        : AppColors.background;

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_resolveIcon(), size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: labelColor),
          ),
        ],
      ),
    );
  }
}
