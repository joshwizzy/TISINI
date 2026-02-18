import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/domain/entities/pinned_merchant.dart';

class MerchantTile extends StatelessWidget {
  const MerchantTile({required this.merchant, this.onTap, super.key});

  final PinnedMerchant merchant;
  final VoidCallback? onTap;

  String _roleLabel(MerchantRole role) {
    return switch (role) {
      MerchantRole.supplier => 'Supplier',
      MerchantRole.rent => 'Rent',
      MerchantRole.wages => 'Wages',
      MerchantRole.tax => 'Tax',
      MerchantRole.pension => 'Pension',
      MerchantRole.utilities => 'Utilities',
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(merchant.name, style: AppTypography.bodyMedium),
      subtitle: Text(
        merchant.identifier,
        style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        child: Text(
          _roleLabel(merchant.role),
          style: AppTypography.labelSmall.copyWith(color: AppColors.darkBlue),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      onTap: onTap,
    );
  }
}
