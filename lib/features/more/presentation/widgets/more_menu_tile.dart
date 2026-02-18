import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class MoreMenuTile extends StatelessWidget {
  const MoreMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final PhosphorIconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PhosphorIcon(icon, color: AppColors.darkBlue),
      title: Text(title, style: AppTypography.bodyMedium),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
            )
          : null,
      trailing:
          trailing ??
          const PhosphorIcon(
            PhosphorIconsBold.caretRight,
            size: 20,
            color: AppColors.grey,
          ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      onTap: onTap,
    );
  }
}
