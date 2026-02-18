import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_radii.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/kyc/providers/kyc_flow_controller.dart';

class KycAccountTypeScreen extends ConsumerWidget {
  const KycAccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Account Type'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const Text(
            'Select your account type',
            style: AppTypography.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This determines what documents '
            "you'll need to provide.",
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: AppSpacing.lg),
          _TypeCard(
            icon: PhosphorIconsBold.buildings,
            title: 'Business',
            subtitle:
                'Registered business with '
                'a trading licence',
            onTap: () {
              ref
                  .read(kycFlowControllerProvider.notifier)
                  .selectAccountType(KycAccountType.business);
              context.goNamed(RouteNames.kycChecklist);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _TypeCard(
            icon: PhosphorIconsBold.motorcycle,
            title: 'Gig Worker',
            subtitle:
                'Freelancer or independent '
                'service provider',
            onTap: () {
              ref
                  .read(kycFlowControllerProvider.notifier)
                  .selectAccountType(KycAccountType.gig);
              context.goNamed(RouteNames.kycChecklist);
            },
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: AppRadii.cardBorder,
          border: Border.all(color: AppColors.darkBlue.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.darkBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.darkBlue, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(PhosphorIconsBold.caretRight, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}
