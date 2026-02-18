import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';

class MerchantRoleSheet extends StatelessWidget {
  const MerchantRoleSheet({required this.onSelected, super.key, this.selected});

  final MerchantRole? selected;
  final ValueChanged<MerchantRole> onSelected;

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
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pin Merchant As', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.md),
          ...MerchantRole.values.map((role) {
            final isSelected = role == selected;
            return ListTile(
              title: Text(_roleLabel(role)),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.cyan)
                  : null,
              onTap: () {
                onSelected(role);
                Navigator.of(context).pop();
              },
            );
          }),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
