import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class LegalAboutScreen extends StatelessWidget {
  const LegalAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Legal & About'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          ListTile(
            title: const Text(
              'Terms of Service',
              style: AppTypography.bodyMedium,
            ),
            trailing: const Icon(
              Icons.open_in_new,
              size: 20,
              color: AppColors.grey,
            ),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Terms of Service')));
            },
          ),
          ListTile(
            title: const Text(
              'Privacy Policy',
              style: AppTypography.bodyMedium,
            ),
            trailing: const Icon(
              Icons.open_in_new,
              size: 20,
              color: AppColors.grey,
            ),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Privacy Policy')));
            },
          ),
          ListTile(
            title: const Text(
              'Open Source Licences',
              style: AppTypography.bodyMedium,
            ),
            trailing: const Icon(
              Icons.open_in_new,
              size: 20,
              color: AppColors.grey,
            ),
            onTap: () => showLicensePage(context: context),
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Text(
              'Tisini v1.0.0',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text(
              'New payment rails coming soon',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
