import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';

class RouteChip extends StatelessWidget {
  const RouteChip({
    required this.rail,
    required this.label,
    required this.isSelected,
    super.key,
    this.onTap,
    this.isAvailable = true,
  });

  final PaymentRail rail;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isAvailable;

  IconData _railIcon(PaymentRail rail) {
    return switch (rail) {
      PaymentRail.bank => PhosphorIconsBold.bank,
      PaymentRail.mobileMoney => PhosphorIconsBold.deviceMobile,
      PaymentRail.card => PhosphorIconsBold.creditCard,
      PaymentRail.wallet => PhosphorIconsBold.wallet,
    };
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? AppColors.darkBlue : AppColors.background;
    final fgColor = isSelected
        ? AppColors.white
        : isAvailable
        ? AppColors.darkBlue
        : AppColors.grey;

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          border: Border.all(
            color: isSelected ? AppColors.darkBlue : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_railIcon(rail), size: 16, color: fgColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(color: fgColor),
            ),
          ],
        ),
      ),
    );
  }
}
